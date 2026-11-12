# Lücken und Ergänzungsvorschläge

Stand: 12. November 2026; aktualisiert nach Einführung der Backend-Entscheidungsvorlage. Diese Vorschläge ergänzen den `KONSISTENZBERICHT.md`; nicht jedes Projekt benötigt alle genannten Komponenten. Vorhanden sind acht Agentenprofile, 17 Skills sowie Spec-, Plan-, Verifikations- und Backend-Entscheidungsvorlagen.

## Hohe Priorität

1. **Registrierung und Lifecycle der Agenten:** Eine dokumentierte, zur verwendeten Codex-Version passende Registrierung und ein Installationsnachweis für die acht Profile fehlen. Zuerst die tatsächlichen Anforderungen prüfen; dann Installer und Anleitung entsprechend ergänzen.
2. **Upgrade und Skill-Synchronisierung:** Ein versioniertes Verfahren für Updates, Umbenennungen und Konflikte zwischen `.codex/skills` und `.agents/skills` fehlt. Es sollte eigene Änderungen erhalten und alte Skill-Namen kontrolliert behandeln.
3. **Installations- und Konsistenzprüfungen:** Eine dauerhafte automatisierte Prüfung für frische und wiederholte Installation, Konflikte, Erhalt bestehender Dateien, Skill-Namen, Referenzen und Agentenregistrierung fehlt. Zwei einmalige Installationsprüfungen in temporären Verzeichnissen deckten das Verhalten der `AGENTS.md` und des früheren Backups ab; eine neue Sicherung ist nicht vorgesehen. Weitere Prüfungen sollten isolierte temporäre Zielprojekte verwenden.
4. **Umgesetzt – Entscheidungsvorlage für Architektur:** `.codex/rules/templates/BACKEND-ENTSCHEIDUNG.md` verbindet Backend-Auswahl, lokale Speicherung, SQLite, Datenhoheit, Hosting, Alternativen und geschützten Swagger-Zugang mit den Architektur- und Initialisierungsregeln.

## Mittlere Priorität

5. **Offline- und Synchronisationsvertrag als Template:** Die Backend-Entscheidungsvorlage erfasst Datenhoheit und grundlegende Sync-Fragen. Eine ausführliche Vorlage für Reihenfolge, Wiederholung/Idempotenz, Konflikte, Löschungen, Kontowechsel, Speicherverlust und Wiederherstellung fehlt weiterhin.
6. **Sicherheits- und Datenfluss-Template:** Die Backend-Entscheidungsvorlage erfasst Zugriff und Swagger-Schutz. Eine ausführliche Vorlage für Vertrauensgrenzen, Identitäten, Datenflüsse, Geheimnisse und Nachweise könnte die vorhandenen Backend- und DSGVO-Skills ergänzen.
7. **Betriebs- und Wiederherstellungsvorlage:** Die Backend-Entscheidungsvorlage spricht Sicherung und Wiederherstellung bei SQLite an. Ein ausführlicher Betriebsplan für Restore-Probe, Migration, Monitoring, Rollback und Zuständigkeiten für PostgreSQL, SQL Server und serverseitiges SQLite fehlt weiterhin.
8. **Delegationsauftrag und Ergebnisvorlage:** `DELEGATION.md` beschreibt bereits die erforderlichen Felder; ein wiederverwendbares Template könnte Zuständigkeit für Dateien, Abhängigkeiten, Prüfungen, Grenzen und Evidenz vereinheitlichen.
9. **Änderungs- und Übergabevorlage für bestehende Projekte:** Eine Vorlage für Inventar vorhandener Agenten, Skills, Konfiguration, Abweichungen und Migrationsentscheidungen würde die Einführung des Kits in bestehende Repositories unterstützen.

## Optionale Agenten und Skills

10. **Plattformspezialisten für SwiftUI, Next.js und Angular:** Die vorhandenen Plattform-Skills und der allgemeine Implementation-Worker decken diese Arbeit bereits ab. Separate Agentenprofile lohnen sich bei regelmäßig paralleler, klar abgegrenzter Plattformarbeit; sie müssen keine neuen Skills voraussetzen.
11. **Sicherheits- oder Datenschutz-Reviewer:** Für größere Vorhaben kann ein lesendes Spezialprofil die vorhandenen `code-reviewer`- und `dsgvo`-Anweisungen gezielt anwenden. Verantwortlichkeiten und die Grenzen rechtlicher Bewertung klar beschreiben.
12. **Release-/Operations-Spezialist:** Bei häufigen Releases könnte ein Agent das vorhandene `deploy`-Skill mit einem Betriebs-Template verbinden. Autorisierung und Zielumgebung bleiben ausdrücklich beim Nutzer und der Hauptinstanz.
13. **API-Vertrags- und Kompatibilitäts-Skill:** Erst bei wiederkehrendem Bedarf ergänzen, um OpenAPI-Verträge, Versionierung und Client-Kompatibilität über mehrere Backend-Stacks hinweg zu prüfen. Die vorhandenen Backend-Skills enthalten bereits Grundlagen.

Die tatsächliche Notwendigkeit der offenen Ergänzungen hängt von Projekten und Arbeitsweise ab. Die Entscheidungsvorlage ist erstellt und verknüpft; sie wurde noch nicht anhand eines produktiven Zielprojekts erprobt. Die übrigen Vorschläge bleiben offen.
