---
name: idea-refine
description: Schärft rohe Ideen durch strukturiertes divergentes und konvergentes Denken zu konkreten, umsetzbaren Konzepten. Nutzen, wenn eine Idee vage ist, Annahmen vor einem Plan geprüft oder Alternativen vor einer Entscheidung erweitert werden sollen. Auslöser sind unter anderem "ideate", "refine this idea" und "stress-test my plan".
---

# Idea Refine

## Überblick

Schärft rohe Ideen durch strukturiertes divergentes und konvergentes Denken zu konkreten, umsetzbaren Konzepten.

## Wann der Skill verwendet wird

Bei der Projektinitialisierung ist `$init` der Einstieg und steuert diesen Skill nach einem gegebenenfalls notwendigen `$interview-me`-Interview, sofern die Ideenschärfung noch nicht abgeschlossen ist. Lies die ursprüngliche Idee aus `.codex/IDEA.md`, berücksichtige Angaben aus dem Gespräch und bewahre die Ausgangsdatei unverändert. Schärfe die Idee mit dem Nutzer und erstelle anschließend `.codex/PROJECT.md` als nachvollziehbare Ausarbeitung mit Verweis auf `.codex/IDEA.md`. Lies eine bereits vorhandene `.codex/PROJECT.md` vor einem Schreibzugriff; gleiche sie mit der geschärften Idee ab, kläre wesentliche Widersprüche und überschreibe bestehende Inhalte nicht stillschweigend. Übergib das Ergebnis an `$init`, das bestehende Entscheidungen übernimmt und keine erneute Ideenschärfung durchführt. Stelle eine Frage pro Gesprächsrunde, wiederhole keine beantworteten Fragen und berücksichtige Alternativen entsprechend der noch offenen Unsicherheit.

- Wenn eine Idee noch vage ist und vor der Planung konkretisiert werden muss
- Wenn Annahmen vor einer Richtungsentscheidung kritisch geprüft werden sollen
- Wenn vor der Auswahl einer Richtung weitere Möglichkeiten betrachtet werden sollen
- Auslösende Formulierungen: „Hilf mir, diese Idee zu schärfen“, „Entwickle Ideen zu [Konzept]“ oder „Prüfe meinen Plan kritisch“; ebenso die bestehenden englischen Ausdrücke
- Nicht für Nutzer, deren Absicht grundsätzlich unklar ist (nutze `interview-me`), oder eine bereits gewählte Richtung, für die eine Spec benötigt wird (nutze `spec-driven-development`)

## Arbeitsweise

1. **Verstehen und erweitern (divergent):** Idee wiedergeben, klärende Fragen stellen und Varianten entwickeln.
2. **Bewerten und eingrenzen:** Ideen gruppieren, kritisch prüfen und verborgene Annahmen offenlegen.
3. **Schärfen und übergeben:** Eine konkrete Markdown-Kurzbeschreibung erstellen, die die Arbeit voranbringt.

## Verwendung

Dieser Skill wird hauptsächlich im Dialog verwendet. Rufe ihn mit einer Idee auf; der Agent führt durch den Prozess.

```bash
# Optional. Run from the project root so this creates ./docs/ideas.
# <skill-dir> is the directory that contains this SKILL.md
# (for example .agents/skills/idea-refine or .cursor/skills/idea-refine).
bash <skill-dir>/scripts/idea-refine.sh
```

## Ergebnis

Bei `$init` wird das konkretisierte Ergebnis in `.codex/PROJECT.md` gespeichert und an `$init` übergeben. Bei eigenständiger Nutzung kann auf Wunsch ein separates Dokument entstehen. Das Ergebnis enthält:
- Problembeschreibung
- Empfohlene Richtung
- Wesentliche Annahmen
- MVP-Umfang
- Liste der bewusst ausgeschlossenen Punkte

## Detaillierte Anweisungen

Unterstütze als Gesprächspartner dabei, rohe Ideen zu konkreten, umsetzbaren Konzepten zu schärfen.

### Grundsätze

- Strebe die einfachste Lösung an, die das tatsächliche Problem noch löst.
- Beginne mit der Nutzererfahrung und leite daraus die Technologie ab.
- Grenze den Umfang bewusst ein; Fokus geht vor Breite.
- Hinterfrage Annahmen. „So macht man es üblicherweise“ ist keine Begründung.
- Zeige neue Möglichkeiten auf, statt nur bestehende Lösungen geringfügig zu verbessern.
- Achte auch bei nicht sichtbaren Bestandteilen auf Qualität.

### Ablauf

Wenn der Nutzer diesen Skill mit einer Idee (`$ARGUMENTS`) aufruft, führe durch drei Phasen. Passe das Vorgehen an die Antworten an; es handelt sich um ein Gespräch und nicht um eine starre Vorlage.

#### Phase 1: Verstehen und erweitern (divergent)

**Ziel:** Die ursprüngliche Idee aufnehmen und ihren Lösungsraum öffnen.

1. **Formuliere die Idee erneut** als prägnante „Wie könnten wir …?“-Problemstellung. So wird klar, was tatsächlich gelöst werden soll.

2. **Stelle nur notwendige Fragen zur Schärfung**, jeweils eine pro Gesprächsrunde. Konzentriere dich auf offene Punkte, etwa:
   - Für wen genau ist die Idee gedacht?
   - Woran ist Erfolg erkennbar?
   - Welche tatsächlichen Grenzen bestehen bei Zeit, Technik und Ressourcen?
   - Was wurde bereits versucht?
   - Warum ist die Idee jetzt relevant?

   Fahre nicht fort, bevor Zielgruppe und Erfolgskriterien verstanden sind.

3. **Entwickle bei Bedarf geeignete Varianten** anhand dieser Perspektiven:
   - **Umkehrung:** „Was wäre, wenn wir das Gegenteil täten?“
   - **Grenzen aufheben:** „Was wäre ohne Einschränkungen bei Budget, Zeit oder Technik möglich?“
   - **Zielgruppe wechseln:** „Wie sähe es für [andere Nutzer] aus?“
   - **Kombination:** „Was wäre bei einer Verbindung mit [benachbarter Idee] möglich?“
   - **Vereinfachung:** „Wie sähe eine zehnmal einfachere Version aus?“
   - **Zehnfache Größenordnung:** „Wie sähe die Lösung in großem Maßstab aus?“
   - **Expertenperspektive:** „Was wäre Experten für [Fachgebiet] offensichtlich, Außenstehenden aber nicht?“

   Denke über den ursprünglichen Wunsch hinaus und prüfe mögliche neue Produktansätze.

**In einer bestehenden Codebasis:** Untersuche vorhandene Architektur, Muster und Vorgaben, soweit für die Idee angemessen. Prüfe eine vorhandene `.codex/PROJECT.md` vor Änderungen und kläre wesentliche Widersprüche, ohne bestehende Inhalte stillschweigend zu überschreiben. Während einer Projektinitialisierung übergib die abgestimmte Ausarbeitung an `$init`. Wird eine Feature-Idee in einem bestehenden Projekt durch `$spec-driven-development` koordiniert, übergib das Ergebnis zur Spec dorthin; initialisiere das Projekt nicht erneut. Bei eigenständiger Nutzung richte die Übergabe nach dem Auftrag.

Lies `frameworks.md` in diesem Skill-Verzeichnis für zusätzliche Methoden zur Ideenentwicklung. Wende sie gezielt an: Wähle eine zur Idee passende Perspektive und arbeite nicht alle Methoden mechanisch ab.

#### Phase 2: Bewerten und eingrenzen

Nachdem der Nutzer auf Phase 1 reagiert und etwa passende Ideen markiert, widerspricht oder Kontext ergänzt hat, wechsle zur Eingrenzung:

1. **Gruppiere** passende Ideen zu unterschiedlichen Richtungen, wenn sinnvolle Alternativen verbleiben. Jede Richtung soll sich wesentlich unterscheiden.

2. **Prüfe** jede Richtung kritisch anhand von drei Kriterien:
   - **Nutzerwert:** Wer profitiert und wie stark? Löst die Idee ein dringendes Problem oder bietet sie lediglich einen Zusatznutzen?
   - **Machbarkeit:** Welcher technische Aufwand und Ressourcenbedarf entstehen? Was ist besonders schwierig?
   - **Abgrenzung:** Was unterscheidet die Lösung? Würde jemand von seiner bisherigen Lösung wechseln?

   Lies `refinement-criteria.md` in diesem Skill-Verzeichnis für das vollständige Bewertungsraster.

3. **Lege verborgene Annahmen offen.** Nenne für jede Richtung ausdrücklich:
   - Was als wahr angenommen, aber noch nicht überprüft wird
   - Was die Idee scheitern lassen könnte
   - Was bewusst unbeachtet bleibt und warum dies vorerst vertretbar ist

   Überspringe diese Prüfung nicht.

**Sei ehrlich und respektvoll.** Benenne Schwächen einer Idee freundlich und konkret. Hinterfrage unnötige Komplexität und den tatsächlichen Nutzen, statt lediglich zuzustimmen.

#### Phase 3: Schärfen und übergeben

Erstelle ein konkretes Artefakt: eine Markdown-Kurzbeschreibung, die die Arbeit voranbringt:

```markdown
# [Idea Name]

## Problem Statement
[One-sentence "How Might We" framing]

## Recommended Direction
[The chosen direction and why — 2-3 paragraphs max]

## Key Assumptions to Validate
- [ ] [Assumption 1 — how to test it]
- [ ] [Assumption 2 — how to test it]
- [ ] [Assumption 3 — how to test it]

## MVP Scope
[The minimum version that tests the core assumption. What's in, what's out.]

## Not Doing (and Why)
- [Thing 1] — [reason]
- [Thing 2] — [reason]
- [Thing 3] — [reason]

## Open Questions
- [Question that needs answering before building]
```

**Die Liste ausgeschlossener Punkte ist besonders wertvoll.** Fokus bedeutet, auch gute Ideen zurückzustellen. Mache die Abwägungen ausdrücklich sichtbar.

Erstelle während `$init` nach der abgestimmten Ideenschärfung `.codex/PROJECT.md` und verweise darin auf `.codex/IDEA.md`. Bei einer bereits existierenden Projektdatei beachte die Abgleich- und Schutzregel oben. Ein zusätzlicher One-Pager unter `docs/ideas/[idea-name].md` ist nur bei entsprechendem Nutzerwunsch nötig; bestehende Dateien bleiben erhalten. Bei eigenständiger Nutzung kläre den Speicherort, wenn ein dauerhaftes Artefakt benötigt wird und der Ort unklar ist.

### Zu vermeidende Vorgehensweisen

- **Erzeuge nicht übermäßig viele Ideen.** Bevorzuge einige relevante Alternativen, wenn sie helfen; bewahre bereits getroffene Entscheidungen.
- **Stimme nicht unkritisch zu.** Hinterfrage schwache Ideen konkret und freundlich.
- **Übergehe die Zielgruppe nicht.** Jede gute Idee beginnt bei Menschen und ihrem Problem.
- **Erstelle keinen Plan, ohne Annahmen offenzulegen.** Ungeprüfte Annahmen können gute Ideen scheitern lassen.
- **Überfrachte den Prozess nicht.** Drei Phasen erfüllen jeweils eine Aufgabe; ergänze nicht unnötig Schritte.
- **Liste Ideen nicht nur auf.** Erkläre, warum jede Variante existiert.
- **Ignoriere die Codebasis nicht.** In bestehenden Projekten ist die Architektur zugleich Rahmenbedingung und Chance; berücksichtige sie.

### Ton

Direkt, überlegt und leicht provokativ. Sei ein mitdenkender Gesprächspartner statt einer Person, die ein Skript abliest. Hinterfrage konstruktiv und gehe einen Schritt weiter, ohne zu ermüden.

Lies `examples.md` in diesem Skill-Verzeichnis für Beispiele gelungener Ideenentwicklung.

## Häufige Ausreden

| Ausrede | Einordnung |
|---|---|
| Ich erzeuge über 20 Ideen, um alles abzudecken | Einige relevante Alternativen sind nützlicher als viele oberflächliche. |
| Der Nutzer braucht Zuspruch statt Kritik | Unkritische Zustimmung führt zu schwachen Ideen. Hinterfrage freundlich und konkret. |
| Die Zielgruppe ist bereits bekannt | Übernimm bekannte Zielgruppe und Problem; frage nur bei fehlender oder unklarer Antwort nach. |
| Annahmen klären wir erst bei der Umsetzung | Lege ungeprüfte Annahmen vor der Festlegung offen. |
| Ein Plan braucht keine Liste ausgeschlossener Punkte | Die Ausschlussliste verdeutlicht wichtige Abwägungen. |

## Warnzeichen

- Viele oberflächliche Varianten statt nützlicher Alternativen erzeugen
- Ohne Verständnis von Zielgruppe und Problem fortfahren; wiederhole keine klar beantwortete Frage
- Vor der Richtungsentscheidung keine Annahmen offenlegen
- Schwachen Ideen zustimmen, statt sie konkret zu hinterfragen
- Einen Plan ohne Liste ausgeschlossener Punkte erstellen
- Rahmenbedingungen der bestehenden Codebasis bei der Ideenentwicklung ignorieren
- Direkt das Ergebnis von Phase 3 erstellen, ohne Phase 1 und 2 zu durchlaufen

## Verifikation

Nach Abschluss der Ideenentwicklung:

- [ ] Eine klare „Wie könnten wir …?“-Problemstellung liegt vor
- [ ] Zielnutzer und Erfolgskriterien sind definiert
- [ ] Relevante Alternativen wurden, wo hilfreich, betrachtet, ohne geklärte Entscheidungen erneut zu öffnen
- [ ] Verborgene Annahmen und Strategien zu ihrer Überprüfung sind ausdrücklich aufgeführt
- [ ] Eine Liste ausgeschlossener Punkte macht Abwägungen sichtbar
- [ ] Bei Initialisierung liegt die abgestimmte Ausarbeitung in `.codex/PROJECT.md` mit Bezug auf die erhaltene `.codex/IDEA.md` vor; andernfalls erfolgt die Übergabe am vereinbarten Ort
- [ ] Der Nutzer hat die endgültige Richtung vor Beginn der Implementierung bestätigt
