---
name: shipping-and-launch
description: Bereitet Produktionsveröffentlichungen mit Prüfungen, Monitoring, gestuftem Rollout und Rücknahmeplan vor. Nutze den Skill bei der Release-Vorbereitung und zur Beurteilung der Voraussetzungen für ein Deployment.
---

# Veröffentlichung und Launch

## Überblick

Bereite Deployments mit Monitoring, Rücknahmeplan und klaren Erfolgskriterien vor. Ein Launch soll rücknehmbar, beobachtbar und schrittweise durchführbar sein.

## Wann verwenden

- Ein Feature erstmals in Produktion deployen
- Eine wesentliche Änderung für Nutzer veröffentlichen
- Daten oder Infrastruktur migrieren
- Eine Beta oder ein Early-Access-Programm öffnen
- Ein risikobehaftetes Deployment vorbereiten

## Checkliste vor dem Launch

Wähle die anwendbaren Prüfungen anhand von Plattform, Architektur, Betriebsmodell, Releaseumfang und vereinbarten Anforderungen. Kennzeichne jeden nicht zutreffenden Punkt als „nicht anwendbar“ mit kurzer Begründung; melde nicht verfügbare, fehlgeschlagene oder nicht ausgeführte Pflichtprüfungen als offen. Berücksichtige bestehende Projektprüfungen und tatsächlich vereinbarte Ausnahmen. Die nachfolgenden Punkte zu Browsern, Webseiten und Webmetriken gelten nur für zutreffende Weboberflächen; ein reines Backend oder eine native Apple-App benötigt stattdessen passende Dienst-, Simulator-, Geräte- oder Plattformprüfungen gemäß `$verify-ui`, `$deploy` und den Projektvorgaben.

### Codequalität

- [ ] Alle Tests bestehen (Unit, Integration, e2e)
- [ ] Der Build ist ohne Warnungen erfolgreich
- [ ] Lint und Typprüfung bestehen
- [ ] Der Code wurde geprüft und freigegeben
- [ ] Keine TODO-Kommentare sind offen, die vor dem Launch zu erledigen sind
- [ ] Keine `console.log`-Debugging-Ausgaben stehen im Produktionscode
- [ ] Die Fehlerbehandlung deckt erwartete Fehlerfälle ab

### Sicherheit

- [ ] Keine Geheimnisse im Code oder in der Versionsverwaltung
- [ ] Der Abhängigkeits-Audit des Ökosystems (`npm audit`, `pip-audit`, `cargo audit`, ...) zeigt keine kritischen oder hohen Sicherheitslücken
- [ ] Nutzereingaben werden an allen nutzerseitigen Endpunkten validiert
- [ ] Authentifizierung und Autorisierung werden geprüft
- [ ] Sicherheitsheader sind konfiguriert (CSP, HSTS usw.)
- [ ] Authentifizierungsendpunkte verfügen über Ratenbegrenzung
- [ ] CORS ist für bestimmte Origins und nicht als Wildcard konfiguriert

### Performance

- [ ] Bei Weboberflächen sind relevante Core Web Vitals gegen die vereinbarten Projektziele geprüft; bei anderen Plattformen passende Leistungsmetriken und Ziele
- [ ] Keine N+1-Abfragen auf kritischen Pfaden
- [ ] Bilder sind optimiert: Kompression, responsive Größen und Lazy Loading
- [ ] Die Bundle-Größe liegt innerhalb des Budgets
- [ ] Datenbankabfragen besitzen geeignete Indizes
- [ ] Caching für statische Assets und wiederholte Abfragen ist konfiguriert

### Barrierefreiheit

- [ ] Tastaturnavigation funktioniert für alle interaktiven Elemente
- [ ] Ein Screenreader kann Seiteninhalt und Struktur vermitteln
- [ ] Farbkontrast erfüllt WCAG 2.1 AA (4.5:1 für Text)
- [ ] Fokusverwaltung für Dialoge und dynamische Inhalte ist korrekt
- [ ] Fehlermeldungen sind aussagekräftig und Formularfeldern zugeordnet
- [ ] Bei Weboberflächen melden die anwendbaren Prüfwerkzeuge, etwa axe-core oder Lighthouse, keine Warnungen zur Barrierefreiheit; native Oberflächen wurden mit geeigneten Plattformwerkzeugen geprüft

### Infrastruktur

- [ ] Umgebungsvariablen sind in Produktion gesetzt
- [ ] Datenbankmigrationen sind angewendet oder zur Anwendung bereit
- [ ] DNS und SSL sind konfiguriert
- [ ] Ein CDN für statische Assets ist konfiguriert
- [ ] Logging und Fehlerberichterstattung sind konfiguriert
- [ ] Ein Health-Check-Endpunkt existiert und antwortet

### Dokumentation

- [ ] Die README enthält neue Setup-Anforderungen
- [ ] Die API-Dokumentation ist aktuell
- [ ] ADRs für Architekturentscheidungen sind erstellt
- [ ] Das Changelog ist aktualisiert
- [ ] Die Nutzerdokumentation ist gegebenenfalls aktualisiert

## Feature-Flag-Strategie

Prüfe anhand von Risiko, Betriebsmodell und Projektvorgaben, ob Feature Flags sinnvoll sind, um Deployment und Release zu entkoppeln. Sind sie nicht geeignet oder erforderlich, plane stattdessen eine passende Freigabe- und Rücknahmestrategie. Das folgende Beispiel zeigt eine mögliche Umsetzung mit Flag:

```typescript
// Feature flag check
const flags = await getFeatureFlags(userId);

if (flags.taskSharing) {
  // New feature: task sharing
  return <TaskSharingPanel task={task} />;
}

// Default: existing behavior
return null;
```

**Beispiel für den Lebenszyklus eines Feature Flags:**

```
1. Mit Flag AUS DEPLOYEN     → Code ist in Produktion, aber inaktiv
2. Für Team/Beta AKTIVIEREN  → Interne Tests in der Produktionsumgebung
3. SCHRITTWEISE AUSROLLEN    → 5 % → 25 % → 50 % → 100 % der Nutzer
4. Jede Stufe ÜBERWACHEN     → Fehlerraten, Performance und Nutzerfeedback beobachten
5. BEREINIGEN                → Flag und toten Codepfad nach vollständigem Rollout entfernen
```

**Regeln:**
- Jedes Feature Flag besitzt einen Verantwortlichen und ein Ablaufdatum
- Flags innerhalb von zwei Wochen nach vollständigem Rollout bereinigen
- Feature Flags nicht verschachteln; die Zahl möglicher Kombinationen steigt exponentiell
- Beide Flag-Zustände, an und aus, in CI testen

## Gestufter Rollout

### Beispiel für einen Rollout mit Feature Flag

```
1. Nach Staging DEPLOYEN
   └── Vollständige Testsuite in der Staging-Umgebung
   └── Manueller Smoke-Test kritischer Abläufe

2. Nach Produktion DEPLOYEN (Feature Flag AUS)
   └── Deployment-Erfolg per Health Check prüfen
   └── Fehlermonitoring auf neue Fehler prüfen

3. Für das Team AKTIVIEREN (Flag für interne Nutzer AN)
   └── Team nutzt das Feature in Produktion
   └── 24 Stunden überwachen

4. CANARY-Rollout (Flag für 5 % der Nutzer AN)
   └── Fehlerraten, Latenz und Nutzerverhalten überwachen
   └── Canary-Metriken mit Ausgangswerten vergleichen
   └── 24–48 Stunden überwachen
   └── Nur bei Einhaltung aller Schwellenwerte fortfahren (siehe Tabelle)

5. SCHRITTWEISE erhöhen (25% -> 50% -> 100%)
   └── Jede Stufe gleichermaßen überwachen
   └── Jederzeit zum vorherigen Anteil zurückkehren können

6. VOLLSTÄNDIGER Rollout (Flag für alle Nutzer AN)
   └── Eine Woche überwachen
   └── Feature Flag bereinigen
```

### Schwellenwerte für Rollout-Entscheidungen

Nutze diese Schwellenwerte, um pro Stufe über Fortfahren, Anhalten oder Rücknahme zu entscheiden:

| Metrik | Fortfahren (grün) | Anhalten und untersuchen (gelb) | Zurücknehmen (rot) |
|--------|-----------------|-------------------------------|-----------------|
| Fehlerrate | Innerhalb von 10 % des Ausgangswerts | 10–100 % über Ausgangswert | >2x Ausgangswert |
| P95-Latenz | Innerhalb von 20 % des Ausgangswerts | 20–50 % über Ausgangswert | >50 % über Ausgangswert |
| Client-JS-Fehler | Keine neuen Fehlerarten | Neue Fehler bei <0.1% der Sitzungen | Neue Fehler bei >0.1% der Sitzungen |
| Geschäftsmetriken | Neutral oder positiv | Rückgang <5 %; kann Messrauschen sein | Rückgang >5 % |

### Wann zurücknehmen

Sofort zurücknehmen, wenn:
- Die Fehlerrate auf mehr als das Doppelte des Ausgangswerts steigt
- Die P95-Latenz um mehr als 50 % steigt
- Nutzermeldungen über Probleme stark zunehmen
- Datenintegritätsprobleme erkannt werden
- Eine Sicherheitslücke entdeckt wird

## Monitoring und Observability

### Was überwacht werden soll

```
Anwendungsmetriken:
├── Fehlerrate insgesamt und je Endpunkt
├── Antwortzeit (p50, p95, p99)
├── Anfragevolumen
├── Aktive Nutzer
└── Wichtige Geschäftsmetriken (Konversion, Engagement)

Infrastrukturmetriken:
├── CPU- und Speicherauslastung
├── Nutzung des Datenbank-Connection-Pools
├── Festplattenspeicher
├── Netzwerklatenz
└── Queue-Tiefe, falls relevant

Client-Metriken:
├── Core Web Vitals (LCP, INP, CLS)
├── JavaScript-Fehler
├── API-Fehlerraten aus Clientsicht
└── Seitenladezeit
```

### Fehlerberichterstattung

```typescript
// Set up error boundary with reporting
class ErrorBoundary extends React.Component<React.PropsWithChildren> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    // Report to error tracking service
    reportError(error, {
      componentStack: info.componentStack,
      userId: getCurrentUser()?.id,
      page: window.location.pathname,
    });
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback onRetry={() => this.setState({ hasError: false })} />;
    }
    return this.props.children;
  }
}

// Server-side error reporting
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  reportError(err, {
    method: req.method,
    url: req.url,
    userId: req.user?.id,
  });

  // Don't expose internals to users
  res.status(500).json({
    error: { code: 'INTERNAL_ERROR', message: 'Something went wrong' },
  });
});
```

### Überprüfung nach dem Launch

In der ersten Stunde nach dem Launch:

```
1. Prüfen, ob der Health-Endpunkt 200 zurückgibt
2. Fehler-Dashboard auf neue Fehlerarten prüfen
3. Latenz-Dashboard auf Regressionen prüfen
4. Den kritischen Nutzerablauf manuell testen
5. Prüfen, ob Logs ankommen und lesbar sind
6. Rücknahmemechanismus überprüfen, nach Möglichkeit durch einen Probelauf
```

## Error-Budget-Freigabeschranke

Das Error Budget eines Dienstes bezeichnet den Anteil fehlgeschlagener Anfragen oder Ausfallzeit, den das SLO zulässt. Nutze es als objektive Schranke für die Entscheidung über eine Veröffentlichung:

```
Verbleibendes Budget > 20 % → Normal veröffentlichen und eng überwachen
Verbleibendes Budget 0–20 % → Nur langsame Rollouts; keine risikoreichen Änderungen
Budget erschöpft            → Feature-Arbeit anhalten und Zuverlässigkeit priorisieren
Budget zurückgesetzt        → Normales Tempo aufnehmen und die wirksame Korrektur übernehmen
```

Eine hohe Burn Rate während eines Canary-Rollouts, also schnellerer Budgetverbrauch als beim Ausgangswert, ist ein **Anhaltesignal** gemäß der obigen Schwellenwerttabelle. Behandle sie wie eine erhöhte Fehlerrate.

## Rollback-Strategie

Jedes Deployment benötigt vor der Ausführung einen Rücknahmeplan:

```markdown
## Rollback Plan for [Feature/Release]

### Trigger Conditions
- Error rate > 2x baseline
- P95 latency > [X]ms
- User reports of [specific issue]

### Rollback Steps
1. Disable feature flag (if applicable)
   OR
1. Deploy previous version: `git revert <commit> && git push`
2. Verify rollback: health check, error monitoring
3. Communicate: notify team of rollback

### Database Considerations
- Migration [X] has a rollback: <verified command or runbook link>
- Data inserted by new feature: [preserved / cleaned up]

### Time to Rollback
- Feature flag: < 1 minute
- Redeploy previous version: < 5 minutes
- Database rollback: < 15 minutes
```
## Siehe auch

- Die projektweite Definition of Done, die vor dieser Checkliste erfüllt sein muss, steht in `.codex/ai-engineering/references/definition-of-done.md` relativ zum Projektstamm.
- Sicherheitsprüfungen vor dem Launch stehen in `.codex/ai-engineering/references/security-checklist.md` relativ zum Projektstamm.
- Performanceprüfungen vor dem Launch stehen in `.codex/ai-engineering/references/performance-checklist.md` relativ zum Projektstamm.
- Prüfungen zur Barrierefreiheit vor dem Launch stehen in `.codex/ai-engineering/references/accessibility-checklist.md` relativ zum Projektstamm.
- Alerting-Regeln und SLO-bezogene Schwellenwerte behandelt `observability-and-instrumentation`.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „In Staging funktioniert es, also auch in Produktion.“ | Produktion hat andere Daten, Verkehrsmuster und Randfälle. Überwache nach dem Deployment. |
| „Dafür brauchen wir keine Feature Flags.“ | Prüfe Risiko und Betriebsmodell; ohne Flag ist eine andere passende Freigabe- und Rücknahmestrategie erforderlich. |
| „Monitoring ist zusätzlicher Aufwand.“ | Ohne Monitoring werden Probleme möglicherweise erst durch Nutzerbeschwerden sichtbar. |
| „Monitoring ergänzen wir später.“ | Richte es vor dem Launch ein, damit Fehler diagnostizierbar sind. |
| „Ein Rollback ist ein Eingeständnis des Scheiterns.“ | Eine Rücknahme kann die verantwortungsvolle Reaktion auf ein defektes Feature sein. |
| „Die Fehlerrate sieht gut aus, wir veröffentlichen weiter.“ | Prüfe zusätzlich die Burn Rate. Schnellerer Budgetverbrauch als beim Ausgangswert ist ein Anhaltesignal, selbst wenn einzelne Schwellenwerte grün sind. |

## Warnzeichen

- Deployment ohne Rücknahmeplan
- Kein Monitoring oder keine Fehlerberichterstattung in Produktion
- Big-Bang-Releases ohne Staging
- Feature Flags ohne Ablaufdatum oder Verantwortliche
- Niemand überwacht das Deployment während der ersten Stunde
- Produktionskonfiguration wird aus dem Gedächtnis statt anhand von Code vorgenommen
- „Es ist Freitagnachmittag, veröffentlichen wir es“
- Das Error Budget ist erschöpft, aber die Feature-Arbeit läuft unverändert weiter

## Überprüfung

Vor dem Deployment:

- [ ] Alle anwendbaren Pflichtprüfungen sind bestanden oder erforderliche Ausnahmen nach Projektvorgaben dokumentiert; nicht anwendbare Punkte sind begründet und nicht verfügbare oder nicht ausgeführte Pflichtprüfungen als offen ausgewiesen
- [ ] Das Feature Flag ist gegebenenfalls konfiguriert
- [ ] Der Rücknahmeplan ist dokumentiert
- [ ] Monitoring-Dashboards sind eingerichtet
- [ ] Das Team wurde über das Deployment informiert

Nach dem Deployment:

- [ ] Der Health Check gibt 200 zurück
- [ ] Die Fehlerrate ist normal
- [ ] Die Latenz ist normal
- [ ] Der kritische Nutzerablauf funktioniert
- [ ] Logs kommen an
- [ ] Rollback wurde getestet oder seine Bereitschaft geprüft

Für jeden veröffentlichten Dienst:

- [ ] Eine Error-Budget-Regelung legt Handlungen bei weniger als 20 % Restbudget und bei Erschöpfung fest
