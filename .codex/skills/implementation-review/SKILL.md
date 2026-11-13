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
7. Bei UI-Änderungen nutze `$frontend-design-accessibility` für die Qualitätsprüfung und `$verify-ui` für die plattformgerechte Auswahl und Dokumentation von Checks. Ziehe bei SwiftUI auf iOS und iPadOS zusätzlich `$native-ios-design` heran; wende bei macOS nur dessen plattformübergreifend geeignete Hinweise entsprechend den Projektkonventionen und unterstützten Betriebssystemversionen an.
8. Bei Änderungen an personenbezogener Datenverarbeitung nutze `$dsgvo`, um Datenschutzkriterien, Datenzugriffe, Löschung und ausgewiesene offene Entscheidungen zu prüfen.
9. Bei Release- oder Deployment-Arbeiten nutze `$deploy` für Preflight, autorisierte Veröffentlichung und Nachkontrolle.
10. Bei Supabase-Änderungen nutze `$backend-dev-supabase`, um Migrationen, Grants/RLS, Auth, Storage oder Edge Functions entsprechend dem betroffenen Umfang zu prüfen.
11. Bei NestJS-/PostgreSQL-Änderungen nutze `$backend-dev-nestjs-postgres`, um API-Sicherheit, Schema/Migrationen, Authentifizierung/Autorisierung und die Umsetzung der Swagger-Entscheidung zu prüfen; prüfe bereitgestellte UI und Dokument auf Schutz.
12. Bei C#-/ASP.NET-Core- und SQL-Server-Änderungen nutze `$backend-dev-csharp-sqlserver`, um API-Sicherheit, Migrationen, SQL-Zugriff, die Swagger-Entscheidung und das gewählte Hosting zu prüfen; prüfe bereitgestellte UI und Dokument auf Schutz.
13. Bei SQLite-Änderungen nutze `$backend-dev-sqlite-data`, um Migrationen, lokale/serverseitige/browserbasierte Speicherung, Persistenz und gegebenenfalls Offline-Synchronisierung und Konflikte zu prüfen.
14. Wenn die Umsetzung von lokaler Laufzeit, CLI, Konfiguration oder Umgebungsvariablen abhängt, nutze `$verify-setup` für die Readiness-Prüfung, ohne geheime Werte offenzulegen.
15. Wenn die Aufgabe einen Commit umfasst oder ein abgeschlossener, geprüfter Arbeitsschritt committet werden soll, nutze `$git-workflow-and-versioning` für Staging, Diff-Prüfung und Commit.

Ergebnis: Implementierung beziehungsweise Review mit nachvollziehbarem Status pro Abnahmekriterium.
