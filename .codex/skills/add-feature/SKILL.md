---
name: add-feature
description: Schärft eine neue Feature-Idee für ein bestehendes Projekt im Dialog mit idea-refine und gleicht sie mit Projektzielen und bestehenden Entscheidungen ab.
---

# Add Feature

Nutze diesen Einstieg, wenn ein neues Feature für ein bestehendes Projekt beschrieben und vor der Planung konkretisiert werden soll. Beachte Projektanweisungen und die Sprache des Projekts.

1. Frage zu Beginn nach einer Beschreibung des gewünschten Features, falls sie im Auftrag oder Gespräch noch nicht vorliegt. Übernimm bereits genannte Angaben und frage sie nicht erneut ab. Stelle pro Gesprächsrunde genau eine Frage und warte auf die Antwort.
2. Lies `.codex/PROJECT.md` als Kontext für Projektidee, Zielgruppe, Ziele und bereits getroffene Entscheidungen. Berücksichtige bei Bedarf vorhandene Produktunterlagen, Feature-Übersicht, Architektur und relevante Teile der Codebasis. Unterscheide dokumentierte Fakten von Annahmen. Fehlt eine aussagekräftige Projektbeschreibung, teile das mit und kläre nur den für das Feature notwendigen Kontext; initialisiere das Projekt nicht erneut.
3. Nutze `$idea-refine` für die **Feature-Idee** im bestehenden Projekt: Formuliere Problem und Nutzen, kläre Zielgruppe und Erfolg, untersuche bei Bedarf sinnvolle Alternativen und benenne Annahmen sowie deren Überprüfung. Übernimm geklärte Projektentscheidungen und führe keine erneute Projekt-Ideenschärfung durch.
4. Prüfe die konkretisierte Idee auf innere Widersprüche und auf Konflikte mit Projektzielen, bestehenden Funktionen, dokumentierten Entscheidungen und relevanten technischen Grenzen. Nenne für jeden wesentlichen Konflikt die Grundlage, die Auswirkung und mögliche Lösungen. Kläre offene Zielkonflikte mit dem Nutzer, eine Frage pro Runde; behaupte keine Prüfung von Unterlagen, die nicht vorliegen.
5. Fasse die abgestimmte Richtung als kompakten Feature-One-Pager zusammen: Problem und Zielgruppe, gewünschter Nutzen und Erfolg, empfohlene Lösung, Umfang und bewusst Ausgeschlossenes, Annahmen und Validierung sowie verbleibende offene Fragen oder Konflikte. Bitte um Bestätigung der Richtung, bevor Umsetzung beginnt. Bewahre `.codex/PROJECT.md` und andere bestehende Unterlagen; ändere sie nicht stillschweigend. Ein dauerhaftes Feature-Dokument entsteht nach Projektkonvention oder auf Wunsch des Nutzers.
6. Übergib das bestätigte Ergebnis für mehrteilige oder unklare Anforderungen an `$spec-driven-development` und bei Bedarf `$feature-planning`. Fahre nur im Rahmen des erteilten Auftrags mit Planung oder Umsetzung fort; bestätigte Antworten und Entscheidungen werden dabei nicht erneut erfragt.
