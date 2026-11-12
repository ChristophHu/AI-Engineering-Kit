---
name: feature-planning
description: Übersetzt eine abgestimmte Spec in einen umsetzbaren, kriteriumsbezogenen Plan unter Berücksichtigung der vorhandenen Codebasis.
---

# Feature Planning

Nutze diesen Skill, wenn eine Spec in konkrete Umsetzungsschritte überführt werden soll.

1. Lies Projektanweisungen, die Spec, `.codex/rules/WORKFLOW.md` und `.codex/rules/RULES.md`. Bei nativen Apple-Apps oder Web-Apps berücksichtige zusätzlich `.codex/rules/ARCHITECTURE.md`.
2. Prüfe die relevanten Module, Tests, Architektur und vorhandenen Konventionen. Stütze Datei- und Technikvorschläge auf diese Prüfung.
3. Zerlege die Arbeit in kleine Schritte mit klaren Ergebnissen. Verknüpfe jeden Schritt mit Spec-Kriterien und geeigneter Verifikation.
4. Notiere Abhängigkeiten, Risiken und noch offene Entscheidungen. Schlage keine unnötige Generalisierung vor.
5. Nutze `.codex/rules/templates/PLAN.md`, wenn das Projekt keine eigene Planstruktur hat.
6. Bei nativen Apple-Apps und Web-Apps plane die zutreffenden technischen Entscheidungen und Plattformchecks aus `.codex/rules/ARCHITECTURE.md` ein.
7. Gib die Umsetzung erst frei, wenn die Startkriterien aus `.codex/rules/ARCHITECTURE.md` erfüllt oder begründet als Annahmen dokumentiert sind.
8. Prüfe rückwärts, ob alle Abnahmekriterien durch mindestens einen Schritt und einen Nachweis abgedeckt sind.
9. Richte plattformspezifische Planung an `$app-dev-swiftui`, `$app-dev-nextjs` oder `$app-dev-angular` aus. Die Skills identifizieren zuerst Version, Zielplattform und vorhandene Muster; sie geben kein neues Architekturmodell vor.
10. Wenn die Änderung personenbezogene Daten betrifft, berücksichtige `$dsgvo` für Datenflüsse, Zugriff, Aufbewahrung/Löschung und offene rechtliche oder organisatorische Entscheidungen.
11. Bei Release- oder Deployment-Arbeiten plane nach `$deploy`; erkenne dafür zuerst bestehende Umgebung, Provider, CI/CD und Rollback-Möglichkeiten.
12. Bei Supabase-Änderungen plane Datenmodell, Schema-Workflow, RLS/Grants und geeignete Datenbankchecks mit `$backend-dev-supabase`.
13. Bei NestJS-/PostgreSQL-Änderungen plane API-Module, Validierung, Authentifizierung/Autorisierung, Datenbankschema und Migrationen, Geheimnisverwaltung sowie die geschützte Swagger UI mit `$backend-nestjs-postgres-development`.
14. Bei C#-/ASP.NET-Core- und SQL-Server-Änderungen plane API-Struktur, Authentifizierung/Autorisierung, Datenzugriff und Migrationen, geschützte Swagger/OpenAPI-Endpunkte sowie den Windows-Server-/IIS-Betrieb mit `$backend-dev-csharp-sqlserver`.
15. Bei SQLite-Änderungen plane Datenbankort, Schema-/Migrationsworkflow, Haltbarkeit, konkurrierende Schreibzugriffe und — falls offlinefähig oder backendgekoppelt — Sync-Vertrag und Konfliktverhalten mit `$backend-sqlite-data-development`.
16. Wenn lokale Laufzeit, CLI, Konfiguration oder Zielumgebung Voraussetzung sind, plane einen Setup-Readiness-Check mit `$verify-setup` ein.

Ergebnis: ein ausführbarer Plan, der die Spec abdeckt und die Verifikation mitplant.
