---
name: git-workflow-and-versioning
description: Strukturiert Git-Arbeitsabläufe und Versionierung. Nutze den Skill für Codeänderungen, Commits, Branches, Konfliktlösung, Pull Requests und autorisierte Pushes sowie für Releases, semantische Versionierung, Tags und Changelogs.
---

# Git-Arbeitsablauf und Versionierung

## Überblick

Git dient als Sicherheitsnetz: Commits sind Sicherungspunkte, Branches getrennte Arbeitsbereiche und die Historie eine Dokumentation. Disziplinierte Versionsverwaltung hält Änderungen von KI-Agenten überschaubar, überprüfbar und rücknehmbar.

## Wann verwenden

Immer: Jede Codeänderung durchläuft die Git-Versionsverwaltung.

## Git-Bootstrap nach der Installation

Der erste Agent prüft vor der Umsetzung den Git-Status und das zuständige Repository. Liegt das Projekt bereits in einem Repository, nutze dieses und lege kein verschachteltes `.git` an. Andernfalls initialisiere Git am Projektstamm mit `git init`.

Prüfe `.gitignore`, die vorgesehenen Dateien und die Git-Identität. Schließe Geheimnisse, private Schlüssel, persönliche oder produktive Daten, lokale Datenbanken, Build-Ausgaben und Caches aus; sichere Beispieldateien können enthalten sein. Fehlt eine Identität, bitte den Nutzer um deren Einrichtung und ändere keine globale Identität. Ergänze nötige Ignore-Regeln behutsam.

Hat das neu initialisierte oder vorhandene Repository noch keine Historie, stage nach dieser Prüfung nur die vorgesehene Projektbasis, prüfe den Staging-Diff und erstelle unmittelbar den Initial-Commit. Diese Handlung ist durch den Installationsablauf autorisiert. In einem Repository mit Historie bleiben fremde Änderungen unberührt; erstelle keinen Bootstrap-Commit mit ihnen. Berichte Commit und verbleibenden Status. Ein Push ist dadurch nicht autorisiert.

## Sicherheitsgrenzen und Commit-Zeitpunkt

Committe zusammenhängende, überprüfte Arbeitseinheiten nach den geltenden Auftrags- und Projektvorgaben. Prüfe vor dem Staging `git status` und vor dem Commit die gestagten Dateien und `git diff --cached`; übernimm nur zum Auftrag gehörende Änderungen. Erhalte bestehende gestagte und ungestagte Nutzerarbeit. Ein vollständig sauberer Arbeitsbaum ist nicht erforderlich, wenn fremde Änderungen bestehen.

Führe `reset`, `rebase`, `amend`, Force-Push, Änderung von Remotes oder Verwerfen von Arbeit nur auf ausdrücklichen Auftrag aus. Nach einem nachgewiesenen erfolgreichen Merge kann der zugehörige lokale Feature-Branch gelöscht werden, sofern er keine weiteren ungemergten Änderungen enthält und keine geltenden Vorgaben entgegenstehen; schütze Standard- und gemeinsam genutzte Branches. Für sonstige Branch-Löschungen ist ein ausdrücklicher Auftrag erforderlich. Push, Veröffentlichung und externe Repository-Aktionen einschließlich der Löschung entfernter Branches erfordern die entsprechende Autorisierung. Umgehe keine Hooks oder Signaturvorgaben; melde Blockaden.

## Grundprinzipien

### Trunk-Based Development (empfohlen)

Halte `main` jederzeit deploybar. Arbeite in kurzlebigen Feature-Branches, die innerhalb von ein bis drei Tagen zurückgeführt werden. Langlebige Entwicklungsbranches laufen auseinander, verursachen Merge-Konflikte und verzögern die Integration. DORA-Forschung zeigt einen Zusammenhang zwischen Trunk-Based Development und leistungsfähigen Entwicklungsteams.

```
main ──●──●──●──●──●──●──●──●──●──  (jederzeit deploybar)
        ╲      ╱  ╲    ╱
         ●──●─╱    ●──╱    ← kurzlebige Feature-Branches (1–3 Tage)
```

Dies ist die empfohlene Voreinstellung. Teams mit gitflow oder langlebigen Branches können die Prinzipien atomarer Commits, kleiner Änderungen und aussagekräftiger Nachrichten auf ihr Branching-Modell übertragen. Die Commit-Disziplin ist wichtiger als die konkrete Strategie.

- **Entwicklungsbranches verursachen Aufwand.** Mit ihrer Lebensdauer wächst das Merge-Risiko.
- **Release-Branches sind akzeptabel**, um ein Release zu stabilisieren, während main weiterentwickelt wird.
- **Feature Flags vor langlebigen Branches.** Unfertige Arbeit bei Bedarf hinter Flags deployen, statt sie wochenlang auf einem Branch zu halten.

### 1. Früh und regelmäßig committen

Bevorzuge gezielte Commits zusammenhängender, geprüfter Einheiten, wenn das Committen autorisiert ist. Zugehörige Schritte können gebündelt werden; bewahre unabhängige Änderungen.

```
Arbeitsmuster:
  Teil umsetzen → Testen → Überprüfen → Commit → Nächster Teil

Nicht so:
  Alles umsetzen → Auf Funktion hoffen → Riesiger Commit
```

Commits sind Sicherungspunkte. Falls eine spätere Änderung etwas beschädigt, untersuche den Fehler und bewahre bestehende Arbeit. Führe ein Zurücksetzen oder Verwerfen nur mit ausdrücklicher Autorisierung aus.

### 2. Atomare Commits

Jeder Commit behandelt eine logische Änderung:

```
# Good: Each commit is self-contained
git log --oneline
a1b2c3d Add task creation endpoint with validation
d4e5f6g Add task creation form component
h7i8j9k Connect form to API and add loading state
m1n2o3p Add task creation tests (unit + integration)

# Bad: Everything mixed together
git log --oneline
x1y2z3a Add task feature, fix sidebar, update deps, refactor utils
```

### 3. Aussagekräftige Nachrichten

Commit-Nachrichten erklären das *Warum*, nicht nur das *Was*:

```
# Good: Explains intent
feat: add email validation to registration endpoint

Prevents invalid email formats from reaching the database.
Uses Zod schema validation at the route handler level,
consistent with existing validation patterns in auth.ts.

# Bad: Describes what's obvious from the diff
update auth.ts
```

**Format:**
```
<type>: <short description>

<optional body explaining why, not what>
```

**Typen:**
- `feat` — Neues Feature
- `fix` — Fehlerkorrektur
- `refactor` — Codeänderung ohne Fehlerkorrektur oder neues Feature
- `test` — Tests ergänzen oder aktualisieren
- `docs` — Ausschließlich Dokumentation
- `chore` — Werkzeuge, Abhängigkeiten oder Konfiguration

### 4. Anliegen getrennt halten

Kombiniere weder Formatierungs- und Verhaltensänderungen noch Refactoring und Features. Jede Änderungsart sollte einen eigenen Commit und idealerweise einen eigenen PR erhalten:

```
# Good: Separate concerns
git commit -m "refactor: extract validation logic to shared utility"
git commit -m "feat: add phone number validation to registration"

# Bad: Mixed concerns
git commit -m "refactor validation and add phone number field"
```

**Trenne Refactoring von Feature-Arbeit.** Reiche eine Umstrukturierung und eine Feature-Änderung getrennt ein. So lassen sie sich leichter prüfen, zurücknehmen und in der Historie verstehen. Kleine Bereinigungen wie das Umbenennen einer Variablen können nach Ermessen des Reviewers im Feature-Commit enthalten sein.

### 5. Änderungsumfang begrenzen

Orientiere dich an etwa 100 Zeilen pro Commit oder PR. Änderungen über etwa 1000 Zeilen sollten aufgeteilt werden. Strategien dafür stehen in `code-review-and-quality`.

```
~100 Zeilen  → Einfach zu prüfen und zurückzunehmen
~300 Zeilen  → Für eine einzelne logische Änderung akzeptabel
~1000 Zeilen → In kleinere Änderungen aufteilen
```

## Branching-Strategie

### Feature-Branches

```
main (jederzeit deploybar)
  │
  ├── feature/task-creation    ← Ein Feature pro Branch
  ├── feature/user-settings    ← Parallele Arbeit
  └── fix/duplicate-tasks      ← Fehlerkorrekturen
```

- Von `main` oder dem Standardbranch des Teams abzweigen
- Branches kurzlebig halten und innerhalb von ein bis drei Tagen mergen; langlebige Branches verursachen zusätzlichen Aufwand
- Zugehörige lokale Feature-Branches nach nachgewiesenem erfolgreichem Merge unter den oben genannten Bedingungen löschen; entfernte Branches nur mit entsprechender Autorisierung
- Bei unfertigen Features Feature Flags gegenüber langlebigen Branches bevorzugen

### Branch-Benennung

```
feature/<short-description>   → feature/task-creation
fix/<short-description>       → fix/duplicate-tasks
chore/<short-description>     → chore/update-deps
refactor/<short-description>  → refactor/auth-module
```

## Mit Worktrees arbeiten

Verwende für parallele Arbeit von KI-Agenten Git-Worktrees, um mehrere Branches gleichzeitig zu bearbeiten:

```bash
# Create a worktree for a feature branch
git worktree add ../project-feature-a feature/task-creation
git worktree add ../project-feature-b feature/user-settings

# Each worktree is a separate directory with its own branch
# Agents can work in parallel without interfering
ls ../
  project/              ← main branch
  project-feature-a/    ← task-creation branch
  project-feature-b/    ← user-settings branch

# When done, merge and clean up
git worktree remove ../project-feature-a
```

Vorteile:
- Mehrere Agenten können gleichzeitig an unterschiedlichen Features arbeiten
- Kein Branch-Wechsel nötig, da jedes Verzeichnis einen eigenen Branch hat
- Schlägt ein Experiment fehl, prüfe und bewahre seine Änderungen; entferne einen Worktree nur nach ausdrücklicher Autorisierung und Prüfung auf nicht committete Arbeit
- Änderungen bleiben bis zum ausdrücklichen Merge isoliert

## Das Sicherungspunktmuster

Das folgende Ablaufdiagramm ist ein unverbindliches Beispiel. Commits erfolgen gemäß den Projektvorgaben für geeignete, geprüfte Arbeitseinheiten; mehrere zusammenhängende Schritte können gemeinsam committet werden.

```
Agent beginnt die Arbeit
    │
    ├── Nimmt eine Änderung vor
    │   ├── Test besteht? → Commit → Weiterarbeiten
    │   └── Test schlägt fehl? → Änderungen bewahren und untersuchen
    │
    ├── Nimmt eine weitere Änderung vor
    │   ├── Test besteht? → Commit → Weiterarbeiten
    │   └── Test schlägt fehl? → Änderungen bewahren und untersuchen
    │
    └── Feature abgeschlossen → Alle Commits bilden eine übersichtliche Historie
```

Schlägt ein Schritt fehl, prüfe den Diff und ermittle betroffene Änderungen, bevor du eine Wiederherstellung wählst. Bewahre vorhandene Arbeit und Nutzeränderungen; ein Zurücksetzen oder Verwerfen erfordert ausdrückliche Autorisierung.

## Zusammenfassungen von Änderungen

Gib nach einer Änderung eine strukturierte Zusammenfassung. Sie erleichtert das Review, dokumentiert den Umfang und macht unbeabsichtigte Änderungen sichtbar:

```
CHANGES MADE:
- src/routes/tasks.ts: Added validation middleware to POST endpoint
- src/lib/validation.ts: Added TaskCreateSchema using Zod

THINGS I DIDN'T TOUCH (intentionally):
- src/routes/auth.ts: Has similar validation gap but out of scope
- src/middleware/error.ts: Error format could be improved (separate task)

POTENTIAL CONCERNS:
- The Zod schema is strict — rejects extra fields. Confirm this is desired.
- Added zod as a dependency (72KB gzipped) — already in package.json
```

Dieses Muster macht falsche Annahmen früh sichtbar und gibt Reviewern einen Überblick. Der Abschnitt „DIDN'T TOUCH“ dokumentiert insbesondere, welche Bereiche bewusst außerhalb des Auftrags blieben.

## Prüfungen vor dem Commit

Prüfe vor jedem Commit den Staging-Diff und wähle Prüfungen passend zur Änderung und zur Projektkonfiguration. Benenne fehlgeschlagene, nicht verfügbare oder nicht ausgeführte Pflichtprüfungen und kläre sie vor dem Commit nach den Projektvorgaben.

Das folgende Beispiel zeigt mögliche Befehle für ein JavaScript-/TypeScript-Projekt mit entsprechend eingerichteten Skripten; es ist kein verbindlicher Ablauf für andere Projekte:

```bash
# 1. Check what you're about to commit
git diff --staged

# 2. Ensure no secrets (lists matching file names only — any output means review them)
git diff --staged -i -G'password|secret|api_key|token' --name-only

# 3. Run tests
npm test

# 4. Run linting
npm run lint

# 5. Run type checking
npx tsc --noEmit
```

Bei Bedarf lassen sich passende Prüfungen mit Git-Hooks automatisieren, beispielsweise:

```json
// package.json (using lint-staged + husky)
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

## Umgang mit generierten Dateien

- **Committe generierte Dateien** nur, wenn das Projekt sie erwartet, etwa `package-lock.json` oder Prisma-Migrationen
- **Committe keine** Build-Ausgaben (`dist/`, `.next/`), Umgebungsdateien (`.env`) oder IDE-Konfigurationen (`.vscode/settings.json`, sofern nicht gemeinsam genutzt)
- **Verwende eine `.gitignore`**, die `node_modules/`, `dist/`, `.env`, `.env.local` und `*.pem` abdeckt

## Git zur Fehlerdiagnose verwenden

```bash
# Find which commit introduced a bug
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
# Git checkouts midpoints; run your test at each to narrow down

# View what changed recently
git log --oneline -20
git diff HEAD~5..HEAD -- src/

# Find who last changed a specific line
git blame src/services/task.ts

# Search commit messages for a keyword
git log --grep="validation" --oneline
```

## Release und Versionierung

Commits dokumentieren Änderungen für die Entwicklung; eine **Version** macht sie für Nutzer nachvollziehbar. Sobald andere Teams, veröffentlichte Pakete oder deployte Clients vom Code abhängen, genügt „der aktuelle Stand auf main“ nicht mehr, um verwendete Version und Upgrade-Sicherheit zu bestimmen. Versionsnummer und Changelog dokumentieren diesen Vertrag.

### Semantic Versioning

Verwende für genutzte Software `MAJOR.MINOR.PATCH` und beachte die Bedeutung der Nummern:

```
  MAJOR  Inkompatible Änderung — Nutzer müssen ihren Code für das Upgrade ändern
  MINOR  Neue, abwärtskompatible Funktionalität — Upgrade möglich
  PATCH  Abwärtskompatible Fehlerkorrektur — Upgrade möglich
```

Die Versionsnummer ist eine Zusicherung; der Code muss dazu passen. Ein „patch“, der Verhalten ändert, von dem Nutzer abhängen, ist eine inkompatible Änderung (Hyrum's Law; siehe `api-and-interface-design`). Ist unklar, ob eine Änderung inkompatibel ist, gehe davon aus.

### Release taggen und Tag als maßgebliche Quelle verwenden

Ein Release ist ein unveränderlicher Punkt in der Historie, kein veränderlicher Branch. Versieh es mit einem Tag, damit es reproduzierbar bleibt:

```bash
git tag -a v1.4.0 -m "Release 1.4.0"
git push origin v1.4.0
```

Leite die Version aus dem Tag ab, statt sie in verschiedenen Dateien von Hand zu ändern. So bleiben Artefakt, Tag und Changelog auf demselben Stand.

### Ein für Menschen verständliches Changelog pflegen

Ein Changelog ist nicht `git log`. Es beschreibt für Nutzer, was sich geändert hat und welche Auswirkungen dies hat. Gruppiere nach `Added / Changed / Fixed / Deprecated / Removed / Security`, führe die neuesten Einträge zuerst und beschreibe die Nutzerwirkung statt interner Details.

```markdown
## [1.4.0] - 2025-06-12
### Added
- Bulk task import via CSV
### Fixed
- Timezone drift in recurring task due dates
### Deprecated
- `GET /v1/tasks/all` — use the paginated `GET /v1/tasks` (removal in 2.0)
```

Schreibe den Eintrag zusammen mit der Änderung, solange ihre Auswirkungen bekannt sind, statt ihn erst beim Release aus der Historie zu rekonstruieren. Inkompatible Änderungen erhalten einen Migrationshinweis und einen Abkündigungszeitraum; folge `deprecation-and-migration`. Die tatsächliche Veröffentlichung behandelt `shipping-and-launch`; dieser Abschnitt liefert den Versionierungsvertrag dafür.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Ich committe, wenn das Feature fertig ist.“ | Bevorzuge bei Bedarf zusammenhängende, überprüfbare Commits; zugehörige Schritte können gebündelt werden. |
| „Die Nachricht ist unwichtig.“ | Nachrichten dokumentieren, was sich geändert hat und warum. |
| „Ich fasse später alles per Squash zusammen.“ | Dabei kann der Entwicklungsverlauf verloren gehen. Bevorzuge von Anfang an übersichtliche inkrementelle Commits. |
| „Branches verursachen Aufwand.“ | Kurzlebige Branches trennen parallele Arbeit; führe sie möglichst innerhalb von ein bis drei Tagen zusammen. |
| „Ich teile die Änderung später auf.“ | Große Änderungen sind schwerer zu prüfen, deployen und zurückzunehmen. Teile vor der Einreichung auf. |
| „Ich brauche keine .gitignore.“ | Ohne sie können etwa Produktionsgeheimnisse aus `.env` versehentlich committet werden. |
| „Es ist nur eine kleine Korrektur, also patch.“ | Prüfe beobachtbares Verhalten: Eine inkompatible Änderung kann unabhängig von der Diff-Größe major sein. |
| „Das Changelog ist das Commit-Log.“ | Das Changelog richtet sich an Nutzer und ordnet Änderungen nach Auswirkungen. |
| „Das Changelog schreiben wir beim Release.“ | Später müssen Auswirkungen rekonstruiert werden und können fehlen. Schreibe den Eintrag mit der Änderung. |

## Warnzeichen

- Große Mengen nicht committeter Änderungen sammeln sich an
- Nichtssagende Commit-Nachrichten wie „fix“, „update“ oder „misc“
- Formatierungs- und Verhaltensänderungen werden vermischt
- Dem Projekt fehlt eine `.gitignore`
- `node_modules/`, `.env` oder Build-Artefakte werden committet
- Langlebige Branches weichen erheblich von main ab
- Force-Push auf gemeinsam genutzte Branches
- Eine inkompatible Änderung wird als Minor- oder Patch-Version ausgeliefert
- Ein Release hat keinen Tag oder eine manuell geänderte Version weicht vom Tag ab
- Ein nutzerseitiges Release hat keinen Changelog-Eintrag oder das Changelog besteht nur aus ungefilterten Commit-Nachrichten

## Überprüfung

Für jeden Commit:

- [ ] Der Commit behandelt eine logische Änderung
- [ ] Die Nachricht erklärt das Warum und folgt den Typkonventionen
- [ ] Zur Änderung und zum Projekt passende Prüfungen wurden durchgeführt; erforderliche fehlgeschlagene oder nicht ausführbare Prüfungen sind offen benannt und vor einem Commit entsprechend den Projektvorgaben geklärt
- [ ] Der Diff enthält keine Geheimnisse
- [ ] Reine Formatierungsänderungen sind nicht mit Verhaltensänderungen vermischt
- [ ] `.gitignore` deckt die üblichen Ausschlüsse ab

Für jedes Release mit Nutzern:

- [ ] Die Versionsänderung passt zur Änderung: inkompatibel → major, ergänzend → minor, Fehlerkorrektur → patch
- [ ] Das Release ist getaggt und die Version aus dem Tag abgeleitet, statt abweichend manuell geändert
- [ ] Das Changelog enthält einen redaktionell bearbeiteten, verständlichen und nach Auswirkungen gruppierten Eintrag für diese Version
