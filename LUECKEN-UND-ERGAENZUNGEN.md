# Lücken und Ergänzungsvorschläge

Stand: 12. November 2026. Diese Vorschläge ergänzen den `KONSISTENZBERICHT.md`; sie sind keine Behauptung, dass jedes Projekt alle genannten Komponenten benötigt. Vorhanden sind acht Agentenprofile, 17 Skills sowie Spec-, Plan- und Verifikationsvorlagen.

## Hohe Priorität

1. **Registrierung und Lifecycle der Agenten:** Eine dokumentierte, zur verwendeten Codex-Version passende Registrierung und ein Installationsnachweis für die acht Profile fehlen. Zuerst die tatsächlichen Anforderungen prüfen; dann Installer und Anleitung entsprechend ergänzen.
2. **Upgrade und Skill-Synchronisierung:** Ein versioniertes Verfahren für Updates, Umbenennungen und Konflikte zwischen `.codex/skills` und `.agents/skills` fehlt. Es sollte eigene Änderungen erhalten und alte Skill-Namen kontrolliert behandeln.
3. **Installations- und Konsistenzprüfungen:** Eine automatisierbare Prüfung für frische und wiederholte Installation, Konflikte, Sicherungen, Skill-Namen, Referenzen und Agentenregistrierung fehlt. Sie sollte isolierte temporäre Zielprojekte verwenden und keine Nutzerdaten verändern.
4. **Entscheidungsvorlage für Architektur:** Ein Template für Backend-Auswahl, lokale-only Speicherung, serverseitiges SQLite, Datenhoheit, Hosting und begründete Alternativen würde die Vorgaben in `ARCHITECTURE.md` und `init/SKILL.md` nachvollziehbar verbinden. Swagger-Zugriff und Schutz von UI und OpenAPI-Dokument aufnehmen.

## Mittlere Priorität

5. **Offline- und Synchronisationsvertrag als Template:** Datenhoheit, Konfliktauflösung, Reihenfolge, Wiederholung/Idempotenz, Löschungen, Kontowechsel, Speicherverlust und Wiederherstellung sind in den SQLite-Anweisungen enthalten, aber nicht als ausfüllbare Vorlage vorhanden.
6. **Sicherheits- und Datenfluss-Template:** Vertrauensgrenzen, Identitäten, Rollen, Datenzugriff, Geheimnisse und Nachweise für Schutzmaßnahmen könnten projektbezogen festgehalten werden. Vorhandene Backend- und DSGVO-Skills einbeziehen.
7. **Betriebs- und Wiederherstellungsvorlage:** Backup, Restore-Probe, Migration, Monitoring, Rollback und Zuständigkeiten für PostgreSQL, SQL Server und serverseitiges SQLite konkretisieren, soweit die gewählte Architektur sie benötigt.
8. **Delegationsauftrag und Ergebnisvorlage:** `DELEGATION.md` beschreibt bereits die erforderlichen Felder; ein wiederverwendbares Template könnte Zuständigkeit für Dateien, Abhängigkeiten, Prüfungen, Grenzen und Evidenz vereinheitlichen.
9. **Änderungs- und Übergabevorlage für bestehende Projekte:** Eine Vorlage für Inventar vorhandener Agenten, Skills, Konfiguration, Abweichungen und Migrationsentscheidungen würde die Einführung des Kits in bestehende Repositories unterstützen.

## Optionale Agenten und Skills

10. **Plattformspezialisten für SwiftUI, Next.js und Angular:** Die vorhandenen Plattform-Skills und der allgemeine Implementation-Worker decken diese Arbeit bereits ab. Separate Agentenprofile lohnen sich bei regelmäßig paralleler, klar abgegrenzter Plattformarbeit; sie müssen keine neuen Skills voraussetzen.
11. **Sicherheits- oder Datenschutz-Reviewer:** Für größere Vorhaben kann ein lesendes Spezialprofil die vorhandenen `code-reviewer`- und `dsgvo`-Anweisungen gezielt anwenden. Verantwortlichkeiten und die Grenzen rechtlicher Bewertung klar beschreiben.
12. **Release-/Operations-Spezialist:** Bei häufigen Releases könnte ein Agent das vorhandene `deploy`-Skill mit einem Betriebs-Template verbinden. Autorisierung und Zielumgebung bleiben ausdrücklich beim Nutzer und der Hauptinstanz.
13. **API-Vertrags- und Kompatibilitäts-Skill:** Erst bei wiederkehrendem Bedarf ergänzen, um OpenAPI-Verträge, Versionierung und Client-Kompatibilität über mehrere Backend-Stacks hinweg zu prüfen. Die vorhandenen Backend-Skills enthalten bereits Grundlagen.

Die tatsächliche Notwendigkeit dieser Ergänzungen hängt von Projekten und Arbeitsweise ab. Die Vorschläge wurden nicht implementiert und nicht anhand eines produktiven Zielprojekts erprobt.
