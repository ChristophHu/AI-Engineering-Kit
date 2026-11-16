---
name: performance-optimization
description: Optimiert gemessene Performance von Frontend, Backend, Abfragen und Datenbanken. Nutze den Skill bei Performanceanforderungen, vermuteten Regressionen, langsamen Ladezeiten, N+1-Abfragen oder durch Profiling erkannten Engpässen.
---

# Performance optimieren

## Überblick

Miss vor der Optimierung. Ohne Messung beruhen Performanceänderungen auf Vermutungen und können Komplexität hinzufügen, ohne relevante Verbesserungen zu erzielen. Führe zuerst Profiling durch, ermittle und behebe den tatsächlichen Engpass und miss erneut. Optimiere, was laut Messung relevant ist.

## Wann verwenden

- Die Spec enthält Performanceanforderungen, etwa Ladezeitbudgets oder Antwortzeit-SLAs
- Nutzer oder Monitoring melden langsames Verhalten
- Core Web Vitals erreichen vereinbarte Schwellenwerte nicht
- Eine Änderung steht unter Regressionsverdacht
- Features verarbeiten große Datenmengen oder hohen Datenverkehr

**Nicht verwenden:** Optimiere nicht ohne Hinweise auf ein Problem. Vorzeitige Optimierung kann mehr Komplexität verursachen, als sie an Leistung gewinnt.

## Zielwerte für Core Web Vitals

Diese Metriken gelten nur für Webangebote, nicht für native Apple-Apps, Backenddienste oder Datenbanken. Wähle Metriken und Zielwerte anhand der Projektanforderungen und Plattform; die Tabelle ist eine Webreferenz und keine allgemeine Abnahmeschranke.

| Metrik | Gut | Verbesserungsbedürftig | Schlecht |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | ≤ 200ms | ≤ 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | ≤ 0.25 | > 0.25 |

## Optimierungsablauf

```
1. MESSEN       → Repräsentativen Ausgangswert mit verfügbaren Daten erfassen
2. ERMITTELN    → Tatsächlichen statt angenommenen Engpass finden
3. BEHEBEN      → Konkreten Engpass bearbeiten
4. ÜBERPRÜFEN   → Erneut messen; beibehalten oder zurücknehmen
5. ABSICHERN    → Monitoring oder Tests gegen Regressionen ergänzen
```

### Schritt 1: Messen

Wähle zur Plattform und Datenlage passende Messungen. Für Webanwendungen ergänzen sich, soweit verfügbar, folgende Ansätze:

- **Synthetisch (Lighthouse, DevTools Performance-Tab):** Kontrollierte, reproduzierbare Bedingungen; geeignet für CI-Regressionsprüfungen und die Eingrenzung konkreter Probleme.
- **RUM (web-vitals-Bibliothek, CrUX):** Echte Nutzerdaten unter realen Bedingungen, sofern verfügbar und angemessen. Fehlen Felddaten, melde die Einschränkung und verwende repräsentative synthetische Messungen, ohne eine Validierung anhand von Felddaten zu behaupten. Nutze für native Apple-Apps plattformgerechtes Profiling; miss bei Backend und Datenbank relevante Latenz, Durchsatz, Ressourcennutzung und Abfragepläne.

**Frontend:**
```javascript
// Synthetic: Lighthouse in Chrome DevTools (or CI)
// Chrome DevTools → Performance tab → Record
// Chrome DevTools MCP → Performance trace

// RUM: Web Vitals library in code
import { onLCP, onINP, onCLS } from 'web-vitals';

onLCP(console.log);
onINP(console.log);
onCLS(console.log);
```

**Backend:**
```javascript
// Response time logging
// Application Performance Monitoring (APM)
// Database query logging with timing

// Simple timing
console.time('db-query');
const result = await db.query(...);
console.timeEnd('db-query');
```

### Wo die Messung beginnt

Wähle die erste Messung anhand des Symptoms:

```
Was ist langsam?
├── Erster Seitenaufruf
│   ├── Großes Bundle? --> Bundle-Größe messen, Code Splitting prüfen
│   ├── Langsame Serverantwort? --> TTFB im DevTools-Netzwerk-Wasserfall messen
│   │   ├── DNS langsam? --> dns-prefetch / preconnect für bekannte Origins ergänzen
│   │   ├── TCP/TLS langsam? --> HTTP/2 aktivieren, Edge-Deployment und keep-alive prüfen
│   │   └── Serverwartezeit hoch? --> Backend profilieren, Abfragen und Caching prüfen
│   └── Rendering-blockierende Ressourcen? --> Netzwerk-Wasserfall auf blockierendes CSS/JS prüfen
├── Interaktion wirkt träge
│   ├── UI friert beim Klick ein? --> Main Thread profilieren, lange Aufgaben (>50ms) suchen
│   ├── Verzögerte Formulareingabe? --> Re-Renders und Aufwand kontrollierter Komponenten prüfen
│   └── Ruckelnde Animation? --> Layout Thrashing und erzwungene Reflows prüfen
├── Seite nach Navigation
│   ├── Daten laden? --> API-Antwortzeiten messen und Wasserfälle prüfen
│   └── Client-Rendering? --> Renderzeit der Komponenten profilieren und N+1-Abrufe prüfen
└── Backend / API
    ├── Einzelner Endpunkt langsam? --> Datenbankabfragen profilieren und Indizes prüfen
    ├── Alle Endpunkte langsam? --> Connection Pool, Speicher und CPU prüfen
    └── Zeitweise langsam? --> Lock Contention, GC-Pausen und externe Abhängigkeiten prüfen
```

### Schritt 2: Engpass ermitteln

Häufige Engpässe nach Kategorie:

**Frontend:**

| Symptom | Mögliche Ursache | Untersuchung |
|---------|-------------|---------------|
| Langsamer LCP | Große Bilder, Rendering-blockierende Ressourcen, langsamer Server | Netzwerk-Wasserfall und Bildgrößen prüfen |
| Hoher CLS | Bilder ohne Maße, spät ladende Inhalte, Schriftverschiebungen | Zuordnung der Layoutverschiebungen prüfen |
| Schlechter INP | Aufwendiges JavaScript im Main Thread, große DOM-Aktualisierungen | Lange Aufgaben im Performance Trace prüfen |
| Langsamer erster Aufruf | Großes Bundle, viele Netzwerkanfragen | Bundle-Größe und Code Splitting prüfen |

**Backend:**

| Symptom | Mögliche Ursache | Untersuchung |
|---------|-------------|---------------|
| Langsame API-Antworten | N+1-Abfragen, fehlende Indizes, unoptimierte Abfragen | Datenbankabfrage-Log prüfen |
| Wachsender Speicherbedarf | Nicht freigegebene Referenzen, unbegrenzte Caches, große Nutzlasten | Heap-Snapshot analysieren |
| CPU-Spitzen | Aufwendige synchrone Berechnungen, Regex-Backtracking | CPU-Profiling |
| Hohe Latenz | Fehlendes Caching, doppelte Berechnungen, Netzwerkstationen | Anfragen durch den Stack verfolgen |

### Schritt 3: Engpass beheben

Behebe den in Schritt 2 ermittelten Engpass. Die folgenden Antipatterns nennen Erkennungsmerkmale und verweisen auf ausgearbeitete Korrekturen in [references/optimization-patterns.md](references/optimization-patterns.md). Öffne den benötigten Abschnitt bei der Arbeit am betreffenden Code.

**Backend**

- **N+1-Abfragen.** Eine Abfrage pro Zeile ist ein häufiger Backend-Engpass. Lade die Beziehung in derselben Abfrage (join/include) statt in der Schleife. [Muster](references/optimization-patterns.md#n1-queries-backend).
- **Unbegrenzter Datenabruf.** Jeder Listenendpunkt paginiert mit Limit und stabiler Reihenfolge. [Muster](references/optimization-patterns.md#unbounded-data-fetching).
- **Abfragen, die ihren Index nicht nutzen.** „Index hinzufügen“ ist eine Vermutung; `EXPLAIN ANALYZE` liefert die Messung. Ein unerwarteter `Seq Scan`, eine um eine Größenordnung falsche `rows=`-Schätzung und ein `Sort`-Knoten oberhalb des Scans verlangen unterschiedliche Korrekturen. Eine falsche `rows=`-Schätzung kann auf veraltete Statistiken hinweisen; erwäge `ANALYZE` statt eines neuen Index. Richte den Index an der Abfrage aus: zuerst Gleichheitsspalten, dann Bereichs- oder Sortierspalte. Ein einfacher Index hilft weder bei einem dominanten Wert mit geringer Selektivität — ein partieller Index kann seltene Werte abdecken — noch bei führendem Wildcard oder einer Funktion auf der Spalte; hierfür kommen Trigramm- oder Volltextsuche beziehungsweise ein Ausdrucksindex wie bei `WHERE lower(email) = ?` infrage. Jeder Index belastet Schreibvorgänge. Prüfe den Plan danach erneut. Fehlt ein messbarer Nutzen, bewerte andere vereinbarte Vorteile und schlage gegebenenfalls eine sichere Rücknahme vor; bewahre vorhandene Arbeit und hole erforderliche Autorisierung ein. [Muster](references/optimization-patterns.md#queries-that-ignore-their-index).
- **Erschöpfter Connection Pool.** Anzeichen: *Alle* Endpunkte werden gleichzeitig langsam, Zeit wird beim Warten auf eine Verbindung statt bei der Ausführung verbracht, und die Datenbank zeigt überwiegend inaktive Sitzungen. Verwende einen Pool je Prozess und dimensioniere ihn so, dass `instances × max` unter der Verbindungsgrenze der Datenbank bleibt. Ein größerer Pool verschiebt die Warteschlange möglicherweise nur in die Datenbank. Bei unbegrenzter Instanzzahl durch Serverless oder Autoscaling verwende einen Proxy wie pgbouncer oder RDS Proxy, statt `max` zu erhöhen. [Muster](references/optimization-patterns.md#connection-pool-exhaustion).
- **Fehlendes Caching.** Cache teuer erzeugte Daten, die wesentlich häufiger gelesen als geändert werden. Das Caching einer bereits schnellen Abfrage fügt sonst einen Netzwerkaufruf und das Risiko veralteter Daten hinzu. Wähle die Ebene bewusst: prozessintern, gemeinsam oder CDN. Jede antwortrelevante Eingabe gehört in den Schlüssel, darunter Mandant, Spracheinstellung, Berechtigungen und Feature Flags; ein fehlender Nutzerbezug kann Daten an andere Nutzer ausliefern. Wähle eine Invalidierungsstrategie wie TTL, Ereignisse, Tags oder versionierte Schlüssel und lege die akzeptable Veralterungsdauer fest. Schütze stark genutzte Schlüssel vor einem Stampede, etwa durch vorübergehend veraltete Antworten während einer Neuberechnung oder durch Zusammenfassen gleichzeitiger Cache-Misses. Cache niemals Daten, die aktuell sein müssen, etwa Kontostände, Berechtigungen oder Lagerbestand beim Checkout. [Muster](references/optimization-patterns.md#missing-caching-backend); Request Coalescing, Schreibstrategien und Negative Caching stehen in `.codex/ai-engineering/references/performance-checklist.md` relativ zum Projektstamm.

**Frontend**

- **Fehlende Bildoptimierung.** Jedes Bild deklariert `width` und `height` zur Begrenzung von CLS. Das LCP-Bild erhält `fetchpriority="high"`, moderne Formate wie AVIF und WebP über `<picture>` sowie `srcset`/`sizes` für verschiedene Auflösungen. Bilder unterhalb des sichtbaren Bereichs erhalten `loading="lazy"` und `decoding="async"`. [Muster](references/optimization-patterns.md#missing-image-optimization-frontend).
- **Unnötige Re-Renders.** Bei jedem Rendern erzeugte Objekte oder Funktionen sind neue Referenzen und können empfangende Kindkomponenten erneut rendern. Lagere Konstanten aus; verwende `React.memo` und `useMemo` für laut Profiling aufwendige Arbeit, da auch übermäßiger Einsatz Kosten verursacht. [Muster](references/optimization-patterns.md#unnecessary-re-renders-react).
- **Große Bundles.** Moderne Bundler entfernen ungenutzte benannte ESM-Imports selbst. Größere Gewinne liefern Code Splitting auf Routenebene und Lazy Loading schwerer, selten verwendeter Features hinter `Suspense`. Profiliere vor Änderungen am Importstil. [Muster](references/optimization-patterns.md#large-bundle-size).

### Schritt 4: Überprüfen (beibehalten oder zurücknehmen)

Bis zur erneuten Messung ist eine Korrektur eine Hypothese. Dieser Schritt entscheidet über ihre weitere Behandlung.

**Miss wie beim Ausgangswert:** gleicher Befehl, gleiche Bedingungen und gleiches festgelegtes Budget für Laufzeit, Stichproben oder Anfragen. Ein Vergleich von kaltem und warmem Cache misst sonst den Cache statt der Änderung.

**Ändere jeweils eine Sache.** Drei zusammen gemessene Optimierungen lassen sich nicht einzeln zuordnen. Müssen sie gemeinsam ausgeliefert werden, miss sie zunächst isoliert.

**Übertriff die Messstreuung, nicht nur den Mittelwert.** Wiederhole die Messung und vergleiche die Differenz mit der Streuung zwischen Läufen. Ein Gewinn von 3 % bei ±5 % Streuung belegt keine Verbesserung.

Then decide, strictly:

| Ergebnis gegenüber Ausgangswert | Vorgehen |
|---|---|
| Schwellenwert übertroffen, Tests bestehen | **Beibehalten.** Vorher-/Nachher-Werte festhalten; gemäß autorisiertem Git-Workflow des Projekts committen. |
| Innerhalb der Streuung, keine messbare Änderung | Keine Verbesserung behaupten; andere vereinbarte Vorteile bewerten. |
| Schlechter | Nicht als Optimierung akzeptieren; untersuchen oder sichere Rücknahme vorschlagen. |
| Verbessert, aber ein Test schlägt fehl | Regression untersuchen und beheben oder sichere Rücknahme vorschlagen. |

**Ein neutrales Ergebnis ist kein Performancegewinn.** Prüfe andere vereinbarte Vorteile. Bewahre vorhandene Arbeit und Nutzeränderungen; verwerfe oder setze Änderungen nur mit erforderlicher Autorisierung zurück und folge `$git-workflow-and-versioning`.

**Korrektheit ist Voraussetzung.** Führe zur Änderung passende Tests und verpflichtende Projektprüfungen aus; melde bereits bestehende Fehler und nicht ausgeführte Pflichtprüfungen als offen. Behaupte keine verifizierte Verbesserung, solange erforderliche Korrektheitsprüfungen offen sind. Eine vermeintliche Optimierung, die benötigte Arbeit auslässt, etwa Validierung überspringt, aktuelle Daten cached oder ein erforderliches `await` entfernt, ist eine Regression.

#### Jeden Versuch dokumentieren, auch zurückgenommene

Zurückgenommene Arbeit hinterlässt möglicherweise keine Git-Historie. Dokumentiere Versuche kurz, damit verworfene Ideen nicht unnötig wiederholt werden:

| Idee | Ausgangswert → Ergebnis | Entscheidung | Grund |
|---|---|---|---|
| Zeilenkomponente memoizieren | INP 240ms → 235ms | zurückgenommen | Innerhalb der Streuung (±15ms); Zeilen waren nicht der Engpass. |
| Liste virtualisieren | INP 240ms → 90ms | beibehalten | Lange Aufgaben sind im Trace verschwunden. |
| Preconnect zum API-Origin | LCP 2.8s → 2.8s | zurückgenommen | Bereits same-origin. |

Ein Abschnitt in der PR-Beschreibung oder eine `PERF.md` im Repository eignen sich dafür. Wichtig ist, dass spätere Beteiligte die Ergebnisse vor neuen Experimenten lesen.

### Schritt 5: Gegen Regressionen absichern

Sichere die für Nutzer relevante Metrik ab. Verwende denselben LCP, INP, dieselbe p95-Latenz oder eine andere primäre Metrik, die die Korrektur begründet hat.

Wähle begründete und verfügbare Regressionsprüfungen. Die folgenden Webbeispiele gelten nicht als Pflicht für jede Plattform:

- **Synthetische CI-Schranke:** Erkenne reproduzierbare Regressionen vor dem Merge anhand eines Performancebudgets. Wiederhole streuende Messungen oder vergleiche Median und Trend, damit normale Schwankungen keine unzuverlässige Prüfung erzeugen.
- **Monitoring im Feld:** Alarmiere bei einer relevanten p75-Veränderung in RUM-Daten. Nutze zugeordnete `web-vitals`-Daten zur Ursachenlokalisierung; betrachte das rollierende CrUX-Fenster als Bestätigung statt als unmittelbaren Alarm.

Wenn eine dieser Prüfungen anschlägt, kehre zu Schritt 1 zurück und ermittle einen neuen Ausgangswert, bevor du eine weitere Korrektur vorschlägst.

**Beispielbudgets für Web und API:** Vereinbare relevante Schwellenwerte mit dem Projekt und setze diese Werte nicht allgemein voraus.

```
JavaScript-Bundle: < 200KB gzipped (erster Aufruf)
CSS: < 50KB gzipped
Images: < 200KB je Bild (im sichtbaren Bereich)
Fonts: < 100KB insgesamt
API response time: < 200ms (p95)
Time to Interactive: < 3.5s bei 4G
Lighthouse Performance score: ≥ 90
```

**In CI durchsetzen:**
```bash
# Bundle size check
npx bundlesize --config bundlesize.config.json

# Lighthouse CI. The CLI package is @lhci/cli; unscoped `lhci` on npm is not it.
npx --package=@lhci/cli lhci autorun
```

## Siehe auch

Ausführliche Web-Performance-Checklisten, Optimierungsbefehle und Hinweise zu Antipatterns stehen in `.codex/ai-engineering/references/performance-checklist.md` relativ zum Projektstamm.


## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Wir optimieren später.“ | Performance-Schulden können wachsen. Behebe offensichtliche Antipatterns und verschiebe Mikrooptimierungen. |
| „Auf meinem Rechner ist es schnell.“ | Nutze repräsentative Hardware und Netzwerke für das Profiling. |
| „Diese Optimierung ist offensichtlich.“ | Ohne Messung fehlt der Nachweis. Profiliere zuerst. |
| „100ms bemerken Nutzer nicht.“ | Untersuchungen zeigen mögliche Auswirkungen solcher Verzögerungen auf Konversionsraten. |
| „Das Framework kümmert sich um Performance.“ | Frameworks verhindern manche Probleme, aber keine N+1-Abfragen oder übergroßen Bundles. |
| „Die Abfrage ist langsam, ergänze einen Index.“ | Lies zuerst den Plan. Ein vorhandener Index könnte nicht nutzbar sein; jeder Index belastet Schreibvorgänge. |
| „Einfach cachen.“ | Das Caching bereits günstiger Aufrufe bringt wenig und kann veraltete Daten liefern. Cache teure, deutlich häufiger gelesene als geschriebene Daten. |
| „Poolgröße erhöhen, die Verbindungen reichen nicht.“ | Ein zu großer Pool verschiebt die Warteschlange. Ermittle, was Verbindungen belegt. |
| „Es hilft kaum, schadet aber auch nicht.“ | Ein nicht messbarer Gewinn rechtfertigt Komplexität nicht allein; bewerte andere vereinbarte Vorteile. |
| „Wir haben es schon geschrieben, behalten wir es.“ | Der bisherige Aufwand ändert das Messergebnis nicht. |
| „Die Verbesserung ist offensichtlich, Nachmessen ist unnötig.“ | Eine erneute Messung belegt den Effekt und verhindert unbegründete Komplexität. |

## Warnzeichen

- Optimierung ohne begründende Profiling-Daten
- N+1-Abfragemuster beim Datenabruf
- Ein Index ohne begründenden Abfrageplan vor und nach der Änderung
- Ein Cache-Schlüssel lässt eine antwortrelevante Eingabe wie Mandant, Spracheinstellung oder Nutzer aus
- Ein Cache ohne festgelegte Veralterungsdauer und Invalidierungsstrategie
- Die Connection-Pool-Größe wird bei Erschöpfung erhöht, ohne belegte Verbindungen zu untersuchen
- Listenendpunkte ohne Paginierung
- Bilder ohne Maße, Lazy Loading oder responsive Größen
- Wachsende Bundle-Größe ohne Prüfung
- Fehlendes Performance-Monitoring, obwohl Betriebsmodell und Risiko es rechtfertigen
- `React.memo` und `useMemo` überall; übermäßiger Einsatz ist ebenso problematisch wie fehlender Einsatz
- Optimierungen werden ohne begründende Nachmessung beibehalten
- Mehrere Optimierungen werden gemeinsam gemessen, sodass keine einzeln zugeordnet werden kann
- Ein vermeintlicher Gewinn setzt voraus, dass ein Test geändert, übersprungen oder gelöscht wird
- Ein fehlgeschlagener Optimierungsversuch wird mangels Dokumentation wiederholt

## Überprüfung

Nach einer performancebezogenen Änderung:

- [ ] Konkrete Vorher- und Nachher-Messwerte liegen vor
- [ ] Das Ergebnis wurde wie der Ausgangswert mit gleichem Befehl und gleichen Bedingungen gemessen
- [ ] Die Verbesserung übertrifft die Streuung zwischen Läufen, nicht nur den Mittelwert
- [ ] Änderungen ohne Verbesserung gegenüber dem Ausgangswert werden nicht als Gewinn ausgegeben; Beibehalten oder sichere Rücknahme ist begründet
- [ ] Beibehaltene und zurückgenommene Versuche sind dokumentiert, um Wiederholungen zu vermeiden
- [ ] Der konkrete Engpass ist ermittelt und behoben
- [ ] Relevante plattformspezifische Metriken und vereinbarte Ziele sind bewertet; Web Vitals und Bundle-Größe nur, wenn anwendbar
- [ ] Relevante neue Datenabrufe wurden auf N+1-Abfragen geprüft
- [ ] Jeder neue Index ist durch Abfragepläne vor und nach der Änderung begründet; Schreibkosten wurden berücksichtigt
- [ ] Für jeden neuen Cache sind Schlüssel und Veralterung beschrieben
- [ ] Geeignete Regressionsprüfungen oder Monitoring für die gemessene Metrik wurden erwogen; nicht verfügbare Prüfungen sind gemeldet
- [ ] Relevante und verpflichtende Projekttests wurden ausgeführt; Fehler und nicht ausgeführte Pflichtprüfungen sind offen gemeldet
