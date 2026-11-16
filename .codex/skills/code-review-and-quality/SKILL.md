---
name: code-review-and-quality
description: Prüft Codeänderungen anhand mehrerer Qualitätsdimensionen vor dem Merge. Nutze den Skill für eigenen oder fremden Code, Diffs und Pull Requests sowie zur Beurteilung von Korrektheit, Lesbarkeit, Architektur, Sicherheit und Performance.
---

# Code-Review und Qualität

## Überblick

Mehrdimensionales Code-Review mit Qualitätsschranken: Jede Änderung wird vor dem Merge geprüft. Das Review umfasst Korrektheit, Lesbarkeit, Architektur, Sicherheit und Performance.

**Maßstab für die Freigabe:** Gib eine Änderung frei, wenn sie die Qualität der Codebasis insgesamt nachweislich verbessert, auch wenn sie nicht perfekt ist. Ziel ist kontinuierliche Verbesserung. Blockiere eine Änderung nicht allein deshalb, weil du sie anders geschrieben hättest. Verbessert sie die Codebasis und folgt den Projektkonventionen, gib sie frei.

## Wann verwenden

- Vor dem Merge eines PR oder einer Änderung
- Nach Abschluss einer Feature-Implementierung
- Bei der Beurteilung von Code eines anderen Agenten oder Modells
- Beim Refactoring bestehenden Codes
- Nach einer Fehlerkorrektur: Korrektur und Regressionstest prüfen

## Review anhand von fünf Dimensionen

Jedes Review bewertet den Code anhand folgender Dimensionen:

### 1. Korrektheit

Tut der Code, was er soll?

- Entspricht er der Spec oder den Aufgabenanforderungen?
- Werden Randfälle behandelt, etwa null, leere Werte und Grenzwerte?
- Werden neben dem Erfolgsfall auch Fehlerpfade behandelt?
- Besteht er alle Tests? Prüfen die Tests tatsächlich das Richtige?
- Gibt es Off-by-one-Fehler, Race Conditions oder inkonsistente Zustände?

### 2. Lesbarkeit und Einfachheit

Kann eine andere entwickelnde Person oder ein Agent den Code ohne Erklärung des Autors verstehen?

- Sind Namen aussagekräftig und entsprechen sie Projektkonventionen? Kein `temp`, `data` oder `result` ohne Kontext.
- Ist der Kontrollfluss einfach, ohne verschachtelte ternäre Ausdrücke oder tiefe Callbacks?
- Ist der Code logisch gegliedert, mit zusammengehörigem Code und klaren Modulgrenzen?
- Gibt es schwer verständliche Tricks, die vereinfacht werden sollten?
- **Ist eine Umsetzung mit weniger Zeilen möglich?** 1000 Zeilen, wo 100 ausreichen, sind problematisch.
- **Rechtfertigen Abstraktionen ihre Komplexität?** Verallgemeinere nicht vor dem dritten Anwendungsfall.
- Würden Kommentare eine nicht offensichtliche Absicht klären? Kommentiere jedoch keinen offensichtlichen Code.
- Gibt es Reste toten Codes, etwa wirkungslose Variablen (`_unused`), Kompatibilitäts-Shims oder `// removed`-Kommentare?
- **Wird eine neue Bedingung an einen sachfremden Ablauf angehängt?** Das ist ein Entwurfsproblem. Verschiebe die Logik in eine eigene Hilfsfunktion, einen Zustand oder eine Regel.
- **Wiederholen sich Bedingungen für dieselbe Struktur?** Das deutet auf ein fehlendes Modell oder einen Dispatcher hin. Ein „vorübergehender“ Zweig wird häufig zu dauerhafter technischer Schuld.

### 3. Architektur

Passt die Änderung zum Systementwurf?

- Folgt sie bestehenden Mustern? Ist ein neues Muster begründet?
- Bleiben Modulgrenzen klar?
- Gibt es Code-Duplikate, die gemeinsam genutzt werden sollten?
- Verlaufen Abhängigkeiten in die richtige Richtung, ohne zyklische Abhängigkeiten?
- Ist das Abstraktionsniveau angemessen, ohne Überkonzeption oder zu starke Kopplung?
- **Verringert das Refactoring Komplexität oder verschiebt es sie nur?** Zähle die Konzepte, die Lesende zum Verständnis benötigen. Bevorzuge Umstrukturierungen, die ganze Zweige, Modi oder Schichten entfernen, statt dieselbe Logik nur erneut zu zentralisieren. Entferne eine unnötige Abstraktion lieber, als sie nur zu überarbeiten.
- **Gelangt Feature-Logik in ein gemeinsames oder allgemeines Modul?** Belasse sie in ihrer zuständigen Schicht und verwende vorhandene maßgebliche Hilfsfunktionen statt ähnlicher Duplikate.
- **Sind Typgrenzen explizit?** Hinterfrage unnötige `any`/`unknown`/optional/casts und stille Fallbacks, die unklare Invarianten verdecken.

### 4. Sicherheit

Ausführliche Sicherheitshinweise stehen in `security-and-hardening`. Führt die Änderung Sicherheitslücken ein?

- Werden Nutzereingaben validiert und bereinigt?
- Bleiben Geheimnisse aus Code, Logs und Versionsverwaltung heraus?
- Werden Authentifizierung und Autorisierung bei Bedarf geprüft?
- Sind SQL-Abfragen parametrisiert und werden Zeichenketten nicht verkettet?
- Werden Ausgaben zum Schutz vor XSS kodiert?
- Stammen Abhängigkeiten aus vertrauenswürdigen Quellen und sind keine Schwachstellen bekannt?
- Werden externe Daten aus APIs, Logs, Nutzerinhalten und Konfigurationsdateien als nicht vertrauenswürdig behandelt?
- Werden externe Daten an Systemgrenzen validiert, bevor sie in Logik oder Darstellung eingehen?

### 5. Performance

Ausführliche Hinweise zu Profiling und Optimierung stehen in `performance-optimization`. Führt die Änderung Performanceprobleme ein?

- Gibt es N+1-Abfragemuster?
- Gibt es unbegrenzte Schleifen oder unbeschränkte Datenabrufe?
- Sollten synchrone Operationen asynchron sein?
- Werden UI-Komponenten unnötig erneut gerendert?
- Fehlt bei Listenendpunkten die Paginierung?
- Werden große Objekte in häufig ausgeführten Codepfaden erzeugt?

## Strukturelle Verbesserungen

Schlage bei strukturellen Problemen eine konkrete Verbesserung vor. Ein Hinweis wie „das ist komplex“ allein lässt offen, was zu tun ist. Mögliche Umstrukturierungen:

- **Ersetze eine Kette von Bedingungen** durch ein typisiertes Modell oder einen expliziten Dispatcher.
- **Fasse doppelte Zweige** zu einem klaren Ablauf zusammen.
- **Trenne Orchestrierung und Geschäftslogik**, sodass beide für sich verständlich sind.
- **Verschiebe Feature-Logik** aus einem gemeinsamen Modul in das zuständige Paket.
- **Verwende die maßgebliche Hilfsfunktion erneut**, statt ein ähnliches Duplikat zu erstellen.
- **Mache Typgrenzen explizit**, damit nachgelagerte Verzweigungen entfallen.
- **Entferne durchreichende Wrapper**, die nur Indirektion hinzufügen, ohne die API zu klären.
- **Extrahiere eine Hilfsfunktion oder teile eine große Datei** in überschaubare Module auf.

Bevorzuge eine Lösung, die Bestandteile entfernt, gegenüber einer, die dieselbe Komplexität nur verteilt.

## Umfang von Änderungen

Kleine, fokussierte Änderungen lassen sich leichter prüfen, schneller zusammenführen und sicherer deployen. Orientiere dich an folgenden Größen:

```
~100 geänderte Zeilen  → Gut. In einer Sitzung überprüfbar.
~300 geänderte Zeilen  → Für eine einzelne logische Änderung akzeptabel.
~1000 geänderte Zeilen → Zu groß. Aufteilen.
```

**Beachte die Dateigröße, nicht nur den Diff.** Auch ein kleiner Diff kann eine Datei über eine sinnvolle Größe hinaus anwachsen lassen. Rund 1000 *gesamte* Zeilen in einer Datei sind ein Prüfsignal, keine feste Obergrenze und nicht mit den oben genannten ~1000 *geänderten* Zeilen zu verwechseln. Prüfe vor einer größeren Erweiterung einer bereits großen Datei, ob zuerst Hilfsfunktionen, Unterkomponenten oder Module ausgelagert werden sollten.

**Was als „eine Änderung“ zählt:** Eine in sich abgeschlossene Änderung behandelt eine Sache, umfasst zugehörige Tests und erhält die Funktionsfähigkeit des Systems nach der Einreichung. Das kann ein Teil eines Features sein.

**Strategien zum Aufteilen zu großer Änderungen:**

| Strategie | Vorgehen | Einsatz |
|----------|-----|------|
| **Stack** | Kleine Änderung einreichen und nächste darauf aufbauen | Aufeinanderfolgende Abhängigkeiten |
| **Nach Dateigruppen** | Änderungen für Gruppen mit unterschiedlichen Reviewern trennen | Querschnittsthemen |
| **Horizontal** | Zuerst gemeinsamen Code oder Stubs erstellen, danach nutzenden Code | Geschichtete Architektur |
| **Vertikal** | Feature in kleinere vollständige Full-Stack-Teile zerlegen | Feature-Arbeit |

**Wann große Änderungen akzeptabel sind:** Beim vollständigen Löschen von Dateien und bei automatisiertem Refactoring, wenn Reviewer die Absicht statt jeder einzelnen Zeile prüfen müssen.

**Trenne Refactoring und Feature-Arbeit.** Eine Umstrukturierung bestehenden Codes und neues Verhalten sind zwei Änderungen und werden getrennt eingereicht. Kleine Bereinigungen wie das Umbenennen von Variablen können nach Ermessen des Reviewers enthalten sein.

## Beschreibungen von Änderungen

Jede Änderung benötigt eine Beschreibung, die in der Versionshistorie für sich verständlich ist.

**Erste Zeile:** Kurz, im Imperativ und für sich verständlich. Sie soll die Änderung bei der Suche in der Historie ohne Lesen des Diffs erkennen lassen.

**Haupttext:** Beschreibe, was sich ändert und warum. Ergänze Kontext, Entscheidungen und Begründungen, die nicht aus dem Code hervorgehen. Verlinke bei Bedarf Fehlernummern, Benchmark-Ergebnisse oder Entwurfsdokumente und benenne bekannte Schwächen des Ansatzes.

**Antipatterns:** Unbestimmte Beschreibungen wie „Fehler beheben“, „Build reparieren“, „Patch ergänzen“, „Code von A nach B verschieben“ oder „Phase 1“.

## Review-Ablauf

### Schritt 1: Kontext verstehen

Kläre vor der Codeprüfung die Absicht:

```
- Was soll die Änderung erreichen?
- Welche Spec oder Aufgabe setzt sie um?
- Welche Verhaltensänderung wird erwartet?
```

### Schritt 2: Zuerst die Tests prüfen

Tests zeigen Absicht und Abdeckung:

```
- Gibt es Tests für die Änderung?
- Prüfen sie Verhalten statt Implementierungsdetails?
- Sind Randfälle abgedeckt?
- Sind die Tests aussagekräftig benannt?
- Würden die Tests eine Regression nach einer Codeänderung erkennen?
```

Beantworte die letzte Frage experimentell statt nur durch Lesen. Kehre eine durch die Änderung ergänzte Bedingung um, etwa durch Entfernen einer Negation oder Ersetzen von `&&` durch `||`, führe die Testsuite aus und stelle die Datei anschließend aus einer Kopie wieder her. Bleiben die Tests trotz Mutation grün, ist dies ein Befund: Benenne den fehlenden Testfall. Für einen projektweiten Mutationswert siehe `constraint-driven-development`.

### Schritt 3: Implementierung prüfen

Gehe den Code anhand der fünf Dimensionen durch:

```
Für jede geänderte Datei:
1. Korrektheit: Tut der Code, was der Test verlangt?
2. Lesbarkeit: Kann ich ihn ohne Hilfe verstehen?
3. Architektur: Passt er zum System?
4. Sicherheit: Gibt es Schwachstellen?
5. Performance: Gibt es Engpässe?
```

### Schritt 4: Befunde einordnen

Gleiche einen Befund vor der Meldung mit den Aufrufern, Schutzprüfungen und Tests ab, die den geänderten Code erreichen; verwerfe ihn, wenn sie ihn ausschließen. Kennzeichne bereits im Ausgangsstand bestehende Fehler getrennt von neu eingeführten Regressionen. Keine Befunde sind ein gültiges Ergebnis; erfinde keine.

Kennzeichne jeden Kommentar nach Schweregrad, damit verpflichtende Änderungen und optionale Hinweise unterscheidbar sind:

| Präfix | Bedeutung | Handlung des Autors |
|--------|---------|---------------|
| *(kein Präfix)* | Erforderliche Änderung | Vor dem Merge behandeln |
| **Critical:** | Blockiert den Merge | Sicherheitslücke, Datenverlust oder defekte Funktionalität |
| **Nit:** | Geringfügig, optional | Kann ignoriert werden, etwa Formatierung oder Stilvorlieben |
| **Optional:** / **Consider:** | Vorschlag | Erwägenswert, aber nicht verpflichtend |
| **FYI** | Nur zur Information | Keine Handlung nötig; Kontext für später |

So werden optionale Vorschläge nicht mit verpflichtenden Änderungen verwechselt.

**Nenne das Wichtigste zuerst.** Ordne Befunde nach Bedeutung: zuerst Korrektheit und Sicherheit, dann strukturelle Regressionen und versäumte Vereinfachungen, danach übrige Punkte. Verstecke wesentliche Probleme nicht unter kosmetischen Hinweisen.

### Schritt 5: Nachweise prüfen

Prüfe die vom Autor dokumentierten Nachweise:

```
- Welche Tests wurden ausgeführt?
- War der Build erfolgreich?
- Wurde die Änderung manuell geprüft?
- Gibt es Screenshots für UI-Änderungen?
- Gibt es einen Vorher-nachher-Vergleich?
```

## Review-Muster mit mehreren Modellen

Delegiere die Prüfung bei Anwendung dieses Skills an einen eigenen, unabhängigen Subagenten mit getrenntem Kontext, sofern Delegation in der Sitzung verfügbar und zulässig ist. Bevorzuge ein anderes Modell, wenn es verfügbar und für den Auftrag zugelassen ist; andernfalls nutze dasselbe Modell mit getrenntem Kontext. Die Hauptinstanz bewertet und integriert die Befunde. Ist kein Subagent oder kein getrennter Kontext verfügbar oder zulässig, melde die Einschränkung und kennzeichne eine gegebenenfalls durchgeführte Selbstprüfung ausdrücklich; behaupte keine unabhängige Prüfung. Beachte `.codex/rules/DELEGATION.md`.

Ein mögliches Muster:

```
Model A schreibt den Code
    │
    ▼
Unabhängiger Subagent prüft Korrektheit und Architektur
(bevorzugt Model B, sonst Model A in getrenntem Kontext)
    │
    ▼
Model A bearbeitet das Feedback
    │
    ▼
Ein Mensch trifft die endgültige Entscheidung
```

Das kann Probleme aufdecken, die ein einzelnes Modell übersieht; verschiedene Modelle haben unterschiedliche blinde Flecken.

**Beispiel-Prompt für einen Review-Agenten:**
```
Prüfe diese Codeänderung auf Korrektheit, Sicherheit und Einhaltung
unserer Projektkonventionen. Die Spec sagt [X]. Die Änderung soll [Y].
Kennzeichne Befunde als Critical, Required, Optional oder Nit.
```

## Umgang mit totem Code

Prüfe nach Refactoring oder Implementierungsänderungen auf verwaisten Code:

1. Nicht mehr erreichbaren oder verwendeten Code ermitteln
2. Die betreffenden Elemente ausdrücklich auflisten
3. **Vor dem Löschen fragen:** „Soll ich diese nicht mehr verwendeten Elemente entfernen: [Liste]?“

Toter Code erschwert späteren Lesenden und Agenten das Verständnis. Lösche jedoch nichts stillschweigend, wenn seine Verwendung unklar ist; frage im Zweifel nach.

```
TOTER CODE ERMITTELT:
- formatLegacyDate() in src/utils/date.ts — durch formatDate() ersetzt
- Komponente OldTaskCard in src/components/ — durch TaskCard ersetzt
- Konstante LEGACY_API_URL in src/config.ts — keine Verweise mehr
→ Können diese Elemente entfernt werden?
```

## Geschwindigkeit des Reviews

Langsame Reviews können ganze Teams blockieren. Der Aufwand für einen Kontextwechsel zum Review ist geringer als die Wartezeit anderer Beteiligter.

- **Antworte innerhalb eines Arbeitstags**; dies ist die Obergrenze, nicht das Ziel.
- **Idealer Rhythmus:** Antworte kurz nach Eingang einer Review-Anfrage, sofern du nicht mitten in konzentrierter Entwicklungsarbeit bist. Eine typische Änderung sollte mehrere Review-Runden an einem Tag durchlaufen können.
- **Bevorzuge schnelle einzelne Rückmeldungen** gegenüber einer schnellen endgültigen Freigabe. Zeitnahes Feedback hilft auch bei mehreren Runden.
- **Große Änderungen:** Bitte den Autor um Aufteilung, statt einen sehr großen Änderungssatz auf einmal zu prüfen.

## Umgang mit Meinungsverschiedenheiten

Nutze bei Meinungsverschiedenheiten im Review folgende Reihenfolge:

1. **Technische Fakten und Daten** haben Vorrang vor Meinungen und Vorlieben.
2. **Styleguides** sind für Stilfragen maßgeblich.
3. **Softwareentwurf** wird anhand technischer Prinzipien statt persönlicher Vorlieben beurteilt.
4. **Konsistenz der Codebasis** ist sinnvoll, sofern sie deren Gesamtqualität nicht verschlechtert.

**Akzeptiere keine pauschale spätere Bereinigung.** Verschobene Bereinigungen werden erfahrungsgemäß selten erledigt. Verlange sie vor der Einreichung, außer bei einem tatsächlichen Notfall. Können umliegende Probleme nicht in dieser Änderung behoben werden, verlange ein selbst zugewiesenes Bug-Ticket.

## Ehrlichkeit im Review

Beim Review eigenen Codes oder von Code anderer Agenten beziehungsweise Menschen:

- **Nicht ungeprüft abnicken.** „LGTM“ ohne Nachweis einer Prüfung hilft nicht.
- **Tatsächliche Probleme nicht abschwächen.** Ein Fehler mit Auswirkungen auf Produktion sollte nicht als bloße Kleinigkeit bezeichnet werden.
- **Probleme nach Möglichkeit quantifizieren.** Eine geschätzte zusätzliche Zeit pro Listenelement ist aussagekräftiger als „könnte langsam sein“.
- **Problematischen Ansätzen widersprechen.** Benenne konkrete Mängel direkt und schlage Alternativen vor.
- **Überstimmungen sachlich akzeptieren.** Hat der Autor den vollständigen Kontext und widerspricht, respektiere seine Entscheidung. Kommentiere den Code statt der Person.

## Sorgfalt bei Abhängigkeiten

Das Code-Review umfasst auch Abhängigkeiten.

**Vor dem Hinzufügen einer Abhängigkeit:**
1. Löst der vorhandene Stack das Problem bereits?
2. Wie groß ist die Abhängigkeit? Prüfe ihre Auswirkung auf das Bundle.
3. Wird sie aktiv gepflegt? Prüfe den letzten Commit und offene Issues.
4. Gibt es bekannte Sicherheitslücken? (`npm audit`)
5. Welche Lizenz gilt? Sie muss mit dem Projekt kompatibel sein.

**Regel:** Bevorzuge Standardbibliothek und vorhandene Hilfsfunktionen gegenüber neuen Abhängigkeiten. Jede Abhängigkeit bringt Aufwand und Risiken mit sich.

**Das Upgrade einer bestehenden Abhängigkeit** ist eine Codeänderung und wird ebenso sorgfältig geprüft. Besonders riskant sind gebündelte Upgrades mit pauschaler Beschreibung:

1. **Lies das Changelog, nicht nur die Versionsnummer.** Auch ein „patch“ kann Verhalten ändern. Lies bei einem Major-Upgrade die Migrationshinweise und ermittle inkompatible Änderungen.
2. **Eine Abhängigkeit pro Änderung.** Aktualisiere und merge einzeln oder in kleinen zusammengehörigen Gruppen. So lassen sich Fehlerursache und Rücknahme leichter eingrenzen.
3. **Lass die Tests entscheiden.** Die Testsuite muss vor *und* nach dem Upgrade bestehen; eine erfolgreiche Installation genügt nicht. Fehlt Testabdeckung für das Abhängigkeitsverhalten, ergänze zuerst einen Test.
4. **Beachte transitive Abhängigkeiten.** Prüfe den Lockfile-Diff und nicht nur `package.json`; ein direktes Upgrade kann viele indirekte Änderungen mitbringen.
5. **Halte die Lockfile verlässlich.** Committe sie, prüfe ihren Diff und bearbeite sie niemals manuell. Sie fixiert die tatsächlich ausgelieferten Versionen.

Für die Bewertung von `npm audit`-Befunden und Lieferkettenrisiken wie Typosquatting oder kompromittierten Maintainern nutze `security-and-hardening`. Dieser Abschnitt behandelt den Upgrade-*Ablauf*, jener die Sicherheitsbewertung.

## Review-Checkliste

```markdown
## Review: [PR/Change title]

### Context
- [ ] I understand what this change does and why

### Correctness
- [ ] Change matches spec/task requirements
- [ ] Edge cases handled
- [ ] Error paths handled
- [ ] Tests cover the change adequately

### Readability
- [ ] Names are clear and consistent
- [ ] Logic is straightforward
- [ ] No unnecessary complexity

### Architecture
- [ ] Follows existing patterns
- [ ] No unnecessary coupling or dependencies
- [ ] Appropriate abstraction level
- [ ] Refactors reduce complexity rather than relocate it
- [ ] No feature logic in shared modules; file stays within a healthy size

### Security
- [ ] No secrets in code
- [ ] Input validated at boundaries
- [ ] No injection vulnerabilities
- [ ] Auth checks in place
- [ ] External data sources treated as untrusted

### Performance
- [ ] No N+1 patterns
- [ ] No unbounded operations
- [ ] Pagination on list endpoints

### Verification
- [ ] Tests pass
- [ ] Build succeeds
- [ ] Manual verification done (if applicable)

### Verdict
- [ ] **Approve** — Ready to merge
- [ ] **Request changes** — Issues must be addressed
```
## Siehe auch

- Ausführliche Hinweise zum Sicherheitsreview stehen in `.codex/ai-engineering/references/security-checklist.md` relativ zum Projektverzeichnis.
- Prüfungen für das Performance-Review stehen in `.codex/ai-engineering/references/performance-checklist.md` relativ zum Projektverzeichnis.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Es funktioniert, das reicht.“ | Unlesbarer, unsicherer oder architektonisch unpassender Code erzeugt wachsende technische Schuld. |
| „Ich habe es geschrieben und weiß, dass es korrekt ist.“ | Autoren übersehen eigene Annahmen; ein weiterer Blick hilft. |
| „Wir bereinigen es später.“ | Verschobene Bereinigung bleibt häufig aus. Nutze das Review als Qualitätsschranke und verlange sie vor dem Merge. |
| „KI-generierter Code wird schon passen.“ | Auch plausibler KI-Code muss sorgfältig geprüft werden. |
| „Die Tests bestehen, also ist alles gut.“ | Tests allein erkennen nicht alle Architektur-, Sicherheits- oder Lesbarkeitsprobleme. |
| „Das Refactoring macht den Code sauberer.“ | Verschobene Komplexität ist keine reduzierte Komplexität. Suche nach einer Struktur, in der Zweige entfallen. |
| „Die Datei erhält nur eine kleine Ergänzung.“ | Auch kleine Diffs können große Dateien weiter vergrößern oder sachfremde Abläufe verzweigen. Beurteile die resultierende Struktur. |
| „Es ist nur ein Versionsupdate.“ | Ein Upgrade kann Verhalten verändern. Lies das Changelog; semver garantiert keine Fehlerfreiheit. |
| „Ich aktualisiere alles in einem PR.“ | Bei einem fehlschlagenden Build ist die Ursache schwerer einzugrenzen. Einzelne Änderungen erleichtern Fehlersuche und Rücknahme. |

## Warnzeichen

- PRs werden ohne Review gemergt
- Das Review prüft nur Testergebnisse und ignoriert andere Dimensionen
- „LGTM“ ohne Nachweis einer tatsächlichen Prüfung
- Sicherheitsrelevante Änderungen ohne entsprechendes Sicherheitsreview
- PRs sind zu groß für ein angemessenes Review und sollten aufgeteilt werden
- Fehlerkorrekturen ohne Regressionstests
- Review-Kommentare ohne Schweregrad, sodass verpflichtende und optionale Hinweise unklar bleiben
- Eine pauschal versprochene spätere Korrektur wird akzeptiert
- Refactoring verschiebt Code, ohne die Zahl der zum Verständnis nötigen Konzepte zu verringern
- Eine bereits große Datei wächst weiter, statt aufgeteilt zu werden
- Neue Bedingungen werden in sachfremde Codepfade eingefügt; eine Abstraktion könnte fehlen
- Eine individuelle Hilfsfunktion dupliziert eine vorhandene maßgebliche Funktion oder Feature-Logik liegt in einem gemeinsamen Modul
- Ein PR aktualisiert viele Abhängigkeiten ohne Changelog-Prüfung und Trennung pro Paket
- Eine Lockfile-Änderung wurde manuell bearbeitet, nicht committet oder ohne Diff-Prüfung gemergt

## Überprüfung

Nach Abschluss des Reviews:

- [ ] Alle Critical-Befunde sind behoben
- [ ] Alle Required-Änderungen ohne Präfix sind behoben oder ausdrücklich begründet zurückgestellt
- [ ] Tests bestehen
- [ ] Der Build ist erfolgreich
- [ ] Die Prüfung ist dokumentiert: Was wurde geändert und wie wurde es überprüft?
- [ ] Upgrades von Abhängigkeiten wurden anhand des Changelogs geprüft, pro Paket isoliert und mit bestandener Testsuite sowie geprüftem Lockfile-Diff verifiziert

**Mögliche Blocker:** Sprich die folgenden Punkte an und schlage jeweils einen einfacheren Entwurf vor. Stufe sie nur dann als Required ein, wenn die Änderung die Struktur tatsächlich verschlechtert: Ein Refactoring verschiebt Komplexität, statt sie zu verringern; eine Änderung vergrößert eine Datei über die Größenrichtlinie hinaus ohne Aufteilung; Feature-Logik gelangt in ein gemeinsames Modul; eine bestehende maßgebliche Hilfsfunktion wird nahezu dupliziert; oder ein stiller Fallback verdeckt eine unklare Invariante.
