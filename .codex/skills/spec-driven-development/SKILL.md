---
name: spec-driven-development
description: Klärt und dokumentiert Anforderungen als überprüfbare Spec, bevor mehrteilige oder unklare Änderungen geplant und umgesetzt werden.
---

# Spec-Driven Development

Nutze diesen Skill, wenn eine Aufgabe mehrere Komponenten betrifft, Anforderungen unklar sind oder eine nachvollziehbare Spec gebraucht wird. Bei einer kleinen eindeutigen Änderung genügt eine kompakte Spec in der Antwort.

Wenn es um eine neue oder noch vage Produktidee geht, beginne zuerst mit `$init`, um Produktvision und priorisierte Feature-Map abzustimmen. Nutze diesen Skill anschließend für eine konkrete Funktion oder einen priorisierten Umsetzungsschritt.

1. Lies `.codex/rules/WORKFLOW.md`, `.codex/rules/RULES.md` und passende Projektanweisungen. Bei nativen Apple-Apps oder Web-Apps berücksichtige zusätzlich `.codex/rules/ARCHITECTURE.md`.
2. Untersuche relevante vorhandene Dateien und Konventionen, bevor du Anforderungen festschreibst.
3. Bei App-Arbeiten erfasse in der Spec: Problem und Nutzen (für wen, wozu), Ziel und Plattform (Geräte und Versionen), Nutzerablauf und Verhalten ab Startzustand, Umfang (In/Out), beobachtbare Abnahmekriterien sowie relevante Rahmenbedingungen zu Accessibility, Datenschutz, Berechtigungen, Daten und Integrationen. Markiere offene Fragen und Annahmen samt Auswirkungen; kennzeichne nicht relevante Punkte ausdrücklich.
4. Nutze `.codex/rules/templates/SPEC.md` als Vorlage, sofern das Projekt keine eigene Spec-Vorlage nutzt.
5. Löse wesentliche Mehrdeutigkeiten mit gezielten Fragen. Für unwesentliche Lücken triff eine begründete, sichtbare Annahme und arbeite weiter.
6. Bei nativen Apple-Apps und Web-Apps erfasse die relevanten Spec-Vorgaben aus `.codex/rules/ARCHITECTURE.md`: Plattform und Nutzer, Abläufe und Zustände, Berechtigungen, Datenverarbeitung, Integrationen, Accessibility und Qualitätsziele.
7. Prüfe, dass Kriterien beobachtbar und überprüfbar sind und die Spec das gewünschte Verhalten beschreibt. Halte technische Lösungsvorschläge getrennt, sofern sie nicht durch Constraints vorgegeben sind.
8. Bestimme nach Plattform und Stack, welche Entwicklungs-Skills für Planung und Umsetzung passen: `$swiftui-app-development`, `$nextjs-app-development` oder `$angular-app-development`. Bei UI-Arbeit kann `$frontend-design-accessibility` ergänzen; für UI- und Plattformverifikation nutze `$ui-verification`.
9. Wenn die Aufgabe personenbezogene Daten verarbeitet, nutze `$dsgvo`, um Datenflüsse, offene Datenschutzentscheidungen, technische Maßnahmen und passende Verifikation in Spec und Plan einzubeziehen.
10. Wenn Supabase Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$supabase-backend-development` für Datenmodell, Migrationen, Zugriffsschutz und Backend-Verifikation heran.
11. Wenn NestJS mit PostgreSQL Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$nestjs-postgres-backend-development` für API, Datenmodell, Migrationen, Zugriffsschutz, geschützte Swagger UI und Backend-Verifikation heran.
12. Wenn ein C#-/ASP.NET-Core-Backend mit Microsoft SQL Server Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$csharp-sqlserver-backend-development` für API, SQL-Server-Schema/Migrationen, Zugriffsschutz, geschützte Swagger/OpenAPI-Endpunkte und Backend-Verifikation heran.
13. Wenn SQLite in einer App, im Backend oder im Browser eingesetzt wird, ziehe `$sqlite-data-development` für Speicherort, Datenhoheit, Migrationen, Offline-Verhalten und Synchronisierung heran.
14. Wenn die Umsetzung von lokaler Laufzeit, CLI, Konfiguration oder Zielumgebung abhängt, nutze `$verify-setup` für eine sichere Readiness-Prüfung.

Ergebnis: eine überprüfbare Spec und klar markierte offene Punkte. Beginne Implementierung erst, wenn sie zum Auftrag passt und notwendige Entscheidungen geklärt sind.
