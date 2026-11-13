# Skill-Auswahl

Wähle Skills anhand von Auftrag, Projektzustand und Plattform. Lies die jeweiligen Skill-Anweisungen und beachte bestehende Projektkonventionen. Die Übersicht ist eine Orientierung, keine Pflicht, alle aufgeführten Skills nacheinander auszuführen.

## Einstieg

- **Neues Projekt oder noch unklare Produktidee:** `$init` koordiniert den Einstieg. Es nutzt `$interview-me` und `$idea-refine` nur bei Bedarf, erhält `.codex/IDEA.md` und übernimmt bereits abgeschlossene Ideenschärfung ohne Wiederholung.
- **Bestehendes Projekt mit konkreter Funktion:** Beginne bei mehrteiligen oder unklaren Anforderungen mit `$spec-driven-development`, danach bei Bedarf mit `$feature-planning` und `$planning-and-task-breakdown`. Eine erneute Projektinitialisierung ist nicht erforderlich.
- **Fehler, Review oder andere konkrete Aufgabe:** Wähle den passenden Skill direkt, beispielsweise `$debugging-and-error-recovery` oder `$code-review-and-quality`.

## Auswahl nach Aufgabe

| Aufgabe | Passende Skills |
| --- | --- |
| Qualitätsziele festlegen | `$constraint-driven-development`, wenn benötigt und noch nicht vereinbart |
| Kontext und belastbare Quellen | `$context-engineering`, `$source-driven-development` |
| Inkrementelle Umsetzung | `$incremental-implementation`, `$implementation-review` |
| Web-Oberfläche | `$app-dev-nextjs` oder `$app-dev-angular`; bei Bedarf `$frontend-ui-engineering` und `$frontend-design-accessibility` |
| Native Apple-Oberfläche | `$app-dev-swiftui`, `$frontend-design-accessibility` und bei iOS/iPadOS `$native-ios-design`; für macOS nur dessen passende plattformübergreifende Hinweise |
| Backend und Schnittstellen | `$api-and-interface-design` und je nach vereinbarter Architektur `$backend-dev-supabase`, `$backend-dev-nestjs-postgres`, `$backend-dev-csharp-sqlserver` oder `$backend-dev-sqlite-data` |
| Tests und Prüfung | `$test-driven-development` für passende Verhaltensänderungen; `$verify-ui` für plattformbezogene UI-Prüfung. `$browser-testing-with-devtools` gilt für Web-Inhalte und setzt einen verfügbaren Server voraus. Native iOS-/iPadOS-Apps mit Simulator oder Gerät, macOS-Apps in der nativen Testumgebung prüfen. |
| Sicherheit, Datenschutz und Leistung | Bei Bedarf `$security-and-hardening`, `$dsgvo` oder `$performance-optimization` |
| Überprüfung und Vereinfachung | `$code-review-and-quality`, bei Bedarf `$doubt-driven-development` oder `$code-simplification` |
| Git und Versionierung | `$git-workflow-and-versioning` für Git-Bootstrap, sicheres Staging, Commits, Branches, Historie, Pull Requests und Versionierung. Projektkonventionen, vorhandene Änderungen und Autorisierung beachten. |
| Auslieferung und Betrieb | Nach Bedarf `$ci-cd-and-automation`, `$observability-and-instrumentation`, `$documentation-and-adrs`, `$deprecation-and-migration`, `$shipping-and-launch` oder `$deploy` |

## Arbeitsweise

- Trenne belegte Fakten, Entscheidungen und Annahmen. Kläre wesentliche Unklarheiten; bei geringfügigen Lücken arbeite mit nachvollziehbar benannten Annahmen weiter.
- Halte den vereinbarten Umfang ein und weise auf relevante Risiken und Zielkonflikte hin.
- Wähle Verifikation passend zu Änderung, Projekt und verfügbaren Werkzeugen. Berichte Ergebnisse und nicht ausgeführte Prüfungen; behaupte keine unbelegte Verifikation. Beachte die anwendbaren Punkte der `.codex/ai-engineering/references/definition-of-done.md`.
- Berücksichtige `.codex/rules/WORKFLOW.md`, `.codex/rules/DELEGATION.md` und die Projektanweisungen. Skills begründen keine zusätzliche Berechtigung für externe oder destruktive Aktionen.
