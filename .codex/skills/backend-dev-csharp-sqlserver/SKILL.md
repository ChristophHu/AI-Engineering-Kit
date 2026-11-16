---
name: backend-dev-csharp-sqlserver
description: Plant, implementiert oder prüft eine C#-ASP.NET-Core-Web-API mit Microsoft SQL Server, der etablierten Datenschicht und geschützter Swagger/OpenAPI-Dokumentation.
---

# Backend-Entwicklung mit C# und Microsoft SQL Server

Nutze diesen Skill, wenn die Projektbeschreibung oder die bestehende Codebasis ein C#-Backend mit Microsoft SQL Server vorsieht. Verwende für Web-APIs die etablierte ASP.NET-Core-Version und das Anwendungsmodell des Projekts (Controller oder Minimal APIs); setze keine neue .NET-Version, kein ORM und keinen Identitäts- oder Hostinganbieter voraus. Folge bei größeren Änderungen der abgestimmten Spec und dem Plan; nutze `$spec-driven-development` und `$feature-planning`, wenn Anforderungen oder Umfang zuerst geklärt werden müssen.

## Bestehendes Projekt untersuchen

1. Lies Projektanweisungen, `.codex/PROJECT.md`, relevante Specs und Pläne sowie Datenmodell- und Deployment-Dokumentation.
2. Prüfe `.sln`/`.csproj`, `global.json`, Ziel-Frameworks, SDK und Laufzeit, Paketquellen, API-Stil, Dependency-Injection-Konventionen, SQL-Server-Version und -Edition, Datenzugriffsschicht, gegebenenfalls EF-Core- und Provider-Versionen, Migrationen, Authentifizierung, Tests und CI. Bewahre bestehende Entscheidungen, sofern der abgestimmte Plan keine Änderung vorsieht.
3. Ermittle, ob Windows Server/IIS, ein anderes Windows-Server-Prozessmodell, Azure App Service oder ein anderes ausdrückliches Ziel verwendet wird. Bestimme vor Befehlen lokale, Entwicklungs-, Staging- und Produktionsziele für SQL und API; lege Verbindungszeichenfolgen oder Zugangsdaten niemals offen.
4. Erfasse relevante API-Schichten, DTOs, Validierung, Middleware, Autorisierungsrichtlinien, Datenbankkontexte und Repositories, Migrationen, Swagger/OpenAPI-Konfiguration, Zustandsprüfungen und Deployment-Konfiguration.
5. Ziehe bei versionsabhängigem Verhalten aktuelle Microsoft-Dokumentation passend zu den Projektversionen von .NET, ASP.NET Core, EF Core, SQL Server und Hosting hinzu.

## API-Struktur und Verträge

- Bewahre API-Stil des Projekts (Controller oder Minimal APIs), Dependency Injection, Routing, Versionierung und Fehlerkonventionen. Beschränke Endpunkte auf HTTP-Aufgaben und hinterlege Geschäftslogik in geeigneten Anwendungsservices.
- Validiere nicht vertrauenswürdige Eingaben an der Grenze. Verwende Anfrage- und Antwortverträge, statt Persistenzentitäten als öffentliche API bereitzustellen. Gib einheitliche HTTP-Statuscodes und Problemdetails zurück, ohne SQL, Stacktraces oder interne Daten preiszugeben.
- Nutze asynchrone Ein- und Ausgabe sowie Cancellation Tokens für anfragegebundene Datenbank- und Netzwerkoperationen. Beachte begrenzte Lebensdauern und halte Anfrage-Services nicht in langlebigen Objekten fest.
- Halte Authentifizierung und Autorisierung serverseitig. Prüfe Ressourcenzugehörigkeit und Mandantengrenzen für jede relevante Operation; clientseitige Guards sind keine Sicherheitsgrenze.
- Setze Windows Integrated Authentication nicht allein deshalb voraus, weil die API auf Windows Server läuft. Wähle Authentifizierung anhand des abgestimmten Identitäts- und Deployment-Designs.

## Microsoft SQL Server und Datenzugriff

- Nutze Entity Framework Core mit dem Microsoft-SQL-Server-Provider, wenn dies die etablierte oder freigegebene Datenschicht des Projekts ist. Bewahre andernfalls den gewählten Ansatz, etwa Dapper oder parametrisierten Zugriff mit `Microsoft.Data.SqlClient`; führe nicht standardmäßig ein ORM ein.
- Modelliere nur die von der Spec benötigten Daten. Definiere Beziehungen, Schlüssel, Constraints, Indizes, Nebenläufigkeitsverhalten, Mandantenzugehörigkeit und Löschregeln ausdrücklich. Aktualisiere `docs/data-model.md`, sofern vorhanden.
- Mache Schemaänderungen über den bestehenden Migrations-Workflow des Projekts reproduzierbar. Prüfe generierte Migrationen und SQL, plane Kompatibilität, Nachbefüllungen und Sperren und stimme die Deployment-Reihenfolge mit Anwendungsversionen ab.
- Bevorzuge in Produktion geprüfte Deployment-Skripte oder Migrationspakete, sofern der Freigabeprozess des Teams dies verlangt. Wende Migrationen beim Anwendungsstart nicht stillschweigend an und führe `EnsureCreated` nicht gegen eine bestehende verwaltete Datenbank aus.
- Nutze Transaktionen für mehrstufige Invarianten, parametrisierte Abfragen und begrenzte, für SQL Server/Azure SQL geeignete Wiederholungen. Wiederhole nicht idempotente Operationen nur mit einem sicheren Idempotenzkonzept.
- Speichere Verbindungszeichenfolgen und Zugangsdaten im freigegebenen serverseitigen Secret- oder Konfigurationsmechanismus. Lege sie nicht in Versionsverwaltung, Client-Bundles, Logs, Berichten oder Swagger-Beispielen ab. Ermittle, ob das Ziel Windows-Authentifizierung, Managed Identity oder SQL-Authentifizierung verwendet, statt dies anzunehmen.

## Schutz von Swagger / OpenAPI

- Kläre vor Erstellung eines Backends nach `.codex/rules/ARCHITECTURE.md` Backend-Art, Hosting und die ausdrückliche Swagger/OpenAPI-Entscheidung des Entwicklers. Bevorzuge Windows Server mit IIS; ASP.NET Core unterstützt auch Linux. Bitte den Entwickler daher vor der Erstellung, ein beabsichtigtes Linux-Ziel zu bestätigen oder widersprüchliche Hostinganforderungen zu klären. Empfiehl Swagger/OpenAPI mit visueller Swagger UI als Standard; beachte eine bereits vereinbarte Entscheidung und dokumentiere einen Verzicht, dessen Grund und eine etwaige Alternative. Fahre mit der Erstellung nicht fort, solange diese Entscheidung offen ist. Richte die Implementierung am Ziel-Framework und vorhandenen Werkzeugen aus; aktualisiere Pakete oder Framework-Versionen nicht allein zur Änderung der Dokumentationskonfiguration.
- Dokumentiere bei Bereitstellung DTO-Schemata, Authentifizierungsschemata, relevante Antworten und Fehler sowie API-Versionierung korrekt. Halte erzeugte Dokumentation mit den tatsächlichen Endpunkten synchron und vermeide Geheimnisse, interne Zugangsdaten oder sensible Beispielwerte.
- **Swagger UI und jeder bereitgestellte OpenAPI-JSON- oder Dokumentendpunkt müssen geschützt und für anonyme oder unberechtigte Nutzer unerreichbar sein.** Setze für UI und Dokumentendpunkte einen nicht öffentlichen Netzwerkzugang, etwa VPN oder privaten Ingress, und ausdrückliche Autorisierung an der Anwendungs- oder Hostinggrenze durch. Authentifizierung allein macht eine öffentliche URL nicht privat. Eine versteckte URL, CORS oder eine Authentifizierungsdeklaration im OpenAPI-Schema schützt die Dokumentationsroute nicht.
- Prüfe den Schutz über die tatsächliche Windows-Server-/IIS- oder Reverse-Proxy-Topologie, sodass die Anwendung nicht an einer äußeren Zugriffskontrolle vorbei erreicht werden kann. Wähle und dokumentiere, wer die Dokumentation aufrufen darf und wie die Authentifizierung erfolgt.
- Aktiviere die Dokumentation nur in den vorgesehenen Umgebungen. Verlange bei aktivierten Endpunkten nicht öffentlichen, autorisierten Zugriff und prüfe abgelehnte sowie erlaubte Anfragen; prüfe bei deaktivierten, dass UI und Dokumentendpunkte nicht erreichbar sind.

## Windows-Server-Hosting und Betrieb

- Folge dem ausdrücklich gewählten Hostingmodell. Prüfe bei IIS-Hosting das passende .NET Hosting Bundle und die Laufzeit, Anwendungspoolkonfiguration, Prozessidentität, Dateiberechtigungen, HTTPS-Bindungen, Reverse-Proxy- und Forwarded-Header-Verhalten sowie Deployment-Ergebnis. Prüfe bei anderen Modellen Dienstverwaltung, Laufzeit, Logs sowie Konventionen für Start und Wiederherstellung.
- Betreibe die API nur mit den benötigten Dateisystem- und SQL-Berechtigungen. Halte Datenbankdateien und -sicherungen sowie Anwendungslogs außerhalb öffentlicher oder statischer Verzeichnisse; begrenze den Zugriff auf Geheimnisse und Deployment-Artefakte.
- Definiere Zustands- und Bereitschaftsverhalten, ohne Verbindungszeichenfolgen oder detaillierte Infrastrukturinformationen preiszugeben. Prüfe TLS, Routing, Logs, Start- und Neustartverhalten sowie Produktionskonfiguration.
- Kläre für die gewählte Hostingumgebung Verantwortlichkeiten für SQL-Server-Sicherung, Wiederherstellung, Monitoring und Aufbewahrung. Setze nicht voraus, dass der Windows-Host selbst einen verifizierten Sicherungsprozess bereitstellt.

## Verifikation

Wähle Prüfungen passend zur Änderung und zur bestehenden Repository-Konfiguration. Relevante Prüfungen können umfassen:

- Den im Repository festgelegten `dotnet`-Build und gezielte Unit- und Integrationstests ausführen.
- Migrationen auf einem lokalen oder Test-SQL-Server anwenden beziehungsweise prüfen und Schemakompatibilität aus einem sauberen Zustand sowie unterstützten Vorgängerversionen bestätigen.
- Gültige und ungültige Eingaben, Authentifizierung, Autorisierung, Mandantentrennung, Validierungsfehler und Verhalten bei Datenbankfehlern prüfen.
- Falls Swagger bereitgestellt wird, prüfen, dass beide aktivierten Endpunkte nur vorgesehene Betreiber zulassen, unberechtigten Zugriff ablehnen und nicht öffentlich erreichbar sind; bei deaktivierten Endpunkten deren Nichterreichbarkeit prüfen.
- Falls bereitgestellt, erzeugte OpenAPI-Ausgabe sowie Frontend- und Client-Kompatibilität gegen den API-Vertrag validieren.
- Veröffentlichungsausgabe und dokumentiertes Deployment-Ziel prüfen; auf Windows Server IIS- und Laufzeitkonfiguration sowie Anwendungspoolzugriff prüfen, ohne Geheimnisse preiszugeben.
- Die Trennung lokaler, Entwicklungs-, Test- und Produktionsendpunkte anhand redigierter Kennungen oder boolescher Vergleiche bestätigen.

Führe destruktive Resets, Produktionsmigrationen, Änderungen an Produktionsdaten oder Geheimnissen nicht ohne ausdrückliche Autorisierung für Umgebung und Aktion aus. Bevorzuge zunächst lokale oder Testprüfungen. Nutze `$verify-setup` für die Einsatzbereitschaft von SDK, Datenbank und Konfiguration, `$dsgvo` bei Verarbeitung personenbezogener Daten und `$deploy` für Release- oder Server-Deployment-Arbeiten. Berichte ausgeführte Prüfungen, offene Risiken und nicht ausgeführte Prüfungen.

## Offizielle Microsoft-Dokumentation

Nutze die zu den Zielversionen des Projekts passende Dokumentation. Beginne mit:

- [Web-APIs mit ASP.NET Core erstellen](https://learn.microsoft.com/aspnet/core/web-api)
- [ASP.NET-Core-Web-API mit Swagger / OpenAPI dokumentieren](https://learn.microsoft.com/aspnet/core/tutorials/web-api-help-pages-using-swagger)
- [Microsoft-SQL-Server-Datenbankprovider für EF Core](https://learn.microsoft.com/ef/core/providers/sql-server/)
- [Überblick über EF-Core-Migrationen](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [ASP.NET Core unter Windows mit IIS hosten](https://learn.microsoft.com/aspnet/core/host-and-deploy/iis/)
