---
name: observability-and-instrumentation
description: Macht Produktionsverhalten durch Logging, Metriken, Tracing und Alerting sichtbar und diagnostizierbar. Nutze den Skill bei der Instrumentierung produktiver Funktionen und wenn vorhandene Daten zur Untersuchung von Produktionsproblemen nicht ausreichen.
---

# Observability und Instrumentierung

## Überblick

Observability ermöglicht es, anhand der ausgegebenen Telemetrie von außen zu beantworten, was ein System tut und warum. Instrumentierung entsteht zusammen mit dem Feature, ähnlich wie Tests. Ohne passende Telemetrie wird die Untersuchung gemeldeter Produktionsfehler unnötig aufwendig.

## Wann verwenden

- Ein Feature erstellen, das in Produktion laufen wird
- Einen Dienst, Endpunkt, Hintergrundjob oder eine externe Integration ergänzen
- Ein Produktionsvorfall konnte mangels Informationen nur langsam diagnostiziert werden
- Alerting-Regeln einrichten oder prüfen
- Einen PR mit I/O, Wiederholungen, Queues oder dienstübergreifenden Aufrufen prüfen

**Nicht verwenden für:**
- Die Diagnose eines aktuell auftretenden Fehlers; nutze `debugging-and-error-recovery`
- Profiling und Optimierung bereits gemessener Langsamkeit; nutze `performance-optimization`
- Monitoring-Checklisten und Rollback-Auslöser am Veröffentlichungstag; siehe `shipping-and-launch`. Dieser Skill behandelt die zugrunde liegende Instrumentierung.

## Vorgehen

### 1. Funktionieren vor der Instrumentierung definieren

Telemetrie benötigt einen Zweck. Halte vor der Instrumentierung zwei bis vier Fragen fest, die eine Person im Bereitschaftsdienst zu diesem Feature stellen wird:

```
FEATURE: Wiederholung einer Zahlung beim Checkout
FRAGEN IM BEREITSCHAFTSDIENST:
1. Welcher Anteil der Zahlungen gelingt beim ersten Versuch und welcher nach einer Wiederholung?
2. Warum schlägt eine Zahlung endgültig fehl? Anbieterfehler, Timeout oder Validierung?
3. Ist der Zahlungsanbieter langsamer als üblich?
→ Jedes nachfolgende Signal muss bei der Beantwortung einer dieser Fragen helfen.
```

Sind die Fragen unbekannt, kläre zuerst den Informationsbedarf, statt wahllos Daten zu protokollieren.

### 2. Das passende Signal je Frage wählen

| Signal | Beantwortet | Kostenprofil | Beispiel |
|---|---|---|---|
| **Strukturiertes Log** | „Was geschah in diesem Einzelfall?“ | Je Ereignis; wächst mit dem Datenverkehr | `payment_failed` mit Fehlercode des Anbieters |
| **Metrik** | „Wie oft oder wie schnell insgesamt?“ | Fest pro Zeitreihe; günstig abzufragen | p99-Latenz von Anbieteraufrufen |
| **Trace** | „Wo wurde dienstübergreifend Zeit benötigt?“ | Je Anfrage; meist stichprobenartig erfasst | Ein langsamer Checkout, aufgeschlüsselt nach Stationen |

Faustregel: Metriken zeigen, **dass** etwas falsch läuft; Traces zeigen, **wo**; Logs zeigen, **warum**.

### 3. Strukturiertes Logging

Protokolliere Ereignisse statt Freitext. Jede Logzeile ist ein JSON-Objekt mit stabilem Ereignisnamen und maschinenlesbaren Feldern:

```typescript
// BAD: string interpolation — unqueryable, inconsistent
logger.info(`Payment ${id} failed for user ${userId} after ${n} retries`);

// GOOD: stable event name + structured fields
logger.warn({
  event: 'payment_failed',
  paymentId: id,
  provider: 'stripe',
  errorCode: err.code,
  attempt: n,
}, 'payment failed');
```

**Log-Level einheitlich verwenden:**

| Level | Bedeutung | Reaktion im Bereitschaftsdienst |
|---|---|---|
| `error` | Invariante verletzt; möglicherweise ist eine Handlung nötig | Untersuchen |
| `warn` | Beeinträchtigt, aber behandelt, etwa erfolgreiche Wiederholung oder verwendeter Fallback | Entwicklung beobachten |
| `info` | Wesentliches fachliches Ereignis, etwa Bestellung oder abgeschlossener Job | Keine |
| `debug` | Diagnosedetail | In Produktion standardmäßig deaktiviert |

**Correlation IDs sind verpflichtend.** Erzeuge oder akzeptiere an der Systemgrenze eine Request-ID und füge sie jeder Logzeile, jedem Span und ausgehenden Aufruf hinzu. Ohne sie lässt sich eine einzelne Anfrage in vermischten Logs nicht zuverlässig nachvollziehen:

```typescript
// Express: child logger per request, ID propagated downstream
app.use((req, res, next) => {
  req.id = req.headers['x-request-id'] ?? crypto.randomUUID();
  req.log = logger.child({ requestId: req.id });
  res.setHeader('x-request-id', req.id);
  next();
});
```

**Wenn mehrere Einstiegspunkte in dasselbe Log schreiben, benenne den Einstiegspunkt.** Eine Correlation ID identifiziert einen Lauf, nicht den auslösenden Codepfad. Erreicht derselbe Job den gemeinsamen Log-Speicher über Scheduler, Replay-Endpunkt und manuellen CLI-Aufruf, ist eine Zuordnung sonst nur über zusätzliche Aufzeichnungen möglich. Setze den Einstiegspunkt beim Start neben der Correlation ID und gib beide gleichermaßen weiter:

```typescript
// One helper for every entry point: the run's own logger carries both fields.
// `entryPoint`, not `source` — ECS reserves `source.*` for network fields.
export const runLog = (entryPoint: 'scheduler' | 'replay_endpoint' | 'cli', runId: string) =>
  logger.child({ entryPoint, requestId: runId });

// scheduler tick        -> runLog('scheduler', crypto.randomUUID())
// POST /jobs/:id/replay -> runLog('replay_endpoint', req.id)
// CLI invocation        -> runLog('cli', process.env.RUN_ID ?? crypto.randomUUID())
```

Beide Felder müssen dieselben Grenzen wie die Correlation ID überschreiten, etwa Queue-Metadaten und HTTP-Header. Andernfalls müsste ein Worker den Einstiegspunkt erneut ableiten. Ein lediglich damit korrelierendes Feld ist ein Hinweis, keine eindeutige Zuordnung.

**Protokolliere niemals Geheimnisse, Tokens, Passwörter oder vollständige PII.** Dies ist eine verbindliche Regel aus `security-and-hardening`; Telemetriepipelines können Daten offenlegen. Erlaube Felder ausdrücklich per Allowlist und protokolliere keine vollständigen Anfrageinhalte.

### 4. Metriken

Instrumentiere bei anfragegesteuerten Diensten jeden Endpunkt und jede externe Abhängigkeit nach **RED**: **R**ate (Anfragen pro Sekunde), **E**rrors (Fehlerrate) und **D**uration (Latenzhistogramm statt Durchschnitt). Verwende für Ressourcen wie Queues, Pools und Hosts **USE**: **U**tilization, **S**aturation und **E**rrors.

Wie beim Tracing bietet die OpenTelemetry-Metrik-API einen herstellerneutralen Weg mit demselben SDK und Kontext wie in Schritt 5. Das Beispiel verwendet `prom-client` von Prometheus als eine mögliche Backend-Wahl; die Regeln zu RED/USE und Kardinalität gelten unabhängig davon.

```typescript
import { Histogram } from 'prom-client';

const httpDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'route', 'status_class'],  // '2xx', not '200'
  buckets: [0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
});
```

**Kardinalität ist ein zentrales Risiko.** Jede eindeutige Label-Kombination erzeugt eine eigene Zeitreihe. Labels müssen aus kleinen, festen Mengen stammen, etwa Routenvorlage, Statusklasse und Anbietername. Verwende niemals Nutzer-IDs, rohe URLs, Fehlermeldungen oder andere unbegrenzte Werte als Labels; solche Angaben gehören in Logs und Traces.

```
Als Label geeignet:    route="/api/tasks/:id"   status_class="5xx"   provider="stripe"
Niemals als Label:     user_id, email, request_id, vollständige URL, Fehlermeldungstext
```

Erfasse statt Durchschnittswerten Perzentile: Ein Durchschnitt verdeckt die Erfahrung des langsamsten Prozents der Nutzer. Verwende Histogramme und werte p50/p95/p99 aus.

### 5. Verteiltes Tracing

Verwende OpenTelemetry als herstellerneutralen Standard. Automatische Instrumentierung deckt HTTP, gRPC und gängige Datenbankclients mit wenig zusätzlichem Code ab:

```typescript
// tracing.ts — must be imported before anything else
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';

const sdk = new NodeSDK({
  serviceName: 'checkout-service',
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();
```

Ergänze manuelle Spans nur für aussagekräftige interne Arbeitseinheiten wie `applyDiscounts` und `chargeProvider` und füge die für den Bereitschaftsdienst relevanten Filterattribute hinzu. Gib Kontext über jede asynchrone Grenze weiter, etwa HTTP-Header und Queue-Nachrichtenmetadaten. Verwende standardmäßig eine niedrige Head-Sampling-Rate; behalte 100 % der Fehler, wenn das Backend Tail Sampling unterstützt.

### 6. Alerting

Alarmiere bei **Symptomen, die Nutzer bemerken**, statt bei Ursachen:

```
SYMPTOM (Bereitschaft alarmieren):    URSACHE (Dashboard, kein Alarm):
Fehlerrate > 1 % für 5 min           CPU bei 85 %
p99-Latenz > 2s                      Ein Pod wurde neu gestartet
Queue-Alter > 10 min                 Festplatte bei 70 %
```

Ursachenbasierte Alarme können ohne Nutzerbeeinträchtigung auslösen und unerwartete Fehler übersehen. Symptombasierte Alarme zeigen Auswirkungen auf Nutzer unabhängig von der Ursache.

Regeln für jeden neu erstellten Alarm:

1. **Er muss eine Handlung ermöglichen.** Lautet die Reaktion „ignorieren, behebt sich selbst“, entferne den Alarm.
2. **Er verweist auf ein Runbook**, mindestens mit Bedeutung, erster Abfrage und Eskalationsweg.
3. **Schwellenwert und Dauer** sind durch das SLO oder historische Daten begründet, nicht geraten.
4. Verwende nur zwei Schweregrade: **page** für unmittelbaren Handlungsbedarf bei Nutzerwirkung und **ticket** für Beeinträchtigungen, die diese Woche bearbeitet werden. Eine dritte Stufe kann unnötige Alarme erzeugen.

#### Runbooks erstellen

Regel 2 verlangt für jeden Alarm einen Runbook-Link. Das Runbook beantwortet drei Fragen: Was geschieht, was wird zuerst geprüft und wer wird kontaktiert, wenn dies nicht hilft? Speichere es unter `docs/runbooks/`, benannt nach dem Alarm.

**Minimales Runbook (drei Zeilen):**

```markdown
# Runbook: High Error Rate on /api/tasks
**Means:** DB connection pool likely exhausted, or a bad deploy.
**First check:** `SELECT count(*) FROM pg_stat_activity WHERE backend_type = 'client backend';`
  — if count > pool limit, see Step 2. (Swap in the equivalent for your database.)
**Escalate to:** #db-oncall or engineering on-call rotation.
```

**Wann mehr als drei Zeilen sinnvoll sind:** Ergänze Schritte nur, wenn die erste Prüfung für eine Entscheidung nicht ausreicht. Ein knappes Runbook für häufige Ursachen ist leichter nutzbar als eine lange Liste aller Randfälle.

**Halte Runbooks aktuell.** Aktualisiere ein genutztes Runbook beim Abschluss jedes Vorfalls. Korrigiere falsche oder fehlende Schritte, bevor der Vorfall als behoben gilt.

### 7. Telemetrie selbst überprüfen

Instrumentierung ist Code und kann Fehler enthalten. Löse vor Abschluss die relevanten Pfade aus und prüfe die tatsächliche Ausgabe:

- Einen Fehler in Staging auslösen → anhand von `requestId` in den Logs finden und strukturierte Felder statt `[object Object]` bestätigen
- Testverkehr senden → erwartete Labels und plausible Werte der Metrikreihen prüfen
- Eine Anfrage in der Tracing-UI dienstübergreifend verfolgen → keine unterbrochenen Spans
- Jeden neuen Alarm einmal auslösen, etwa durch vorübergehend niedrigere Schwelle → richtigen Kanal und funktionierenden Runbook-Link prüfen

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Logging ergänze ich, wenn es funktioniert.“ | Beim ersten Vorfall können wichtige Hinweise fehlen. Instrumentiere während der Umsetzung. |
| „Mehr Logs bedeuten mehr Observability.“ | Unstrukturierte Ausgaben erschweren die Diagnose. Wenige abfragbare Ereignisse können hilfreicher sein. |
| „console.log reicht vorerst.“ | Unstrukturierte Ausgaben lassen sich schlechter filtern, korrelieren und für Alarme nutzen. |
| „Bei Problemen sehen wir einfach ins Dashboard.“ | Ohne definierte Fragen zeigt ein Dashboard möglicherweise nicht die benötigte Antwort. Beginne mit Fragen des Bereitschaftsdiensts. |
| „Wir alarmieren bei allem und passen später an.“ | Viele unnötige Alarme führen dazu, dass wichtige Warnungen übersehen werden. |
| „Eine Nutzer-ID als Metriklabel vereinfacht die Fehlersuche.“ | Hohe Kardinalität kann das Metrik-Backend überlasten. Solche Suchwerte gehören in Logs und Traces. |
| „Tracing ist für zwei Dienste übertrieben.“ | Schon zwei Dienste erzeugen Fragen zu dienstübergreifender Latenz; automatische Instrumentierung reduziert den Aufwand. |

## Warnzeichen

- Ein Feature-PR ergänzt Wiederholungen, Queues oder externe Aufrufe ohne neue Telemetrie
- Logzeilen verwenden Zeichenketteninterpolation statt strukturierter Felder
- Eine Correlation ID oder Request-ID fehlt
- Ein gemeinsamer Logstrom für Scheduler, Webhook und manuelle Aufrufe enthält kein Feld für den Einstiegspunkt
- Metriken verwenden Nutzer-IDs, rohe URLs oder Fehlermeldungstexte als Labels und erzeugen hohe Kardinalität
- Latenz wird nur als Durchschnitt ohne Perzentile erfasst
- Alarme lösen täglich aus und werden ohne Handlung bestätigt
- Ursachen wie CPU oder Speicher alarmieren Menschen, während die nutzerseitige Fehlerrate nicht überwacht wird
- Geheimnisse, Tokens oder vollständige Anfrageinhalte erscheinen in Logs
- „Auf meinem Rechner funktioniert es“ ist der einzige Nachweis für den Zustand eines produktiven Features

## Überprüfung

Nach der Instrumentierung eines Features prüfen:

- [ ] Fragen des Bereitschaftsdiensts sind dokumentiert und jedes Signal ist einer Frage zugeordnet
- [ ] Alle Logausgaben sind strukturiert (JSON), mit stabilen Ereignisnamen und Correlation ID pro Zeile
- [ ] Jeder Log-Speicher mit mehreren Einstiegspunkten enthält ein beim Start gesetztes und mit der Correlation ID weitergegebenes Einstiegspunktfeld, das nicht nachgelagert abgeleitet wird
- [ ] Keine Logzeile enthält Geheimnisse, Tokens oder ungeschwärzte PII; tatsächliche Ausgaben wurden stichprobenartig geprüft
- [ ] RED-Metriken mit begrenzten Label-Mengen existieren für jeden neuen Endpunkt und jede externe Abhängigkeit
- [ ] Latenz liegt als Histogramm vor; p95/p99 sind abfragbar
- [ ] Eine Anfrage lässt sich in der Tracing-UI ohne unterbrochene Spans durchgängig verfolgen
- [ ] Jeder neue Alarm ist symptombasiert, verweist auf ein Runbook und wurde einmal testweise ausgelöst
- [ ] Ein in Staging ausgelöster Fehler wurde allein anhand der Telemetrie lokalisiert, ohne den Quellcode zu lesen

Eine kompakte Fassung dieser Liste einschließlich der Instrumentierungsprüfung vor Veröffentlichung steht in `.codex/ai-engineering/references/observability-checklist.md` relativ zum Projektstamm.
