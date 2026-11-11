---
name: implementation-review
description: Setzt einen abgestimmten Spec-Driven-Plan um oder prüft das Ergebnis kriteriumsbezogen und berichtet belegte Verifikation und offene Punkte.
---

# Implementation and Review

Nutze diesen Skill, wenn ein Spec-Driven-Plan umgesetzt oder eine Umsetzung anhand ihrer Spec geprüft werden soll.

1. Lies Projektanweisungen, Spec, Plan, `.codex/rules/WORKFLOW.md` und `.codex/rules/RULES.md`. Bei nativen Apple-Apps oder Web-Apps berücksichtige zusätzlich `.codex/rules/ARCHITECTURE.md`.
2. Setze die geplanten Änderungen inkrementell um und folge den bestehenden Mustern im Repository.
3. Prüfe bei jedem Schritt die betroffenen Kriterien. Wenn die Lösung eine Änderung der Spec oder des Plans erfordert, aktualisiere das Artefakt und nenne den Grund.
4. Führe passende Verifikationsschritte aus, sofern sie zum Auftrag gehören oder zur belastbaren Beurteilung nötig sind. Unterscheide ausgeführte Checks von empfohlenen, nicht ausgeführten Checks.
5. Prüfe neben den Spec-Kriterien die passenden Plattformchecks aus `.codex/rules/ARCHITECTURE.md`. Weise nicht ausgeführte Checks und bekannte Einschränkungen ausdrücklich aus.
6. Berichte Abweichungen, Risiken und nicht erfüllte Kriterien. Nutze `.codex/rules/templates/VERIFICATION.md`, wenn ein dauerhafter Nachweis sinnvoll ist.
7. Bei UI-Änderungen nutze `$frontend-design-accessibility` für die Qualitätsprüfung und `$ui-verification` für die plattformgerechte Auswahl und Dokumentation von Checks.
8. Bei Änderungen an personenbezogener Datenverarbeitung nutze `$dsgvo-datenschutz`, um Datenschutzkriterien, Datenzugriffe, Löschung und ausgewiesene offene Entscheidungen zu prüfen.

Ergebnis: Implementierung beziehungsweise Review mit nachvollziehbarem Status pro Abnahmekriterium.
