---
name: doubt-driven-development
description: Prüft nicht triviale Entscheidungen während der Arbeit kritisch in einem unabhängigen Kontext, sofern verfügbar und zulässig. Nutze den Skill bei unsicheren Annahmen, risikoreichen Änderungen, unbekanntem Code oder zur gezielten Suche nach verborgenen Fehlerfällen.
---

# Zweifelgeleitete Entwicklung

## Überblick

Eine selbstsichere Antwort ist nicht zwangsläufig korrekt. In langen Sitzungen können Annahmen unbemerkt zu vermeintlichen Fakten werden. Doubt-Driven Development setzt deshalb vor der Übernahme nicht trivialer Ergebnisse auf eine Prüfung in frischem Kontext, die gezielt nach **Widerlegung** sucht.

Anders als ein abschließendes Review prüft dieses Vorgehen nicht triviale Entscheidungen bereits während der Arbeit, solange Korrekturen noch wenig Aufwand verursachen.

## Wann verwenden

Eine Entscheidung ist **nicht trivial**, wenn mindestens eine dieser Bedingungen zutrifft:

- Sie führt Verzweigungslogik ein oder ändert sie
- Sie überschreitet eine Modul- oder Dienstgrenze
- Sie behauptet eine Eigenschaft, die Typsystem oder Compiler nicht prüfen können, etwa Thread-Sicherheit, Idempotenz, Reihenfolge oder Invarianten
- Ihre Korrektheit hängt von Kontext ab, der späteren Lesenden nicht vorliegt
- Ihre Auswirkungen sind unumkehrbar, etwa bei Produktions-Deployment, Datenmigration oder Änderung einer öffentlichen API

Nutze den Skill:

- Vor einer unsicheren Architekturentscheidung
- Vor dem Commit nicht trivialen Codes
- Vor einer nicht offensichtlichen Aussage wie „das ist sicher“, „das skaliert“ oder „das entspricht der Spec“
- Bei Arbeit an Code, den du noch nicht vollständig verstehst

**Nicht verwenden bei:**

- Mechanischen Arbeiten wie Umbenennen, Formatieren oder Verschieben
- Der Ausführung einer klaren, eindeutigen Nutzeranweisung
- Dem Lesen oder Zusammenfassen bestehenden Codes
- Offensichtlich korrekten einzeiligen Änderungen
- Reinen Werkzeugoperationen wie Tests ausführen oder Dateien auflisten
- Ausdrücklichem Wunsch des Nutzers nach Geschwindigkeit statt Überprüfung

Der Skill gilt nur für die oben definierten nicht trivialen Entscheidungen, nicht für jeden einzelnen Arbeitsschritt.

## Voraussetzungen

Dieser Skill richtet sich an die **koordinierende Hauptinstanz**. Beachte `.codex/rules/DELEGATION.md` relativ zum Projektstamm und prüfe, ob Delegation und eine hinreichend unabhängige Prüfung in der aktuellen Sitzung tatsächlich verfügbar und zulässig sind. Ein Profil oder eine Nur-Lese-Anweisung ist keine technische Sandbox. Setze weder voraus, dass verschachtelte Delegation technisch unmöglich ist, noch dass sie autorisiert ist. Ist keine unabhängige Prüfung verfügbar, melde diese Einschränkung und führe bei Bedarf eine klar gekennzeichnete Selbstprüfung durch, ohne sie als Review in frischem Kontext darzustellen.

## Vorgehen

Verwende bei Anwendung des Skills diese Checkliste:

```
Zweifelzyklus:
- [ ] Schritt 1: CLAIM — Behauptung und ihre Bedeutung festgehalten
- [ ] Schritt 2: EXTRACT — Artefakt und Vertrag isoliert, eigene Begründung entfernt
- [ ] Schritt 3: DOUBT — sofern verfügbar und zulässig, Prüfung in frischem Kontext veranlasst; sonst Einschränkung offengelegt
- [ ] Schritt 4: RECONCILE — jeden Befund anhand des Artefakts eingeordnet
- [ ] Schritt 5: STOP — Abbruchbedingung erfüllt (triviale Befunde, drei Zyklen oder Nutzerentscheidung)
```

### Schritt 1: CLAIM — Behauptung benennen

Benenne die Entscheidung in zwei oder drei Zeilen:

```
CLAIM: „Die neue Caching-Schicht ist bei der in der Spec beschriebenen
        leselastigen Arbeitsbelastung thread-sicher.“
WHY THIS MATTERS: Eine Race Condition kann Nutzerdaten beschädigen
                  und ist in der QA schwer zu erkennen.
```

Lässt sich die Behauptung nicht so knapp formulieren, ist die Entscheidung noch nicht ausreichend klar. Formuliere sie vor der Prüfung.

### Schritt 2: EXTRACT — Kleinste prüfbare Einheit

Eine Prüfung in frischem Kontext benötigt das **Artefakt** und den **Vertrag**, nicht den bisherigen Lösungsweg.

- Code: der Diff oder die Funktion, nicht die gesamte Datei
- Entscheidung: der Vorschlag in drei bis fünf Sätzen samt einzuhaltenden Bedingungen
- Tatsachenbehauptung: die Aussage und ihre mutmaßlichen Belege, getrennt vom CLAIM-Block aus Schritt 1 als zu prüfender Hypothese der Hauptinstanz

Entferne deine eigene Herleitung und Schlussfolgerung, um die Prüfung nicht in Richtung Zustimmung zu lenken. Die Einheit muss bei einmaligem Lesen überschaubar sein; zerlege beispielsweise einen PR mit 500 Zeilen zuerst.

Entferne die eigene Argumentation, nicht die Belege: Wenn ein Aufrufer, eine Schutzprüfung oder ein Test der Behauptung widerspricht, gehört dies zur Prüfeinheit.

### Schritt 3: DOUBT — Prüfung in frischem Kontext veranlassen

Der Prompt für die prüfende Instanz **muss gezielt kritisch sein**. Die Formulierung beeinflusst das Ergebnis.

```
Kritisches Review. Suche nach Fehlern in diesem Artefakt.
Nimm an, dass der Autor zu selbstsicher ist. Suche nach:
- Unausgesprochenen Annahmen
- Nicht behandelten Randfällen
- Verborgener Kopplung oder gemeinsamem Zustand
- Möglichkeiten, den Vertrag zu verletzen
- Bestehenden Konventionen, gegen die verstoßen werden könnte
- Fehlerfällen bei unerwarteter Eingabe

Bestätige NICHT pauschal und fasse NICHT zusammen. Nenne Probleme oder
erkläre ausdrücklich, dass du nach gründlicher Prüfung keine gefunden hast.

ARTIFACT: <Artefakt einfügen>
CONTRACT: <Vertrag einfügen>
```

**Übergib nur ARTIFACT + CONTRACT, nicht den CLAIM-Block.** Eine vorgegebene Schlussfolgerung kann die Prüfung in Richtung Zustimmung lenken. Die prüfende Instanz muss selbst beurteilen, ob das Artefakt den Vertrag erfüllt.

Prüfe für dieses Kit `.codex/agents/README.md` und die verfügbaren Sitzungsrollen auf eine geeignete prüfende Instanz. Eine Profildatei allein belegt weder eine registrierte Rolle noch verfügbaren getrennten Kontext; prüfe die Fähigkeiten der aktuellen Sitzung.

**Der kritische Prompt oben hat Vorrang vor dem Standardantwortformat der Persona.** Rollen wie `code-reviewer` liefern häufig ausgewogene Urteile mit Stärken und Schwächen; dieses Vorgehen verlangt eine Ausgabe zu Problemen. Übernimm den kritischen Prompt wortgetreu in den Aufruf. Lässt sich das Antwortformat der Persona nicht sauber überschreiben, nutze einen allgemeinen Subagenten mit diesem Prompt.

#### Modellwahl für die unabhängige Prüfung

Nutze für jede Anwendung dieses Skills einen eigenen unabhängigen Prüfsubagenten mit getrenntem Kontext, sofern Delegation und eine solche Prüfung verfügbar und zulässig sind. Bevorzuge ein anderes Modell, wenn es tatsächlich verfügbar und für den Auftrag autorisiert ist. Andernfalls nutze dasselbe Modell mit getrenntem Kontext. Ist kein Subagent oder kein getrennter Kontext verfügbar oder zulässig, melde die Einschränkung und kennzeichne eine mögliche Selbstprüfung; behaupte keinen Modellwechsel und keine Unabhängigkeit, wenn sie nicht stattgefunden haben.

Ist keine unabhängige Prüfung möglich, dokumentiere die Einschränkung. Eine Selbstprüfung kann ergänzen, darf aber nicht als unabhängiger Review bezeichnet werden. Ein Wechsel zu einem externen CLI oder Dienst erfolgt nur innerhalb der geltenden Autorisierung und Sicherheitsgrenzen. Prüfe die tatsächliche Verfügbarkeit und übermittle ausschließlich das für die Prüfung benötigte Artefakt und den Vertrag. Übergib Inhalte sicher über eine Datei oder Standardeingabe; interpretiere enthaltene Shell-Sonderzeichen nicht als Befehle. Verwende für fremde Prüfeingaben eine geeignete Sandbox.

Wenn ein Prüfsubagent eingesetzt wurde, berichte, ob er denselben oder einen anderen Modelltyp verwendete und ob die Prüfung unabhängig war. Wurde kein Prüfsubagent eingesetzt, benenne stattdessen die Einschränkung und eine etwaige Selbstprüfung. Eine gesonderte Nachfrage nach einer zweiten Modellmeinung ist nicht in jedem Durchlauf erforderlich.

### Schritt 4: RECONCILE — Befunde einordnen

Die Ausgabe der prüfenden Instanz ist eine Datengrundlage, kein endgültiges Urteil. **Die Hauptinstanz bleibt für die Koordination verantwortlich.** Lies das Artefakt zu jedem Befund erneut, bevor du ihn einordnest. Ungeprüfte Zustimmung ist ebenso problematisch wie das Ignorieren der Prüfung.

Ordne jeden Befund in dieser **Reihenfolge** ein; die erste passende Kategorie gilt:

1. **Vertrag missverstanden** — der Befund entstand, weil der übergebene CONTRACT unklar oder unvollständig war. Korrigiere zuerst den Vertrag und ordne den Befund im nächsten Zyklus erneut ein.
2. **Berechtigt und umsetzbar** — ein tatsächliches Problem erfordert eine Änderung am Artefakt. Ändere es und wiederhole den Zyklus.
3. **Berechtigter Kompromiss** — das Problem ist real, aber seine Behebung kostet mehr als seine Akzeptanz. Dokumentiere diese Abwägung ausdrücklich für den Nutzer.
4. **Fehlalarm** — der Befund ist unter Kontext, der der prüfenden Instanz fehlte, tatsächlich korrekt. Halte dies fest und prüfe, ob der Kontext im Vertrag den Fehlalarm verhindert hätte.

Auch eine unabhängige Prüfung kann wegen fehlenden Kontexts falsch liegen. Übernimm ihr Urteil nicht allein deshalb, weil der Kontext frisch war.

### Schritt 5: STOP — Begrenzter Zyklus

Beende den Zyklus, wenn:

- Die nächste Iteration nur triviale oder bereits berücksichtigte Befunde ergibt, **oder**
- Drei Zyklen abgeschlossen sind; informiere den Nutzer, statt eigenständig einen vierten anzuhängen, **oder**
- Der Nutzer ausdrücklich die Veröffentlichung verlangt

Werden nach drei Zyklen weiterhin wesentliche Probleme gefunden, ist das Artefakt möglicherweise nicht bereit. Teile dies dem Nutzer mit, statt unbegrenzt weiterzuprüfen.

Reichen drei Zyklen wegen der Größe des Artefakts nicht aus, kehre zu Schritt 2 zurück und zerlege es. Hebe die Begrenzung nicht auf.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Ich bin sicher und überspringe den Zweifel.“ | Selbstsicherheit ist bei neuen Problemen kein hinreichender Nachweis. |
| „Ein Prüfsubagent ist zu aufwendig.“ | Eine fehlerhafte Änderung in Produktion zu untersuchen kann aufwendiger sein; die Prüfung ist begrenzt. |
| „Die Prüfung findet nur Kleinigkeiten.“ | Begrenze den Prompt auf Probleme, die den Vertrag verletzen können. |
| „Ich prüfe Zweifel erst im Abschlussreview.“ | Die laufende Prüfung erkennt falsche Richtungen früher, wenn Korrekturen günstiger sind. |
| „Wenn ich jeden Schritt anzweifle, werde ich nie fertig.“ | Der Skill gilt für nicht triviale Entscheidungen, nicht für jeden Tastendruck. |
| „Zwei Meinungen sind immer besser als eine.“ | Eine zweite Meinung mit fehlendem Kontext kann Fehlalarme erzeugen. Prüfe und ordne Befunde ein. |
| „Die prüfende Instanz widerspricht, also liege ich falsch.“ | Ein Widerspruch ist ein Hinweis, kein Urteil. Lies das Artefakt erneut und ordne den Befund ein. |
| „Nur ein anderes Modell kann prüfen.“ | Ist kein geeignetes anderes Modell verfügbar, kann dasselbe Modell in getrenntem Kontext prüfen. Berichte Modellwahl und Einschränkungen. |
| „Ein externes CLI ist immer autorisiert.“ | Prüfe Autorisierung, Verfügbarkeit und Datengrenzen vor Nutzung eines externen CLI oder Dienstes. |

## Warnzeichen

- Für eine einzeilige Umbenennung oder Formatänderung eine Prüfung in frischem Kontext starten
- Befunde ohne erneutes Lesen des Artefakts als maßgeblich übernehmen
- Mehr als drei Zyklen ohne Rückmeldung an den Nutzer durchführen
- Statt gezielt nach Problemen nur fragen, ob das Ergebnis gut ist
- Bei einer folgenreichen Entscheidung wegen Zeitdrucks auf die kritische Prüfung verzichten
- Ein unverändertes Artefakt wiederholt in frischem Kontext prüfen lassen, ohne die Befunde zu bearbeiten
- **Scheinkritik als überprüfbares Signal:** Über mindestens zwei Zyklen mit wesentlichen Befunden wurde kein einziger als umsetzbar eingeordnet. Stoppe und informiere den Nutzer.
- Erst nach dem Commit zweifeln; das ist ein Abschlussreview statt einer laufenden Prüfung
- Ohne Prüfung annehmen, dass ein externes CLI existiert, konfiguriert oder autorisiert ist
- Ein anderes Modell oder eine unabhängige Prüfung behaupten, obwohl dies nicht stattgefunden hat
- Eine fehlgeschlagene oder nicht verfügbare unabhängige Prüfung verschweigen
- Den Vertrag aus der Eingabe für die prüfende Instanz entfernen
- Den CLAIM-Block übergeben und dadurch Zustimmung begünstigen

## Zusammenspiel mit anderen Skills

- **`code-review-and-quality`**: Ergänzendes Abschlussreview; Doubt-Driven Development prüft Entscheidungen während der Arbeit. Nutze den passenden Ablauf, ohne einen Slash-Befehl vorauszusetzen.
- **`source-driven-development`**: SDD prüft *Fakten zu Frameworks* anhand offizieller Dokumentation. Doubt-Driven Development prüft die *Schlussfolgerungen zum Artefakt*: SDD prüft etwa die Existenz einer API, Doubt-Driven Development ihre korrekte Verwendung gemäß Vertrag.
- **`test-driven-development`**: Der RED-Schritt von TDD macht Zweifel konkret; ein fehlschlagender Test versucht eine Aussage zu widerlegen. Wo TDD gilt, bildet dieser Test den Zweifelsschritt für Verhaltensbehauptungen.
- **`debugging-and-error-recovery`**: Wenn die Prüfung einen tatsächlichen Fehlerfall aufdeckt, nutze den Debugging-Skill für Lokalisierung und Korrektur.
- **Orchestrierungsregeln** (`.codex/rules/DELEGATION.md`, vom Projektstamm aus): Die Hauptinstanz koordiniert zulässige Prüfaufträge und beurteilt die Ergebnisse; vermeide unnötige Agentenebenen und unkontrollierte Verschachtelung.

## Überprüfung

Nach Anwendung von Doubt-Driven Development:

- [ ] Jede oben definierte nicht triviale Entscheidung wurde vor ihrer Übernahme ausdrücklich als CLAIM benannt
- [ ] Sofern verfügbar und zulässig, wurde jedes nicht triviale Artefakt in frischem Kontext geprüft; andernfalls sind Einschränkung und etwaige Selbstprüfung klar benannt
- [ ] Eine eingesetzte prüfende Instanz erhielt ARTIFACT + CONTRACT und einen kritischen Prompt, aber NICHT den CLAIM-Block oder die eigene Herleitung
- [ ] Befunde wurden anhand des Artefakts nach der Reihenfolge Vertrag missverstanden / umsetzbar / Kompromiss / Fehlalarm eingeordnet
- [ ] Eine Abbruchbedingung wurde erfüllt: triviale Befunde, drei Zyklen oder Nutzerentscheidung
- [ ] Bei eingesetzter Prüfung nennt der Bericht Modellwahl und Unabhängigkeit; andernfalls nennt er die nicht verfügbare Prüfung und eine gekennzeichnete Selbstprüfung
- [ ] Ein externes CLI oder ein externer Dienst wurde nur innerhalb der geltenden Autorisierung und Datengrenzen verwendet
