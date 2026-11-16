---
name: spec-driven-development
description: Schärft neue Feature-Ideen und erstellt oder prüft überprüfbare Specs für neue Ideen und Änderungen; verbindet sie nach EPIC mit Planung und Verifikation.
---

# Spec-Driven Development

Nutze diesen Skill, wenn eine Aufgabe mehrere Komponenten betrifft, Anforderungen unklar sind oder eine nachvollziehbare Spec gebraucht wird. Bei einer kleinen eindeutigen Änderung genügt eine kompakte Spec in der Antwort.

Für eine neue Produktidee ohne bereits initialisiertes Projekt koordiniert `$init` zunächst Produktvision und priorisierte Feature-Map; nutze diesen Skill anschließend für eine konkrete Funktion oder einen priorisierten Umsetzungsschritt. Für eine neue Feature-Idee in einem bestehenden Projekt ist dieser Skill der direkte Einstieg; initialisiere das Projekt nicht erneut.

Schärfe eine noch unklare Feature-Idee im bestehenden Projekt vor der Spec bei Bedarf mit `$idea-refine`. Berücksichtige `.codex/PROJECT.md`, soweit vorhanden, sowie relevante Produktunterlagen, Architektur und Code. Übernimm bekannte Entscheidungen, unterscheide Annahmen von Fakten und frage nur wesentliche Lücken oder Konflikte gezielt nach. Kläre Problem, Zielgruppe, Nutzen, Erfolg, Umfang und sinnvolle Alternativen entsprechend der verbleibenden Unsicherheit. Fehlen Projektunterlagen, benenne dies und ermittle nur den nötigen Kontext. Halte das Ergebnis in der Spec oder nach Projektkonvention fest, ohne bestehende Projektunterlagen stillschweigend zu überschreiben. Berücksichtige bereits bestätigte Richtungen und bestehende Aufträge; kläre offene Entscheidungen vor der Umsetzung.

Nutze EPIC verhältnismäßig: Formuliere im **Autorenmodus** Anforderungen eindeutig, einzeln und überprüfbar; markiere Annahmen und offene Entscheidungen und beachte Abhängigkeiten und Umfang. Vergib bei mehrteiligen Vorhaben stabile Kennungen nach Projektkonvention, etwa `REQ-01`, und verknüpfe sie mit Abnahmekriterien. Bei kleinen eindeutigen Änderungen genügt die kompakte Spec ohne zusätzliche Kennungen oder Dateien.

Prüfe im **Review-Modus** vorhandene Spec und, soweit vorhanden, Plan und Aufgaben gemeinsam auf die anwendbaren EPIC-Dimensionen. Nenne belegte Befunde mit Fundstelle, Auswirkung und konkreter Verbesserung; unterscheide fehlende Informationen, offene Entscheidungen und nicht anwendbare Praktiken. Lies für ein vertieftes Review oder die optionale Bewertung [die EPIC-Referenz](references/epic.md). Das Review ersetzt keine Prüfung der tatsächlichen Implementierung.

1. Lies `.codex/rules/WORKFLOW.md`, `.codex/rules/RULES.md` und passende Projektanweisungen. Bei nativen Apple-Apps oder Web-Apps berücksichtige zusätzlich `.codex/rules/ARCHITECTURE.md`.
2. Untersuche relevante vorhandene Dateien und Konventionen, bevor du Anforderungen festschreibst.
3. Bei App-Arbeiten erfasse in der Spec: Problem und Nutzen (für wen, wozu), Ziel und Plattform (Geräte und Versionen), Nutzerablauf und Verhalten ab Startzustand, Umfang (In/Out), beobachtbare Abnahmekriterien sowie relevante Rahmenbedingungen zu Accessibility, Datenschutz, Berechtigungen, Daten und Integrationen. Markiere offene Fragen und Annahmen samt Auswirkungen; kennzeichne nicht relevante Punkte ausdrücklich.
4. Nutze `.codex/rules/templates/SPEC.md` als Vorlage, sofern das Projekt keine eigene Spec-Vorlage nutzt.
5. Löse wesentliche Mehrdeutigkeiten mit gezielten Fragen. Für unwesentliche Lücken triff eine begründete, sichtbare Annahme und arbeite weiter.
6. Bei nativen Apple-Apps und Web-Apps erfasse die relevanten Spec-Vorgaben aus `.codex/rules/ARCHITECTURE.md`: Plattform und Nutzer, Abläufe und Zustände, Berechtigungen, Datenverarbeitung, Integrationen, Accessibility und Qualitätsziele.
7. Prüfe, dass Kriterien beobachtbar und überprüfbar sind und die Spec das gewünschte Verhalten beschreibt. Halte technische Lösungsvorschläge getrennt, sofern sie nicht durch Constraints vorgegeben sind. Prüfe im gewählten Umfang die EPIC-Dimensionen und, sobald ein Plan vorliegt, die Rückverfolgbarkeit und Widerspruchsfreiheit zwischen Spec, Plan und Aufgaben. Verwende vorhandene Artefakte statt eine zweite Statusliste anzulegen.
8. Bestimme nach Plattform und Stack, welche Entwicklungs-Skills für Planung und Umsetzung passen: `$app-dev-swiftui`, `$app-dev-nextjs` oder `$app-dev-angular`. Bei UI-Arbeit kann `$frontend-design-accessibility` ergänzen; ziehe bei SwiftUI auf iOS und iPadOS zusätzlich `$native-ios-design` heran und bei macOS nur dessen plattformübergreifend geeignete Hinweise unter Beachtung von Projektkonventionen und unterstützten Versionen. Für UI- und Plattformverifikation nutze `$verify-ui`.
9. Wenn die Aufgabe personenbezogene Daten verarbeitet, nutze `$dsgvo`, um Datenflüsse, offene Datenschutzentscheidungen, technische Maßnahmen und passende Verifikation in Spec und Plan einzubeziehen.
10. Wenn Supabase Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$backend-dev-supabase` für Datenmodell, Migrationen, Zugriffsschutz und Backend-Verifikation heran.
11. Wenn NestJS mit PostgreSQL Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$backend-dev-nestjs-postgres` für API, Datenmodell, Migrationen, Zugriffsschutz, die Swagger-Entscheidung und Backend-Verifikation heran; falls Swagger bereitgestellt wird, berücksichtige den Schutz von UI und Dokument.
12. Wenn ein C#-/ASP.NET-Core-Backend mit Microsoft SQL Server Teil der vorhandenen oder vereinbarten Architektur ist, ziehe `$backend-dev-csharp-sqlserver` für API, SQL-Server-Schema/Migrationen, Zugriffsschutz, die Swagger-Entscheidung und Backend-Verifikation heran; falls Swagger bereitgestellt wird, berücksichtige den Schutz von UI und Dokument.
13. Wenn SQLite in einer App, im Backend oder im Browser eingesetzt wird, ziehe `$backend-dev-sqlite-data` für Speicherort, Datenhoheit, Migrationen, Offline-Verhalten und Synchronisierung heran.
14. Wenn die Umsetzung von lokaler Laufzeit, CLI, Konfiguration oder Zielumgebung abhängt, nutze `$verify-setup` für eine sichere Readiness-Prüfung.

Ergebnis: eine überprüfbare Spec und klar markierte offene Punkte. Beginne Implementierung erst, wenn sie zum Auftrag passt und notwendige Entscheidungen geklärt sind.
