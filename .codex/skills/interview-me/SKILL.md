---
name: interview-me
description: Ermittelt durch einzelne Fragen, was der Nutzer tatsächlich erreichen möchte, bis die zugrunde liegende Absicht mit etwa 95 % Sicherheit verstanden ist. Nutze den Skill bei unklaren Anforderungen, ausdrücklicher Bitte um ein Interview oder wenn vor Planung, Spec oder Code unbemerkte Annahmen getroffen werden.
---

# Interview Me

## Überblick

Was Menschen anfragen und was sie tatsächlich wollen, kann auseinanderfallen. Sie wünschen sich etwa ein Dashboard, weil es naheliegt, nicht weil es ihr Problem löst. Oder sie sagen „mach es schneller“, ohne ein Ziel zu nennen.

Diese Lücke lässt sich am einfachsten erkennen, bevor Plan, Spec oder Code existieren. Nach Beginn der Umsetzung verursachen Änderungen Aufwand und eine ungeeignete Lösung kann als „gut genug“ akzeptiert und damit festgeschrieben werden.

Dieser Skill klärt die Lücke frühzeitig. Andere Skills der Definitionsphase setzen voraus, dass das Ziel ungefähr bekannt ist: `idea-refine` entwickelt Varianten, `spec-driven-development` dokumentiert Anforderungen und `doubt-driven-development` prüft einen entworfenen Plan kritisch. Interview-me setzt davor an: Stelle jeweils eine Frage mit deiner begründeten Vermutung, bis du die Antwort des Nutzers vorhersehen kannst.

## Wann verwenden

Bei der Projektinitialisierung ist `$init` der Einstiegspunkt und koordiniert dieses Interview nur, wenn Absicht oder wesentliche Anforderungen noch unklar sind. Berücksichtige die ursprüngliche `.codex/IDEA.md`, eine vorhandene `.codex/PROJECT.md` und bereits im Gespräch genannte Informationen. Stelle jeweils eine Frage und wiederhole keine geklärten Entscheidungen. Gib die geklärte Absicht an `$init` zurück; dieser koordiniert `$idea-refine`, sofern die Schärfung noch nicht abgeschlossen ist.

Nutze diesen Skill, wenn:

- Mindestens eine Angabe fehlt: **wer** der Nutzer ist, **warum** er das Ziel verfolgt, woran **Erfolg** erkennbar ist oder welche **Einschränkung** bindend ist
- Die Anfrage allgemein statt konkret ist und sich ohne Vermutungen nicht auflösen lässt
- Du mit unausgesprochenen Annahmen beginnen würdest
- Unklar ist, welcher Wert bei Zielkonflikten Vorrang hat, etwa Einfachheit oder Flexibilität beziehungsweise Kosten oder Geschwindigkeit
- Der Nutzer ausdrücklich um ein Interview oder eine kritische Prüfung seiner Überlegungen bittet

**Nicht verwenden, wenn:**

- Die Anfrage eindeutig und in sich abgeschlossen ist, etwa eine Variable umzubenennen oder einen Tippfehler zu korrigieren
- Der Nutzer ausdrücklich Geschwindigkeit gegenüber Überprüfung bevorzugt
- Es sich um eine reine Informationsfrage handelt
- Mechanische Arbeiten wie Umbenennen, Formatieren oder Verschieben anstehen
- Deine Sicherheit bereits ≥95 % beträgt; lies die Abbruchbedingung, bevor du das Gegenteil annimmst

## Voraussetzungen

Dieser Skill setzt einen ansprechbaren Nutzer voraus. **Verwende ihn nicht in nicht interaktiven Kontexten** wie CI-Pipelines, geplanten Ausführungen, `/loop` oder autonomous-loop. Melde unzureichende Anforderungen dort als Hindernis, statt zu raten.

## Vorgehen

### Schritt 1: Hypothese und Sicherheit formulieren

Halte vor der ersten Frage dein derzeit bestes Verständnis der Nutzerabsicht in **einem Satz** und einen ehrlichen Sicherheitswert von 0–100 % fest:

```
HYPOTHESIS: You want a way to answer "how are we doing?" in standup, and "dashboard" was the convention that came to mind.
CONFIDENCE: ~30% — missing: who it's for, what "metrics" means in context, and what success looks like
```

Der Wert fordert eine ehrliche Einschätzung. Wenn du einen hohen Wert angibst, aber die Reaktionen auf deine nächsten drei Fragen nicht vorhersagen kannst, ist er falsch. Beginne mit einem Wert, den du begründen kannst.

Liegt die Sicherheit unter etwa 70 %, ergänze in derselben Zeile kurz, was noch ungeklärt ist oder fehlt. So erkennt der Nutzer, was das Interview klären muss.

### Schritt 2: Jeweils eine Frage mit Vermutung stellen

Format:

```
Q: <one focused question>
GUESS: <your hypothesis for the answer, with the reasoning that produced it>
```

Warte auf die Reaktion des Nutzers, bevor du die nächste Frage stellst.

**Warum jeweils eine Frage:**

- In einer langen Liste kann der Nutzer schlechter auf deine Hypothesen reagieren
- Mehrere Fragen zugleich begünstigen oberflächliche Antworten
- Spätere Fragen hängen oft von früheren Antworten ab
- Die Aufmerksamkeit des Nutzers ist begrenzt; nutze sie für jeweils eine Frage

**Warum eine Vermutung ergänzen:**

- Auf eine falsche Vermutung kann der Nutzer schneller reagieren als eine Antwort neu formulieren
- Eine überprüfbare Hypothese macht mögliche Fehler sichtbar
- Sie legt *deine* Annahmen offen

Ein höflicher Nutzer könnte deiner Vermutung lediglich aus Zustimmung folgen. Zeige daher, dass du Irrtümer akzeptierst, und formuliere gelegentlich Vermutungen, denen der Nutzer voraussichtlich widerspricht.

### Schritt 3: Tatsächliche Wünsche von vermeintlichen Erwartungen unterscheiden

Achte auf Antworten, die eher durch Konventionen als durch die tatsächlichen Wünsche des Nutzers geprägt sind:

- Allgemeine Best-Practice-Aussagen ohne konkrete Bedeutung
- Verweise auf Konventionen wie „so machen es die meisten Apps“
- Formulierungen wie „ich sollte vermutlich …“ oder „gute Entwicklungspraxis verlangt …“
- Schlagwörter wie „modern“, „skalierbar“ oder „robust“ anstelle konkreter Ergebnisse

Frage in solchen Fällen:

> *„Was würdest du tatsächlich wollen, wenn du es niemandem gegenüber begründen müsstest?“*

Diese Frage kann das eigentliche Ziel sichtbar machen.

### Schritt 4: Absicht in den Worten des Nutzers wiedergeben

Fasse bei hoher Sicherheit knapp in fünf bis acht Zeilen zusammen, was der Nutzer nach deinem Verständnis möchte. Verwende möglichst seine Worte und ermögliche eine zeilenweise Bestätigung oder Korrektur:

```
Here's what I now think you want:

- Outcome:      <one line>
- User:         <one line — who benefits>
- Why now:      <one line — what changed>
- Success:      <one line — how we know it worked>
- Constraint:   <one line — the binding limit>
- Out of scope: <one line — what we're explicitly not doing>

Yes / no / refine?
```

Der Punkt „Out of scope“ ist verpflichtend, damit auch die ausdrücklich ausgeschlossenen Ziele nachvollziehbar sind.

### Step 5: Bestätigung der Absicht

Stelle das konkrete Verständnis vor und akzeptiere eine im Kontext klare Bestätigung oder Korrektur; verlange keine bestimmte Formulierung. Schweigen allein ist keine Bestätigung. Nutze die erteilte Autorisierung, wenn der Nutzer eine Routineentscheidung delegiert, statt erneut zu fragen. Kläre nur wesentliche offene Entscheidungen und berücksichtige Korrekturen vor der Übergabe.

### Step 6: Übergabe nach bestätigter Absicht

Wenn der Nutzer die Absichtserklärung im Kontext klar bestätigt:

1. **Gib die bestätigte Absichtserklärung aus.**
2. Gib während `$init` die bestätigte Absicht zurück; verwende `$idea-refine` nur, wenn die Schärfung noch nicht abgeschlossen ist. Beachte ausdrückliche Stoppwünsche und offene Entscheidungen und wiederhole keine bestätigten Antworten.
3. Befolge bei eigenständigem Aufruf die bestehenden Nutzeranweisungen für den nächsten Schritt; frage nur bei unklarer nächster Handlung oder wesentlicher Entscheidung nach.

### Abbruch bei 95 % Sicherheit

Das Interview ist beendet, wenn du diese Frage bejahen kannst:

> *Kann ich die Reaktion des Nutzers auf meine nächsten drei Fragen vorhersagen?*

Wenn ja, besteht ein gemeinsames Verständnis. Beende das Interview und formuliere die Zusammenfassung. Wenn nein, stelle die nächste Frage.

Dies ist eine überprüfbare Bedingung. Wenn du die Reaktionen nach mehreren Runden noch immer nicht vorhersagen kannst, stoppe und erkläre dem Nutzer, dass eine grundlegende Information fehlt; schlage vor, gemeinsam einen Schritt zurückzugehen.

## Ergebnis

Das Ergebnis ist eine **bestätigte Absichtserklärung**: die im Kontext klar bestätigte oder korrigierte Zusammenfassung aus Schritt 4. Specs, Pläne und Aufgabenlisten bauen anschließend darauf auf.

Wenn der Nutzer die Absicht dauerhaft festhalten möchte, etwa für mehrere Sitzungen oder eine Übergabe, biete das Speichern unter `docs/intent/[topic].md` an. Speichere nur nach seiner Bestätigung.

## Beispiel

Ein kurzer Vergleich:

**Ohne `interview-me`:**

```
User:  build me a dashboard for our metrics
Agent: <starts proposing chart libraries and layouts>
```

Der Agent nimmt Zielgruppe, Kennzahlen, Bedeutung von „unser Team“ und Erfolgskriterien an, obwohl diese nicht genannt wurden. Jede Annahme kann am Bedarf vorbeigehen.

**Mit `interview-me`:**

```
User: build me a dashboard for our metrics

Agent:
HYPOTHESIS: You want a way to answer "how are we doing?" in standup, and "dashboard" came to mind because that's the conventional answer.
CONFIDENCE: ~30% — missing: who it's for, what "metrics" are, and what success looks like

Q:     When you say "how are we doing?", who's asking — you alone, the engineering team in standup, or up the chain (e.g., your manager, an exec, a board)?
GUESS: engineering team in standup, because "we" usually scopes that way and standups are where this question gets asked. If it's for execs the metrics and the framing change a lot.

User: It's actually for me. I keep losing track of which experiments are running and what their early signal looks like.

Agent:
Updated read: not a team dashboard at all. It's a personal experiment tracker. Confidence: ~60% — still missing: what "early signal" means and what done looks like.

Q:     Is the gap that you don't know which experiments exist, or that you can't see their results in one place?
GUESS: the second one. You have a list of experiments somewhere, but their results live in five different tools, and reconciling them by hand is what you're tired of.

User: First one actually. I literally don't have a list. They're spread across different docs.

Agent: <continues>
```

Nach zwei Fragen zeigt sich, dass eigentlich eine Liste benötigt wird. Ein Dashboard hätte einen anderen Umfang und wäre am Bedarf vorbeigegangen.

## Zusammenspiel mit anderen Skills

- **`init` / `idea-refine`**: Bei der Initialisierung koordiniert `$init` ein optionales Interview und nur bei noch ausstehender Schärfung `$idea-refine`, das `.codex/IDEA.md` zu `.codex/PROJECT.md` ausarbeitet.
- **`spec-driven-development`**: Übergib eine konkrete, bestätigte Absicht zur Dokumentation an `spec-driven-development`.
- **`feature-planning` / `planning-and-task-breakdown`**: Nach der Spec führt `$feature-planning` die Planung; nutze `$planning-and-task-breakdown`, wenn eine detaillierte Zerlegung im selben maßgeblichen Plan hilfreich ist.
- **`doubt-driven-development`**: Interview-me klärt die Absicht vor Entscheidungen; doubt-driven prüft Ergebnisse nach Entscheidungen kritisch.
- **`source-driven-development`**: Interview-me klärt Nutzerwünsche; SDD überprüft Fakten zu Frameworks.

## Häufige Ausreden

| Ausrede | Tatsächliche Einordnung |
|---|---|
| „Die Anfrage ist klar genug.“ | Kannst du das gewünschte Ergebnis nicht in einem Satz ausdrücken, ist es noch unklar. Führe vor der Entscheidung Schritt 1 aus. |
| „Zu viele Fragen verschwenden Zeit.“ | Vier bis sechs gezielte Fragen kosten weniger Zeit als eine falsche Umsetzung. |
| „Das finde ich während der Umsetzung heraus.“ | Änderungen an vorhandenem Code verursachen mehr Aufwand; späte Klärung führt zu Nacharbeit. |
| „Der Nutzer überlässt mir die Entscheidung.“ | Respektiere delegierte Routineentscheidungen und kläre nur wesentliche offene Entscheidungen. |
| „Ich sollte mehrere Optionen anbieten.“ | Optionen helfen bei bekannten Zielen und Abwägungen; Fragen grenzen unklare Ziele ein. |
| „Meine Vermutung beeinflusst den Nutzer.“ | Eine Vermutung erleichtert die Reaktion; zeige ausdrücklich, dass du dich irren kannst. |
| „Wir haben genug gesprochen, ich verstehe es.“ | Prüfe, ob du die Reaktionen auf die nächsten drei Fragen vorhersagen kannst. |
| „Der Nutzer hat bestätigt, wir sind fertig.“ | Prüfe, ob die Absicht konkret und die Bestätigung im Kontext klar ist; verlange keine bestimmte Formulierung. |

## Warnzeichen

- Drei oder mehr Fragen in einer Nachricht
- Eine Frage ohne eigene Hypothese
- Eine unklare Antwort als Bestätigung einer wesentlichen offenen Entscheidung behandeln
- Vor ausdrücklicher Bestätigung der Zusammenfassung eine Spec, einen Plan oder eine Aufgabenliste erstellen
- Bestätigte Fragen erneut öffnen oder trotz wesentlicher offener Entscheidung beziehungsweise ausdrücklichem Stoppwunsch fortfahren
- Nach Best Practices statt nach dem tatsächlichen Wunsch fragen
- Schlagwörter wie „skalierbar“, „sauber“ oder „modern“ ohne Nachfrage akzeptieren
- Drei oder mehr Runden ohne steigende Sicherheit: Gehe einen Schritt zurück und formuliere neu
- Weniger als etwa 70 % Sicherheit ohne Begründung
- Das Absichtsdokument vor Bestätigung durch den Nutzer speichern
- Den Punkt „Out of scope“ in der Zusammenfassung auslassen

## Überprüfung

Nach Anwendung von interview-me:

- [ ] Im ersten Beitrag wurde eine ausdrückliche Hypothese mit Sicherheitswert genannt
- [ ] Für jeden Wert unter etwa 70 % wurde in einer Zeile genannt, was fehlt oder unklar ist
- [ ] Fragen wurden einzeln und jeweils mit einer Vermutung gestellt
- [ ] Bei konventionsbezogenen oder vagen Antworten wurde mindestens einmal nach dem tatsächlichen Wunsch gefragt
- [ ] Eine konkrete Zusammenfassung mit Ergebnis, Nutzer, Anlass, Erfolg, Einschränkung und Ausschlüssen wurde vorgelegt
- [ ] Der Nutzer hat die Absicht im Kontext klar bestätigt oder korrigiert
- [ ] Beim Abschluss konnte der Agent die Reaktionen auf die nächsten drei Fragen vorhersagen
- [ ] Die bestätigte Absicht wurde ohne Wiederholung geklärter Fragen an `$init` oder den nächsten autorisierten Schritt übergeben
- [ ] Eine Übergabe an nachgelagerte Skills (`idea-refine`, `spec-driven-development`) bezieht sich auf die bestätigte Absicht
