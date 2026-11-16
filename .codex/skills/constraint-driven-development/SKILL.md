---
name: constraint-driven-development
description: Definiert und dokumentiert verbindliche Qualitätsschranken in CONSTRAINTS.md. Nutze den Skill für fehlende Qualitätsstandards, prüfbare Grenzwerte und Qualitätsschranken sowie zum Erkennen abgeschwächter Prüfungen, unterdrückter Warnungen, übersprungener Tests und reduzierter Schwellenwerte.
---

# Entwicklung mit Qualitätsschranken

## Überblick

Andere Skills beschreiben Qualitätsmerkmale: `code-review-and-quality` nennt fünf Prüfdimensionen, `test-driven-development` einen Zyklus und `security-and-hardening` Bedrohungen. Diese Anweisungen allein halten keine projektspezifischen Entscheidungen über die Sitzung hinaus fest.

Dieser Skill dokumentiert die Qualitätsanforderungen **dieses Projekts** mit überprüfbaren Zahlen dauerhaft.

Wenn Agenten mehr Code erzeugen, als zeitnah gelesen wird, gewinnen automatisierte Prüfungen an Bedeutung. Sie benötigen bewusst gewählte Grenzwerte und müssen nah genug an der Arbeit ausgeführt werden, damit der Agent Befunde beheben kann.

Spec-Driven Development beschreibt das Ziel, Test-Driven Development prüft die Funktion und Constraint-Driven Development legt vor einem Pull Request die Qualitätsanforderungen für die Veröffentlichung fest.

## Wann verwenden

Nutze den Skill, wenn:

- Ein Projekt oder größeres Feature ohne dokumentierte Qualitätsanforderungen beginnt
- Der Nutzer Qualitätsstandards oder Prüfschranken einrichten möchte
- Ein Agent mehr Code erzeugt, als zeilenweise geprüft wird
- Unklar ist, welche CI-Prüfungen einen Merge blockieren
- Grenzwerte für Coverage, Performance oder Barrierefreiheit bei jedem PR neu diskutiert werden
- Ein autonomer Implementierungsablauf bevorsteht und nur eine vom selben Agenten geschriebene Testsuite ihn von main trennt

**Nicht verwenden, wenn:**

- Bereits eine `CONSTRAINTS.md` existiert und der Nutzer sie nicht ändern möchte; lies und befolge sie stattdessen
- Es sich um einmalige Skripte, Spikes oder Wegwerfprototypen handelt
- Der Nutzer unmittelbar ein Code-Review (`code-review-and-quality`) oder eine CI-Pipeline (`ci-cd-and-automation`) möchte
- Code vor dem Product-Market-Fit voraussichtlich nur zwei Wochen besteht; das folgende Mindestniveau bleibt sinnvoll, die weiteren Maßnahmen nicht

## Voraussetzungen

Das Interview benötigt einen ansprechbaren Nutzer. **Führe es nicht in nicht interaktiven Kontexten** wie CI, `/loop` oder autonomen Ausführungen durch. Fehlen dort Vorgaben, wende das folgende Mindestniveau an, dokumentiere dies und melde den Rest zur menschlichen Klärung.

## Vorgehen

### Schritt 1: Vor dem Fragen recherchieren

Frage nicht nach bereits lesbaren Informationen. Ermittle vor der ersten Frage:

| Information | Fundstelle |
|------|---------------|
| Sprache und Stack | `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml` |
| Test Runner | Entwicklungsabhängigkeiten, `test`-Skript, vorhandene Testdateien |
| Vorhandene Linter | `eslint.config.*`, `biome.json`, `.ruff.toml` |
| Aktuelle Coverage | Ausgabe unter `coverage/` oder einmalige Testausführung |
| CI | `.github/workflows/`, `.gitlab-ci.yml` |
| Agentenumgebung | `.claude/`, `.codex/`, `AGENTS.md` |

Fasse die Ergebnisse in zwei Zeilen zusammen und frage nur nach offenen Punkten.

### Schritt 2: Vier Fragen mit je einem Standardwert

Befolge das Vorgehen von `interview-me` mit jeweils einer Frage. Ergänze hier für jede Frage einen Standardwert, sodass auch „Ich weiß es nicht“ zu einer verwendbaren Konfiguration führt.

```
Q1: Beyond the floor, which of these do you want enforced?
    (a) Test coverage on new code
    (b) Security scanning
    (c) Performance budgets
    (d) Accessibility
    (e) Architecture boundaries
GUESS: (a) and (b) — you have a test runner already and you're handling user input.
DEFAULT if unsure: (a) and (b).
Say what each pick costs: (c) and (d) need a running URL, (e) needs a rules file written.
```

```
Q2: When a check fails while the agent is mid-task, should it block or warn?
GUESS: Block. You're running agents unattended and a warning nobody reads is a warning.
DEFAULT if unsure: Block on the floor, warn on everything else for the first two weeks.
```

```
Q3: Do you have target numbers in mind, or should I measure where you are today and hold that line?
GUESS: Measure. Most teams don't have a number, and an invented one gets ignored.
DEFAULT if unsure: Measure and hold. See "Ratchets" below.
```

```
Q4: What's the slowest check you'll tolerate before the agent hands work back?
GUESS: About 90 seconds. Longer and you'll stop running it.
DEFAULT if unsure: 90 seconds at task end, unlimited in CI.
```

Beschränke dich auf vier Fragen. Ein umfangreicherer Fragenkatalog erschwert die Verständlichkeit der Konfiguration.

### Schritt 3: CONSTRAINTS.md erstellen

Lege eine Datei im Repository-Wurzelverzeichnis an. Agenten verschiedener Umgebungen können sie lesen und Änderungen erscheinen im Review.

```markdown
# Constraints

Last reviewed: 2026-08-08 by @addy

## Floor (always enforced, no setup required)

- No new suppression comments: `@ts-ignore`, `eslint-disable`, `# noqa`, `# type: ignore`
- No unimplemented stubs: `throw new Error("Not implemented")`, empty `catch {}`
- No skipped or deleted tests without a reason in the commit message
- No secrets in source
- This file does not get weakened to make a change pass

## Enforced with numbers

| Dimension | Rule | Checked by | Runs at |
|-----------|------|-----------|---------|
| Types | Zero type errors | `tsc --noEmit` | every edit |
| Lint | Zero errors from our config | `biome check` | every edit |
| Secrets | No secrets in source | `gitleaks dir . --redact` | every edit |
| Coverage | Changed lines ≥ 80% covered | `vitest run --coverage` + git diff | task end, CI |
| Security: code | Nothing at high or above | `npm run check:security` | CI |
| Security: deps | Nothing at high or above | `osv-scanner scan source -r .` | CI |
| Accessibility | Zero critical or serious | `npm run check:a11y` | preview deploy |
| Performance | LCP ≤ 2500ms, CLS ≤ 0.1 | `lighthouse $PREVIEW_URL --output=json` | preview deploy |

Every row names the command that produces the verdict. A dimension with a
number and no command in this column is an aspiration, not a constraint.

## Measured, not yet enforced

| Metric | Today | Direction |
|--------|-------|-----------|
| Project coverage | 62.4% | must not fall |
| Bundle size (main) | 184 kB | must not grow |

## Exceptions

| ID | Rule | Path | Reason | Owner | Expires |
|----|------|------|--------|-------|---------|
| W1 | `no-explicit-any` | `src/legacy/**` | Rewrite tracked in ENG-441 | @addy | 2026-11-01 |
```

Ergänze anschließend in `AGENTS.md` und `CLAUDE.md` die Zeile: `Read CONSTRAINTS.md before writing code. Do not weaken it to make a change pass.`

### Schritt 4: Benötigte Werkzeuge je Dimension installieren

Eine gewählte Dimension benötigt einen ausführbaren Prüfmechanismus. Erfinde keinen eigenen Checker, wenn ein etabliertes Werkzeug existiert; dessen Regelformat und Grenzwerte erhalten die bestehende Teamkonfiguration.

| Dimension | Werkzeug | Installation | Ausführung | Blockiert bei |
|-----------|------|---------|-----|---------|
| Typen (TS) | tsc | bereits vorhanden | `tsc --noEmit` | jedem Fehler |
| Typen (Python) | mypy | `pip install mypy` | `mypy .` | jedem Fehler |
| Lint | bestehende Konfiguration | bereits vorhanden | `eslint .` / `biome check` / `ruff check` | jedem Fehler |
| Coverage (JS) | vorhandener Test Runner | Vitest: `npm i -D @vitest/coverage-v8`; Jest: bereits vorhanden | `vitest run --coverage` (oder `jest --coverage`) | Coverage geänderter Zeilen |
| Coverage (Python) | pytest-cov | `pip install pytest-cov` | `pytest --cov --cov-report=lcov` | wie oben |
| Sicherheit: Code | Semgrep | `pipx install semgrep` | `npm run check:security` (unten) | hoch oder kritisch, einschließlich älterem `ERROR` |
| Sicherheit: Geheimnisse | gitleaks | `brew install gitleaks` | `gitleaks dir . --redact --no-banner` | jedem Befund |
| Sicherheit: Abhängigkeiten | osv-scanner | `brew install osv-scanner` | `osv-scanner scan source -r .` | hoch oder höher |
| Performance: Seite | Lighthouse | `npm i -D lighthouse` | `lighthouse $URL --output=json --quiet` | LCP, CLS, Performance-Wert |
| Performance: Bundle | size-limit | `npm i -D size-limit` | `size-limit --json` | Byte-Budget je Einstiegspunkt |
| Barrierefreiheit | axe-core | `npm i -D @axe-core/cli` | `npm run check:a11y` (unten) | kritischen oder schwerwiegenden Befunden |
| Architektur | dependency-cruiser | `npm i -D dependency-cruiser` | `depcruise --validate src` | jedem Verstoß |
| Qualität der Assertions | Stryker | `npm i -D @stryker-mutator/core` | `stryker run --mutate <changed files>` | Mutationswert |

Fünf wichtige Hinweise:

1. **`--redact` ist bei gitleaks verpflichtend.** Andernfalls gelangen gefundene Geheimnisse ins Agentenprotokoll und möglicherweise in Logs, Zusammenfassungen oder Commit-Nachrichten. Melde Regel und Fundstelle, niemals den Wert.
2. **Lighthouse und axe benötigen eine URL.** Prüfe eine laufende App über ein Preview-Deployment oder einen zuvor gestarteten lokalen Server. Hat das Projekt keine erreichbare URL, etwa bei CLI, Bibliothek oder Desktop-App, benenne dies und lasse die Dimension weg.
3. **Begrenze aufwendige Prüfungen auf den Diff.** `stryker run --mutate` für das gesamte Repository kann Stunden dauern; für geänderte Dateien ist es deutlich schneller. Gleiches gilt für Semgrep, das eine Pfadliste akzeptiert.
4. **Coverage benötigt keinen zweiten Testlauf.** Werte die bereits erzeugte lcov-Datei zusammen mit `git diff` aus.
5. **Semgrep-Registry-Regeln dürfen kostenlos ausgeführt werden; prüfe vor der Weitergabe die Lizenz.** `opengrep` ist bei Bedarf ein kompatibler Fork mit gleichem Regelformat und JSON-Ausgabe.

`semgrep scan` und `axe` können trotz Befunden mit 0 enden. Kopiere [scripts/quality-gate.mjs](scripts/quality-gate.mjs) in das `scripts/`-Verzeichnis des Projekts, um die Grenzwerte durchzusetzen.
Belasse den Scanner vor `&&`, damit ein fehlgeschlagener Scan den Befehl abbricht.

Ergänze die Befehle in den Projektskripten, damit sie ohne Agenten reproduzierbar sind:

```json
{
  "scripts": {
    "check:fast": "tsc --noEmit && eslint . && gitleaks dir . --redact --no-banner",
    "check:task": "npm run check:fast && vitest run --coverage",
    "check:security": "semgrep scan --config p/default --strict --json > semgrep-results.json && node scripts/quality-gate.mjs semgrep semgrep-results.json",
    "check:a11y": "axe \"$PREVIEW_URL\" --tags wcag2a,wcag2aa,wcag21aa --stdout > axe-results.json && node scripts/quality-gate.mjs axe axe-results.json",
    "check:full": "npm run check:task && npm run check:security && osv-scanner scan source -r ."
  }
}
```

Die Zuordnung ist entscheidend: `check:fast` läuft nach einer Änderung, `check:task` am Aufgabenende und `check:full` in CI. Führe `check:a11y` nach Erreichbarkeit der Vorschau mit gesetztem `PREVIEW_URL` aus; das Beispiel verwendet POSIX-Shellsyntax.

Bevor eine Zeile als durchgesetzt gilt, führe ihren tatsächlichen CI-Befehl gegen einen bekannten Verstoß und eine saubere Kontrolle aus. Der Verstoß und Scannerfehler müssen fehlschlagen, die Kontrolle bestehen. Prüfe bei Schweregradschwellen außerdem, dass ein Befund unterhalb der Schwelle besteht. Das gilt auch für Coverage und Lighthouse: Ein Bericht allein setzt den Wert in `CONSTRAINTS.md` nicht durch.

Die Befehle stehen nun in der Spalte `Checked by` von `CONSTRAINTS.md` und in den Skripten. `CONSTRAINTS.md` ist maßgeblich, dokumentiert die Gründe und erscheint im Review. Die Skripte müssen sie widerspiegeln; bei Abweichungen gilt die Datei.

### Schritt 5: In den Lebenszyklus einbinden

Nicht jede Prüfung gehört in jede Phase. Prüfungen, die den Agenten zu lange blockieren, werden womöglich abgeschaltet, während ihre Qualitätswirkung weiterhin angenommen wird.

Verwende die tatsächlich konfigurierten Projektbefehle und CI-Jobs. Die folgenden Phasen sind konzeptionell und keine integrierten Codex-Slash-Befehle. Passe Budgets an das Projekt an.

| Phase | Beispielprüfungen | Ausführung | Beispielbudget |
|-------|---------|-----------|--------|
| BUILD | Konfigurierte schnelle Prüfungen | Typen, Lint, Geheimnisse, Mindestniveau | unter 5 s, nur geänderte Datei |
| VERIFY | Projekttestbefehle | Zugehörige Tests, Coverage geänderter Zeilen | unter 90 s |
| REVIEW | Review-Prüfungen des Projekts | Anwendbare Prüfungen und nachfolgende Schutzmechanismen | Minuten |
| SHIP | Konfigurierte CI-/Release-Prüfungen | Richtungsprüfungen, keine Regressionen | CI |

Zwei Regeln für einen praktikablen Ablauf:

1. **Begrenze Prüfungen auf den Diff.** Prüfe die geänderten Zeilen statt des gesamten Repositorys. Coverage geänderter Zeilen kann der Agent beeinflussen; bestehende Projekt-Coverage wurde übernommen.
2. **Der Aufwand bestimmt die Phase.** Prüfungen über wenigen Sekunden gehören nicht in jede Änderungsschleife. Mutationstests für das gesamte Repository können Stunden dauern, für geänderte Dateien deutlich kürzer.

### Schritt 6: Qualitätsniveau selbst schützen

Wenn derselbe Agent Code und Prüfungen schreibt, ist deren Aussagekraft begrenzt. Berücksichtige dies bei der Absicherung.

Achte im Diff beim Review auf fünf Arten, wie fehlgeschlagene Prüfungen abgeschwächt werden können:

1. **Ein Grenzwert wurde verschoben.** Ein Budget oder Schweregrad wurde gesenkt oder eine schnelle Prüfung entfernt. Vergleiche `CONSTRAINTS.md` mit dem Stand beim Abzweigen.
2. **Ein Test wurde abgeschwächt.** `.skip` wurde ergänzt, eine Testdatei gelöscht oder Assertions entfernt.
3. **Eine Prüfung wurde unterdrückt.** Neue `@ts-ignore` oder `eslint-disable` beachten. Besonders wichtig: `istanbul ignore` entfernt Code aus der Coverage, `Stryker disable` verbirgt einen überlebenden Mutanten und `nosemgrep` sowie `gitleaks:allow` unterdrücken Sicherheitsbefunde.
4. **Arbeit ist unvollständig.** Ein Stub löst eine Ausnahme aus, ein leeres `catch` verschluckt Fehler oder ein `TODO` steht anstelle der Implementierung.
5. **Eine Ausnahme wurde ergänzt.** Eine neue Zeile in der Ausnahmetabelle wurde nicht besprochen.

Dafür genügt `git diff`. Eine Verschärfung kann unmittelbar erfolgen; eine Abschwächung muss ausdrücklich sichtbar sein.

Für das Mindestniveau gibt es anders als für die bezifferten Dimensionen kein etabliertes Einzelwerkzeug. Eine Referenzimplementierung der fünf Prüfungen steht in [references/floor-guard.md](references/floor-guard.md): auf den Diff begrenzt, mit Exit-Codes `0`/`1`/`2` und anpassbaren Mustern. Passe sie an, statt einen weiteren Prüfer neu zu erfinden.

**Nicht alle Prüfungen sind gleichermaßen selbstreferenziell.** Frage: Kann der Agent sie mit nicht funktionierendem Code bestehen lassen?

- **Extern**: axe-core bildet WCAG ab, `osv-scanner` liest eine Schwachstellendatenbank und Lighthouse misst in einem echten Browser.
- **Projektbezogen**: Lintregeln und Schichtgrenzen, deren Datei einem Menschen zugeordnet ist.
- **Testsuite**: eigene Tests; besonders nützlich, aber selbstreferenziell.

Ein Qualitätsniveau nur aus der dritten Art ist weniger aussagekräftig. Prüfe, dass mindestens eine externe Qualitätsschranke vorhanden ist.

### Schritt 7: Ratchets bei fehlendem Zielwert

Ein Coverage-Ziel von 80 % bei einem aktuellen Stand von 62 % führt zunächst dauerhaft zu fehlschlagenden Builds, die das Team möglicherweise ignoriert.

Eine Alternative ist, den aktuellen Stand festzuhalten und Verschlechterungen zu verhindern. Trage den Wert und seine Richtung in die Tabelle „Measured, not yet enforced“ ein. Vergleiche jede Prüfung mit dem dokumentierten Wert. Verbessert er sich, aktualisiere ihn; sinkt er, ist dies ein Befund.

So werden auch schleichende Qualitätsverluste erkennbar, die kurzfristig erfolgreiche Tests nicht aufdecken. Der Ratchet macht diese Grenze für den Build sichtbar.

## Sinnvolle Standardwerte

Wenn der Nutzer keinen eigenen Wert vorgibt, verwende die folgenden Ausgangswerte. Sie sind so gewählt, dass viele Codebasen sie anfangs erfüllen können.

| Qualitätsschranke | Standardwert | Begründung |
|------------|---------|-----------------|
| Coverage geänderter Zeilen | ≥ 80 % | Fördert Tests und lässt einzelne Konfigurationszeilen zu |
| Projekt-Coverage | aktueller Wert, darf nicht sinken | Ausgangswert lässt sich ohne neues Ziel übernehmen |
| Mutationswert, falls verwendet | zunächst ≥ 60 % | Typischer Einstieg für eine bisher nicht mutierte Testsuite; 80 % gelten als reif |
| Schwachstellen in Abhängigkeiten | keine ab hoch | Niedrigere Befunde sind häufig weniger relevant |
| LCP | ≤ 2500 ms | Schwelle für „gut“ bei Core Web Vitals |
| CLS | ≤ 0.1 | Entsprechende Schwelle |
| Barrierefreiheit | keine kritischen oder schwerwiegenden axe-Verstöße | Mittlere und geringfügige Verstöße sind häufiger abwägungsbedürftig |
| Dauer einer Ausnahme | 90 Tage | Genug Zeit für die Planung, aber zeitlich begrenzt |
| Ratchet-Toleranz | 0.5 % | Fängt Verschiebungen durch nicht zusammenhängende Dateien ab |

Nenne Wert und Begründung gemeinsam, damit der Grenzwert später nachvollziehbar bleibt.

## Ausbaustufen

Qualitätsschranken können auf drei Stufen durchgesetzt werden. Beginne mit der ersten.

1. **Nur dokumentiert.** `CONSTRAINTS.md` existiert und wird von Agenten gelesen. Dies ist einfach, setzt aber die Einhaltung voraus.
2. **Skriptgesteuert.** `npm run check` oder `make check` führt schnelle Prüfungen aus und wird in den Post-Edit-Hook des Agenten und CI eingebunden.
3. **Werkzeuggestützt.** Ein dedizierter Runner behandelt Diff-Begrenzung, Budgets, Ratchets und Schutzprüfungen. Nutze ihn, wenn die Konfiguration für ein Shellskript zu groß wird. [references/floor-guard.md](references/floor-guard.md) ist der Ausgangspunkt für die Schutzprüfungen.

Für die meisten Projekte reicht Stufe 2. Erwäge Stufe 3, wenn mehr als etwa dreißig Zeilen Shellcode zur Prüfausführung gepflegt werden.

**Ein erster Lauf kann sich auf das Mindestniveau beschränken.** Der Floor Guard prüft nur den Diff und benötigt keine Installation. Ergänze bezifferte Dimensionen mit ihren jeweiligen Werkzeugen schrittweise. Systemweit installierte Sicherheitswerkzeuge wie gitleaks und osv-scanner können auch nur in CI laufen. Dokumentiere den Ausführungsort jeder Dimension in der Spalte `Runs at`.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|--------|---------|
| „Qualitätsschranken ergänzen wir, wenn der Code stabil ist.“ | Der Code entwickelt sich um das herum, was bis dahin erlaubt war. |
| „Die Tests sind unsere Qualitätsschranken.“ | Eigene Tests allein belegen weder Coverage neuen Codes noch Abhängigkeitsrisiken oder Bundle-Wachstum. |
| „80 % Coverage erreichen wir nicht.“ | Setze stattdessen den heutigen Wert und verhindere eine Verschlechterung. |
| „Das bremst den Agenten.“ | Langsame Prüfungen gehören nicht in die schnelle Änderungsschleife. |
| „Ich merke mir unsere Standards.“ | Der Agent benötigt dokumentierte Standards. |
| „Qualitätsschranken verhindern die Veröffentlichung.“ | Eine befristete Ausnahme mit Verantwortlichem kann helfen; das Löschen der Schranke wirkt dauerhaft. |

## Warnzeichen

Halte inne und prüfe das Vorgehen, wenn:

- Das Interview mehr als vier Fragen umfasst oder eine unverständliche Konfiguration erzeugt
- Ein aktuell nicht erfülltes Budget ohne Plan zu seiner Erreichung festgelegt wurde
- Eine Dimension in CONSTRAINTS.md einen Wert, aber kein Prüfwerkzeug besitzt
- Ein eigener Prüfer ein etabliertes Werkzeug ersetzt und dadurch Teamkonfigurationen ignoriert
- Alle Qualitätsschranken nur durch die eigene Testsuite und keine extern geprüft werden
- `CONSTRAINTS.md` im selben Commit wie das zuvor fehlgeschlagene Feature geändert wurde
- Einer Ausnahme ein Verantwortlicher fehlt oder sie erst in über einem Jahr abläuft
- Der Agent eine Abschwächung statt einer Codekorrektur vorschlägt
- Langsame Prüfungen in der Änderungsschleife liegen und `--no-verify` verwendet wird
- Seit Erstellung niemand `CONSTRAINTS.md` geöffnet hat

## Überprüfung

Der Skill wurde korrekt angewendet, wenn:

- [ ] `CONSTRAINTS.md` existiert und jeder Zahlenwert begründet ist
- [ ] Das Mindestniveau durchgesetzt wird und die aktuelle Codebasis es unverändert besteht
- [ ] Jede gewählte Dimension ein installiertes Werkzeug und einen ausführbaren Befehl besitzt
- [ ] Jede Schranke ihren Ausführungsort nennt und die schnelle Phase wenige Sekunden nicht überschreitet
- [ ] Mindestens eine Qualitätsschranke extern geprüft wird
- [ ] Nur gemessene Metriken ihren aktuellen Wert und ihre Richtung festhalten
- [ ] Ausnahmen einen Verantwortlichen und ein Ablaufdatum besitzen
- [ ] `AGENTS.md` oder `CLAUDE.md` auf die Datei verweist
- [ ] Ein Probelauf auf dem aktuellen Branch keine vom Nutzer abgelehnten Fehler erzeugt
- [ ] Jeder durchgesetzte Befehl bei absichtlichem Verstoß und Scannerfehler fehlschlägt, eine saubere Kontrolle besteht und die vereinbarte Schweregradschwelle einhält

## Siehe auch

- `interview-me` — Vorgehen mit jeweils einer Frage
- `code-review-and-quality` — Durchführung des Reviews; dieser Skill legt dessen Qualitätsschranken fest
- `ci-cd-and-automation` — Erstellung der Pipeline für die Prüfungen
- `test-driven-development` — Testsuite als Grundlage für Coverage- und Mutationstests
- `security-and-hardening` — Inhalte der Sicherheitsdimension
- `performance-optimization` — Ermittlung von Performance-Werten
