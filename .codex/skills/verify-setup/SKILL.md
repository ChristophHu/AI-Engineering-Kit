---
name: verify-setup
description: Prüft lokale Entwicklungsvoraussetzungen, Backend-Werkzeuge, Konfiguration und Umgebungstrennung einer bestehenden App, ohne Geheimnisse offenzulegen.
---

# Setup prüfen

Nutze diesen Skill, um die Bereitschaft eines Projekts für lokale Entwicklung oder einen geplanten Umgebungsablauf festzustellen. Er unterstützt Projekte mit Supabase, NestJS mit PostgreSQL oder C# mit Microsoft SQL Server zusammen mit SwiftUI, Next.js oder Angular. Die Prüfung ist standardmäßig lesend; Setup-Änderungen gehören zu einer gesondert beauftragten Reparatur- oder Einrichtungsaufgabe.

## Erwartetes Setup ermitteln

1. Lies Projektanweisungen, `.codex/PROJECT.md`, relevante PRD oder Spec und die gewählte Umgebungsstrategie. Ermittle, ob Supabase, NestJS mit PostgreSQL, C# mit Microsoft SQL Server, ein anderes oder kein Backend verwendet wird. Geht das Backend nicht aus Projektbeschreibung und Codebasis hervor, markiere **Needs decision** und frage vor backend-spezifischen Setup-Prüfungen nach der Backend-Wahl.
2. Prüfe vorhandene Setup-Dateien vor der Prüfung des Rechners: soweit zutreffend `supabase/config.toml`, NestJS-Manifeste und -Konfiguration, `.sln`/`.csproj`/`global.json`, ORM- oder Datenbankmigrationsdateien, Seeds, `.env.example`, `.gitignore`, Lockfiles, Laufzeit- und Versionsdateien, App-Konfiguration, CI-Workflows und Setup-Dokumentation.
3. Ermittle App-Plattform und vorgesehene Laufzeit aus dem Repository. Folge den festgelegten Versionen, der Paketverwaltung, den Skripten, dem Xcode-Schema und der Konfiguration des Projekts. Ersetze sie nicht durch globale Standardwerte.
4. Melde fehlende oder widersprüchliche Informationen als **Needs decision**; leite Produktionsprojekt, Umgebung, Region oder Laufzeit nicht aus einer Beispielarchitektur ab.

## Lokale Voraussetzungen prüfen

Prüfe nur, was auf das Projekt zutrifft:

- Benötigte App-Laufzeit und Version, etwa Node.js und Paketverwaltung oder Xcode/Swift-Toolchain
- Benötigte Paketverwaltung und Übereinstimmung des Lockfiles mit der Projektkonfiguration
- Verfügbarkeit und Version der Supabase CLI; verwende eine im Projekt festgelegte CLI, sofern vorhanden
- Vorhandensein und grundlegende Gültigkeit von `supabase/config.toml`, wenn das Repository die Supabase CLI verwendet
- Unterstützung und Verfügbarkeit der lokalen Laufzeit: Der lokale Supabase-Standardstack benötigt eine Docker-kompatible Laufzeit; nutze eine andere nur, wenn installierte CLI und Host sie unterstützen und das Projekt sie gewählt hat
- Lokalen Supabase-Dienststatus, Migrationen und Schema, Seeds und relevante lokale Tests, wenn sie zum Setup gehören
- App-Konfiguration für die Verbindung zum vorgesehenen lokalen oder Entwicklungs-Backend
- Für NestJS/PostgreSQL: Versionen von Node.js und Paketverwaltung, Projektskripte, gewählte ORM- oder Treiber-CLI, Verfügbarkeit von lokalem PostgreSQL und Laufzeit, Migrationsstatus und Endpunktkonfiguration zwischen App, API und Datenbank
- Für C#/SQL Server: festgelegtes .NET SDK, Laufzeit und Ziel-Framework, Restore- und Build-Konfiguration von Solution und Projekt, gegebenenfalls EF-Core- und Provider-Werkzeuge, vorgesehene lokale oder Test-SQL-Server-Verfügbarkeit, Migrationsstatus und API- beziehungsweise Datenbankendpunkte
- Bei SQLite: konfigurierte Bibliothek, Laufzeit und Schemamigrationsdateien sowie Verfügbarkeit und Persistenz des vorgesehenen lokalen, serverseitigen oder browserbasierten Speicherorts für die Zielumgebung

Installiere im reinen Prüfmodus keine Werkzeuge, lade keine Abhängigkeiten herunter, initialisiere kein neues Supabase-Projekt, ändere keine Konfiguration und starte keine Dienste. Wenn eine Prüfung einen laufenden Stack voraussetzt, melde dies und frage vor Änderungen am Rechner oder Projektzustand nach. Ein laufender lokaler Stack dient nur der Entwicklung und darf nicht als Produktionsdienst bereitgestellt werden.

## Konfiguration und Zugangsdaten sicher prüfen

- Prüfe Beispiel- und Konfigurationsdateien sowie benötigte Variablen**namen**, keine geheimen Werte.
- Gib Werte aus `.env*`, Shell-Umgebungen, Supabase-Secrets, Access Tokens, Datenbank-URLs oder -Passwörtern, JWTs, Publishable Keys oder Secret- und Service-Role Keys niemals aus, zitiere sie nicht, übernimm sie nicht in Berichte und committe sie nicht.
- Prüfe, dass Git Dateien mit Geheimnissen ignoriert und eine sichere `.env.example` benötigte Namen ausschließlich mit Platzhaltern dokumentiert.
- Prüfe, dass Browser- und native Client-Konfiguration nur für die Öffentlichkeit vorgesehene Werte enthalten. Service-Role- und Secret Keys sowie Datenbankpasswörter müssen in vertrauenswürdigen Server- oder Funktionsumgebungen verbleiben.
- Bestätige ohne Offenlegung von Zugangsdaten, dass die App auf den vorgesehenen lokalen oder Entwicklungsendpunkt zeigt. Vergleiche Umgebungsidentitäten anhand redigierter Bezeichner oder boolescher Gleichheitsprüfungen.
- Vermeide Befehle, deren normale Ausgabe Zugangsdaten enthält. Status- und Startausgaben der Supabase CLI können lokale JWT- und API-Key-Werte enthalten, je nach CLI-Version Publishable oder Secret Keys beziehungsweise frühere Anon- oder Service-Role Keys. Unterdrücke oder redigiere diese Werte, bevor sie das Terminalprotokoll oder den Bericht erreichen. Berichte nur, ob der Stack läuft, und unkritische Endpunktinformationen.
- Gib für NestJS/PostgreSQL keine Prozessumgebungen oder Verbindungszeichenfolgen aus. Berichte Erreichbarkeit der Datenbank und Umgebungsidentität nur redigiert oder in unkritischer Form.
- Gib für C#/SQL Server keine Umgebungskonfiguration, Verbindungszeichenfolgen, Passwörter oder Tokens aus. Berichte SQL-Server-Erreichbarkeit und Umgebungsidentität nur redigiert oder in unkritischer Form.
- Gib zur Diagnose einer einzelnen fehlenden Einstellung nicht alle Umgebungsvariablen, `.env`-Dateien, vollständige Konfigurationsdateien mit Geheimnissen oder komplette Prozessumgebungen aus.

## Umgebungstrennung prüfen

Wende die erklärte Strategie des Projekts an:

- **Local:** Bestätige lokale Laufzeit und Konfiguration sowie die Nutzung lokaler Zugangsdaten und Endpunkte in der Entwicklung. Verknüpfe oder ändere im Rahmen lokaler Prüfungen kein gehostetes Projekt.
- **Separate dev and production projects:** Bestätige unterschiedliche konfigurierte Projektidentitäten, ohne Zugangsdaten anzuzeigen. Prüfe, dass lokale oder Entwicklungskonfiguration nicht stillschweigend auf Produktion zielen kann.
- **Single hosted project:** Berichte klar, dass Test- und Livedaten ein Projekt teilen. Werte dies nicht stillschweigend als Setup-Fehler, wenn es ausdrücklich entschieden wurde.
- **Branching/preview:** Bestätige vorgesehenes Basisprojekt und Branch-Konfiguration anhand aktueller Anbieterdokumentation. Prüfe aktuelle Verfügbarkeit und Abrechnungsfolgen, statt Tarif oder Preis anzunehmen.
- **NestJS/PostgreSQL:** Bestätige, dass lokale und gehostete API- und Datenbankziele der erklärten Strategie folgen und die Entwicklung nicht stillschweigend auf Produktion zielen kann. Verbinde dich im Rahmen der Prüfung niemals mit einer gehosteten Datenbank und ändere sie nicht.
- **C#/SQL Server:** Bestätige, dass die erklärten Ziele für .NET API und SQL Server zusammenpassen, lokale und Testeinstellungen nicht stillschweigend auf Produktion zielen können und die Windows Server/IIS-Laufzeit für das Deployment dokumentiert ist. Verbinde dich im Rahmen der Setup-Prüfung niemals mit einer gehosteten Datenbank und ändere sie nicht.
- **SQLite:** Unterscheide Speicher im App-Container, dauerhaften serverseitigen Dateispeicher und Speicher der Browser-Origin. Prüfe bei OPFS im Browser die erklärten Browser- und Worker-Anforderungen und bei serverseitigem SQLite die Dauerhaftigkeit des Hosting-Dateisystems. Behaupte Sicherung, geräteübergreifende Synchronisierung oder Datenwiederherstellung nicht allein aufgrund vorhandener Dateien.

Fehlt die Strategie oder kann Produktion mit Entwicklung verwechselt werden, markiere das Setup als **Needs decision** und stoppe vor jeder entfernten Operation.

## Sicherheitsgrenzen

- Erstelle, verknüpfe, migriere, resette, befülle oder ändere während der Prüfung kein gehostetes Projekt.
- Führe keine Befehle gegen entfernte Ziele und keine destruktiven Reset-Befehle aus. Bestätige Ziel und Umgebung vor jeder späteren autorisierten Änderung.
- Rotiere oder erstelle Zugangsdaten nicht als Setup-Korrektur, sofern dies nicht ausdrücklich beauftragt wurde.
- Setze nicht voraus, dass eine erfolgreiche CLI-Prüfung korrekte Datenbank-Policies, Anwendungsautorisierung oder DSGVO-Konformität belegt. Nutze für Backend-Sicherheits- und Schemaprüfungen je nach Backend `$backend-dev-supabase`, `$backend-dev-nestjs-postgres` oder `$backend-dev-csharp-sqlserver` und für Anforderungen zu personenbezogenen Daten `$dsgvo`.
- Deckt die Prüfung eine nötige Korrektur auf, beschreibe zuerst die genaue Lücke und die vorgeschlagene Änderung. Nimm Änderungen nur vor, wenn der Nutzer Einrichtung oder Reparatur beauftragt hat, und prüfe anschließend den resultierenden Zustand.

## Bericht

Fasse Ergebnisse in einer kompakten Checkliste mit einem dieser Status zusammen:

- **Ready:** für den vorgesehenen lokalen oder Entwicklungsablauf geprüft und nutzbar
- **Not ready:** eine konkrete Voraussetzung oder Konfiguration fehlt oder schlägt fehl
- **Needs decision:** Umgebung, Ziel oder erwartetes Verhalten ist unklar
- **Not checked:** die Prüfung konnte nicht sicher oder praktisch durchgeführt werden

Nenne für jeden nicht bereiten Punkt Befehl oder Beobachtung, relevante Version beziehungsweise Ziel und nächste Aktion. Halte Zugangsdaten und sensible Umgebungswerte aus dem Bericht heraus. Unterscheide geprüfte Fakten von Annahmen und erkläre ein Setup nicht aufgrund einer Teilprüfung vollständig für bereit.

## Offizielle Dokumentation

Nutze aktuelle Dokumentation passend zu installierter CLI und Laufzeit. Beginne mit:

- [Lokale Entwicklung mit Supabase und CLI](https://supabase.com/docs/guides/local-development)
- [Lokaler Entwicklungsablauf und Projektdateien von Supabase](https://supabase.com/docs/guides/local-development/cli-workflows)
- [Supabase-CLI-Konfiguration und Geheimnisse](https://supabase.com/docs/guides/local-development/managing-config)
- [Befehle für lokale und gehostete Projekte ausführen](https://supabase.com/docs/guides/local-development/local-and-hosted-projects)
- [Statusbefehl der Supabase CLI](https://supabase.com/docs/reference/cli/supabase-status)
- [API-Key-Typen von Supabase](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)
