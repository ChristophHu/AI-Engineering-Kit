---
name: deploy
description: Bereitet Release und Deployment eines bestehenden SwiftUI-, Next.js-, Angular- oder ASP.NET-Core-Projekts vor oder führt sie anhand der konfigurierten Ziele, Anbieter und CI/CD-Konventionen aus.
---

# Deploy

Nutze diesen Skill zur Vorbereitung eines Releases, zur Änderung der Deployment-Konfiguration oder zur Bereitstellung einer Anwendung. Folge bei größeren Änderungen der abgestimmten Spec und dem Plan; nutze `$feature-planning` und `$implementation-review`, wenn die Release-Arbeit einen nachvollziehbaren Plan und Verifikation benötigt.

## Bestehendes Release-Setup untersuchen

1. Lies Projektanweisungen, `.codex/PROJECT.md` sowie relevante Specs und Pläne.
2. Prüfe Repository, Paket- und Build-Konfiguration, CI-Workflows, Release-Skripte, Dokumentation der Umgebungsvariablen und bisherige Release-Konventionen.
3. Ermittle Plattform, Anwendungsversion, Zielumgebung (lokal, Test, Staging, Produktion), Hosting- oder Store-Anbieter, Deployment-Modus, benötigte Geheimnisse, Datenbankänderungen und Rückfallmethode.
4. Bewahre den bestehenden Anbieter und Release-Workflow. Leite Hostinger, App Store Connect oder andere Anbieter nicht aus Referenzdiagrammen des Kits ab. Sind Zielumgebung, Anbieter oder Release-Kanal unklar, halte die Entscheidung vor Änderungen am Deployment-Verhalten als offen fest.
5. Ziehe für aktuelle anbieterspezifische Anforderungen dessen offizielle Dokumentation und die aktuelle Projektkonfiguration hinzu. Halte relevante Quellen und Prüfdatum fest, wenn eine veränderliche Anforderung das Release beeinflusst.

## Release vorbereiten

Plane und prüfe nur die für das Projekt relevanten Schritte:

- Führe die konfigurierten Build- und Release-Prüfungen des Repositorys aus.
- Bestätige Zielumgebung und benötigte Laufzeit- und Plattformversionen.
- Ermittle benötigte Umgebungsvariablen und Geheimnisse, ohne deren Werte offenzulegen.
- Bewahre Geheimnisse im konfigurierten CI- oder Hosting-Secret-Store; committe sie niemals und bette keine Servergeheimnisse in Client-Bundles ein.
- Prüfe soweit zutreffend Domain, TLS, Routing, Zustandsprüfungen, statische Ressourcen sowie Server- und Laufzeitkonfiguration.
- Ermittle Datenbankmigrationen, Kompatibilitätsanforderungen, Sicherungsbedarf und Rückfallbeschränkungen.
- Definiere Deployment-Reihenfolge, Smoke-Tests, Erfolgskriterien und einen praktikablen Rückfall- oder Wiederherstellungsweg.
- Bestätige soweit zutreffend Versionierung, Release Notes, Signierung und Store-Metadaten.

Erfinde keine Deployment-Infrastruktur und ergänze keinen neuen Anbieter, wenn ein bestehender Prozess die Spec erfüllen kann.

## Plattformprofile

### SwiftUI und Apple-Release

- Ermittle unterstützte Apple-Plattformen, Bereitstellungsziele, Schemes, Konfigurationen, Bundle-Identifier, Signierung und den bestehenden Archivierungs- und Exportprozess.
- Bewahre Signierungsidentitäten, Provisioning Profiles, Entitlements und Bezeichner. Erstelle, ersetze, widerrufe oder veröffentliche Zugangsdaten nicht beiläufig als Release-Schritt.
- Plane den konfigurierten Build beziehungsweise das Archiv und die gegebenenfalls bestehende Übergabe an TestFlight oder App Store Connect.
- Prüfe eingereichten Build und Release-Metadaten gegen die Release-Kriterien des Projekts. Store-Einreichung, gestaffelte Freigabe und öffentliche Veröffentlichung sind gesonderte externe Aktionen.

### Next.js deployment

- Ermittle Next.js-Version, App Router oder Pages Router, Anforderungen an Node und Laufzeit, Rendering-Modus, Build- und Startskripte sowie Anbieterkonfiguration.
- Prüfe Server- und Client-Grenzen, Produktionsumgebungsvariablen, Zustandsverhalten, Routing sowie vom Release betroffenes Cache- oder Revalidierungsverhalten.
- Kläre, ob das Ziel einen Node-Server, serverlose Ausgabe oder statischen Export erwartet; wechsle den Deployment-Modus nicht ohne abgestimmten Plan.

### Angular deployment

- Ermittle Angular-Version, Produktionskonfiguration in `angular.json`, Ausgabemodus, gegebenenfalls SSR-Setup und Hostingkonfiguration.
- Prüfe Build-Ausgabe, Basispfad, Ausweichverhalten clientseitiger Routen, Cache-Verhalten und Laufzeitkonfiguration für den gewählten Host.
- Setze nicht voraus, dass Angular ausschließlich statisch ist, und ergänze SSR nicht ohne ausdrückliche Anforderung und Implementierungsplan.

### Deployment eines C#- / ASP.NET-Core-Backends

- Ermittle Ziel-Framework, festgelegtes SDK und Laufzeit, Veröffentlichungsmodus, Hostingmodell, gegebenenfalls Windows-Server-/IIS-Konfiguration, SQL-Server-Ziel, Secret-Mechanismus, Migrations-Workflow und bestehende CI/CD-Konventionen.
- Prüfe für IIS das benötigte Hosting Bundle und die Laufzeit, Identität und Berechtigungen des Anwendungspools, HTTPS-Bindungen, Routing und Forwarded Headers, Zustandsprüfungen sowie das zur bestehenden Konfiguration passende In-Process- oder Out-of-Process-Deployment.
- Bewahre SQL-Server-Verbindungsdaten in der freigegebenen serverseitigen Konfiguration oder im Secret Store. Prüfe, dass die bereitgestellte API nur die vorgesehene Datenbank erreichen kann; lege Verbindungszeichenfolgen nicht in Logs oder Berichten offen.
- Prüfe vor dem Deployment SQL-Server-Migrationsskripte oder -pakete und Anforderungen an Sicherung und Rückfall. Halte die Reihenfolge von Anwendungs-Deployment und Schemamigration mit aktiven Anwendungsversionen kompatibel.
- Falls Swagger bereitgestellt wird, bestätige, dass UI und OpenAPI-Dokumentendpunkte in der bereitgestellten Topologie geschützt und nicht öffentlich sind. Prüfe bei Aktivierung erlaubten und abgelehnten Zugriff und bei Deaktivierung, dass beide Endpunkte nicht erreichbar sind.

## Bereitstellen und prüfen

Bestätige vor dem Deployment, dass erforderliche Prüfungen bestanden oder Ausnahmen dokumentiert sind. Führe Deployment-Befehle nur für die vom Nutzer autorisierte Umgebung und den autorisierten Umfang aus. Produktions-Deployment, Store-Einreichung und öffentliche Veröffentlichung erfordern eine ausdrückliche Autorisierung, sofern diese noch nicht erteilt wurde.

Nach einem autorisierten Deployment:

1. Prüfe bereitgestellte Version und Zielumgebung.
2. Führe geplante Zustands- und Smoke-Tests einschließlich zentraler Nutzerabläufe aus, soweit verfügbar.
3. Prüfe relevante Logs und den Dienstzustand, ohne personenbezogene Daten oder Geheimnisse offenzulegen.
4. Vergleiche Ergebnisse mit den Release-Kriterien. Folge bei fehlgeschlagenen Prüfungen dem geplanten Rückfall- oder Wiederherstellungsweg, sofern autorisiert; stoppe andernfalls und berichte Fehler und erforderliche Aktion.
5. Berichte, was erstellt, bereitgestellt oder eingereicht wurde, wohin es ging, welche Prüfungen liefen, deren Ergebnisse und offene Risiken oder Folgearbeiten.

Nutze `$verify-ui` für nutzerseitige Abläufe, soweit angemessen, und `$dsgvo`, wenn das Release die Verarbeitung personenbezogener Daten oder deren betrieblichen Umgang ändert. Behaupte niemals ein erfolgreiches Release oder Deployment, ohne den resultierenden Zustand der Umgebung beziehungsweise des Stores geprüft zu haben.
