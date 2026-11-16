---
name: ci-cd-and-automation
description: Richtet CI/CD-Pipelines ein und automatisiert projektgeeignete Qualitätsprüfungen. Nutze den Skill für Build- und Deployment-Pipelines, Testausführung in CI und Deployment-Strategien.
---

# CI/CD und Automatisierung

## Überblick

Automatisiere projektgeeignete Qualitätsschranken für die unterstützten Plattformen, Änderungen und Deployment-Ziele. Erhalte die bestehenden verpflichtenden Prüfungen des Projekts und melde nicht verfügbare oder fehlgeschlagene Prüfungen.

**Shift Left:** Erkenne Probleme möglichst früh in der Pipeline. Ein beim Linting entdeckter Fehler kostet weniger Zeit als derselbe Fehler in Produktion. Ordne Prüfungen früh ein: statische Analyse vor Tests, Tests vor Staging und Staging vor Produktion.

**Faster is Safer:** Kleinere Änderungspakete und häufigere Releases können das Risiko verringern. Ein Deployment mit drei Änderungen lässt sich leichter untersuchen als eines mit 30. Regelmäßige Releases schaffen zudem Vertrauen in den Release-Prozess.

## Wann verwenden

- Die CI-Pipeline eines neuen Projekts einrichten
- Automatisierte Prüfungen ergänzen oder ändern
- Deployment-Pipelines konfigurieren
- Eine Änderung soll eine automatisierte Prüfung auslösen
- CI-Fehler untersuchen

## Pipeline mit Qualitätsschranken

Das folgende Beispiel zeigt eine JavaScript-Web-Pipeline und ist keine Pflichtliste für jedes Projekt. Wähle die Prüfungen anhand des tatsächlichen Stacks, der unterstützten Apple- oder Webplattformen, der Änderung und ihres Risikos sowie der bestehenden CI-Konventionen:

```
Pull Request geöffnet
    │
    ▼
┌─────────────────┐
│   LINT CHECK     │  eslint, prettier
│   ↓ bestanden    │
│   TYPE CHECK     │  tsc --noEmit
│   ↓ bestanden    │
│   UNIT TESTS     │  jest/vitest
│   ↓ bestanden    │
│   BUILD          │  npm run build
│   ↓ bestanden    │
│   INTEGRATION    │  API/DB tests
│   ↓ bestanden    │
│   E2E (optional) │  Playwright/Cypress
│   ↓ bestanden    │
│   SECURITY AUDIT │  npm audit
│   ↓ bestanden    │
│   BUNDLE SIZE    │  bundlesize check
└─────────────────┘
    │
    ▼
  Bereit für das Review
```

Umgehe keine anwendbare Pflichtprüfung stillschweigend und schwäche keine Prüfung ab, um ein erfolgreiches Ergebnis zu erhalten. Untersuche Fehler und melde Hindernisse; Ausnahmen folgen dem autorisierten Verfahren des Projekts. Eine nicht anwendbare Prüfung ist nicht fehlgeschlagen.

## GitHub Actions konfigurieren

### Grundlegende CI-Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Test
        run: npm test -- --coverage

      - name: Build
        run: npm run build

      - name: Security audit
        run: npm audit --audit-level=high
```

### Mit Datenbankintegrationstests

```yaml
  integration:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: testdb
          POSTGRES_USER: ci_user
          POSTGRES_PASSWORD: ${{ secrets.CI_DB_PASSWORD }}
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://ci_user:${{ secrets.CI_DB_PASSWORD }}@localhost:5432/testdb
      - name: Integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://ci_user:${{ secrets.CI_DB_PASSWORD }}@localhost:5432/testdb
```

> **Hinweis:** Verwende auch für reine CI-Testdatenbanken GitHub Secrets für Zugangsdaten, statt Werte fest zu hinterlegen. Das verhindert unter anderem eine versehentliche Wiederverwendung in anderen Kontexten.

### E2E-Tests

```yaml
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - name: Install Playwright
        run: npx playwright install --with-deps chromium
      - name: Build
        run: npm run build
      - name: Run E2E tests
        run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
```

## CI-Fehler an Agenten zurückmelden

Der Nutzen von CI mit KI-Agenten liegt in der Rückkopplung. Wenn CI fehlschlägt:

```
CI schlägt fehl
    │
    ▼
Fehlerausgabe kopieren
    │
    ▼
An den Agenten übergeben:
„Die CI-Pipeline ist mit folgendem Fehler fehlgeschlagen:
[konkreten Fehler einfügen]
Behebe das Problem und prüfe es lokal, bevor du erneut pushst.“
    │
    ▼
Agent behebt den Fehler → pusht → CI läuft erneut
```

**Typische Abläufe:**

```
Lint-Fehler → Agent führt `npm run lint -- --fix` aus und committet
Typfehler   → Agent liest die Fehlerstelle und korrigiert den Typ
Testfehler  → Agent folgt dem Skill debugging-and-error-recovery
Build-Fehler → Agent prüft Konfiguration und Abhängigkeiten
```

## Deployment-Strategien

### Preview-Deployments

Jeder PR erhält ein Preview-Deployment für manuelle Tests:

```yaml
# Deploy preview on PR (Vercel/Netlify/etc.)
deploy-preview:
  runs-on: ubuntu-latest
  if: github.event_name == 'pull_request'
  steps:
    - uses: actions/checkout@v4
    - name: Deploy preview
      run: npx vercel --token=${{ secrets.VERCEL_TOKEN }}
```

### Feature Flags

Feature Flags entkoppeln Deployment und Release. Stelle unvollständige oder risikoreiche Features hinter Flags bereit, um Folgendes zu ermöglichen:

- **Code ausliefern, ohne ihn zu aktivieren.** Früh nach main mergen und bei Bereitschaft aktivieren.
- **Ohne erneutes Deployment zurücknehmen.** Das Flag deaktivieren, statt Code zurückzusetzen.
- **Neue Features schrittweise ausrollen.** Erst für 1 % der Nutzer aktivieren, dann für 10 % und schließlich für 100 %.
- **A/B-Tests durchführen.** Verhalten mit und ohne Feature vergleichen.

```typescript
// Simple feature flag pattern
if (featureFlags.isEnabled('new-checkout-flow', { userId })) {
  return renderNewCheckout();
}
return renderLegacyCheckout();
```

**Lebenszyklus eines Flags:** Erstellen → für Tests aktivieren → schrittweise ausrollen → vollständig ausrollen → Flag und toten Code entfernen. Dauerhaft bestehende Flags werden zu technischer Schuld; lege bei ihrer Erstellung einen Bereinigungstermin fest.

### Gestufte Rollouts

```
PR nach main gemergt
    │
    ▼
  Staging-Deployment (automatisch)
    │ Manuelle Prüfung
    ▼
  Produktions-Deployment (manuell ausgelöst oder automatisch nach Staging)
    │
    ▼
  Auf Fehler überwachen (15 Minuten)
    │
    ├── Fehler erkannt → Rollback
    └── Keine Fehler → Fertig
```

### Rollback-Plan

Jedes Deployment sollte rücknehmbar sein:

```yaml
# Manual rollback workflow
name: Rollback
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to rollback to'
        required: true

jobs:
  rollback:
    runs-on: ubuntu-latest
    steps:
      - name: Rollback deployment
        env:
          VERSION: ${{ inputs.version }}
        run: |
          # Deploy the specified previous version. Pass the input through env,
          # never interpolate it into the script (shell injection).
          npx vercel rollback "$VERSION"
```

## Verwaltung von Umgebungen

```
.env.example       → Committet (Vorlage für Entwickler)
.env                → NICHT committet (lokale Entwicklung)
.env.test           → Committet (Testumgebung, keine echten Geheimnisse)
CI-Geheimnisse      → In GitHub Secrets / Vault gespeichert
Produktionsgeheimnisse → In Deployment-Plattform / Vault gespeichert
```

CI sollte keine Produktionsgeheimnisse enthalten. Verwende separate Geheimnisse für CI-Tests.

## Automatisierung über CI hinaus

### Dependabot / Renovate

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    open-pull-requests-limit: 5
```

### Rolle des Build Cop

Bestimme eine verantwortliche Person für eine funktionierende CI. Schlägt der Build fehl, kümmert sich der Build Cop um Korrektur oder Rücknahme, statt dies allein der Person zu überlassen, deren Änderung den Fehler verursacht hat. So bleiben Fehler nicht liegen, weil alle auf andere warten.

### PR-Prüfungen

Die folgenden Punkte sind Beispiele; verwende die geltenden Review-, Branch-Schutz- und Merge-Regeln des Repositorys. Aktiviere Auto-Merge und ändere Remote-Richtlinien nicht ohne Autorisierung.

- **Erforderliche Reviews:** Mindestens eine Freigabe vor dem Merge
- **Erforderliche Statusprüfungen:** CI muss vor dem Merge bestehen
- **Branch-Schutz:** Keine Force-Pushes auf main
- **Auto-Merge:** Nach bestandenen Prüfungen und Freigabe automatisch mergen

## CI optimieren

Wenn die Pipeline länger als zehn Minuten dauert, prüfe diese Strategien nach erwarteter Wirkung:

```
Langsame CI-Pipeline?
├── Abhängigkeiten zwischenspeichern
│   └── Die Cache-Option von setup-node oder actions/cache für den Paketmanager-Cache verwenden, nicht für node_modules
├── Jobs parallel ausführen
│   └── lint, typecheck, test und build in separate parallele Jobs aufteilen
├── Nur betroffene Prüfungen ausführen
│   └── Pfadfilter für unabhängige Jobs nutzen, etwa e2e bei reinen Dokumentations-PRs auslassen
├── Matrix-Builds verwenden
│   └── Testsuiten auf mehrere Runner verteilen
├── Testsuite optimieren
│   └── Langsame Tests aus dem kritischen Pfad nehmen und stattdessen zeitgesteuert ausführen
└── Größere Runner verwenden
    └── Größere GitHub-Runner oder selbst gehostete Runner für rechenintensive Builds nutzen
```

**Beispiel: Caching und Parallelisierung**
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npm run lint

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npx tsc --noEmit

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npm test -- --coverage
```

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „CI ist zu langsam.“ | Optimiere die Pipeline, statt sie zu überspringen. Eine kurze Pipeline kann langwierige Fehlerdiagnose vermeiden. |
| „Die Änderung ist trivial, CI ist unnötig.“ | Auch kleine Änderungen können Builds beschädigen. |
| „Der Test ist unzuverlässig, einfach erneut ausführen.“ | Unzuverlässige Tests können echte Fehler verdecken. Behebe die Ursache. |
| „CI ergänzen wir später.“ | Ohne CI können sich fehlerhafte Zustände ansammeln. Richte sie frühzeitig ein. |
| „Manuelle Tests reichen aus.“ | Manuelle Prüfungen skalieren schlecht und sind nicht zuverlässig wiederholbar. Automatisiere geeignete Prüfungen. |

## Warnzeichen

- Keine CI-Pipeline im Projekt
- CI-Fehler werden ignoriert oder unterdrückt
- Tests werden in CI deaktiviert, damit die Pipeline besteht
- Produktions-Deployments ohne Staging-Prüfung
- Kein Rollback-Mechanismus
- Geheimnisse im Code oder in CI-Konfigurationsdateien statt in einem Secrets Manager
- Lange CI-Laufzeiten ohne Bemühungen zur Optimierung

## Überprüfung

Nach dem Einrichten oder Ändern von CI:

- [ ] Alle Qualitätsschranken sind vorhanden (lint, types, tests, build, audit)
- [ ] Die Pipeline läuft bei jedem PR und Push nach main
- [ ] Fehler blockieren den Merge; Branch-Schutz ist konfiguriert
- [ ] CI-Ergebnisse fließen in den Entwicklungsablauf zurück
- [ ] Geheimnisse stehen im Secrets Manager, nicht im Code
- [ ] Das Deployment verfügt über einen Rollback-Mechanismus
- [ ] Die Pipeline benötigt für die Testsuite weniger als zehn Minuten
