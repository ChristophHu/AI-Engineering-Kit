# Referenzarchitekturen für native Apple-Apps und Web-Apps

Dieses Kit unterstützt insbesondere native Apple-Anwendungen und Web-Apps. Die folgenden Diagramme und Beschreibungen sind grobe Referenzarchitekturen. Sie helfen, Anforderungen, Schnittstellen und Verantwortlichkeiten zu klären; sie schreiben einem Projekt keinen Anbieter oder Technologie-Stack vor. Maßgeblich sind die bestehende Codebasis und die Projektbeschreibung in `.codex/PROJECT.md`.

## Native Apple-App

![Referenzarchitektur einer nativen iOS-App](native-app-architecture.png)

Das Diagramm zeigt eine iOS-Referenz. Bei iPadOS- und macOS-Apps bleiben Backend- und Integrationsfragen relevant; UI, Navigation, Fenster- und Eingabeverhalten richten sich nach den jeweiligen Plattformen und den Projektkonventionen.

- **App:** native iOS-Anwendung mit SwiftUI; UI/Views und App-Logik bilden die Client-Seite.
- **Lokale Daten:** SQLite kann app-intern gerätebezogene Daten, Cache oder eine Offline-Arbeitskopie halten. Synchronisierung mit einem Backend ist eine separate Anforderung mit festzulegender Datenhoheit, Konfliktstrategie und Verhalten bei Konto-/Verbindungswechsel.
- **Backend:** Supabase, eine NestJS-API mit PostgreSQL oder eine C#-API mit Microsoft SQL Server. Das Diagramm zeigt Supabase nur als Referenz; die Projektbeschreibung bestimmt den Backend-Stack. NestJS und ASP.NET Core eignen sich als separate API-Komponenten für Web-Apps. Swagger UI und OpenAPI-Endpunkte müssen geschützt und dürfen nicht öffentlich erreichbar sein.
- **Externe Dienste:** beispielhaft Mistral für KI, Apple In-App Purchases für Zahlungen und Brevo für E-Mails.
- **Build und Veröffentlichung:** GitHub für Versionsverwaltung und CI/CD; App Store Connect für Builds, Testverteilung und Veröffentlichung.
- **Verbindungen:** Die App kommuniziert mit dem Backend und klar abgegrenzten externen Diensten. App Store Connect ist Teil des Veröffentlichungswegs.

## Web-App

![Referenzarchitektur einer Web-App](saas-architektur.png)

- **Frontend:** Next.js oder Angular. Next.js kann Browser-Client und serverseitige Route Handler in einem Framework bereitstellen. Angular ist eine gleichwertige Frontend-Option; falls serverseitige Funktionen benötigt werden, werden sie als separate Backend- oder API-Komponente geplant.
- **Backend:** Supabase, eine eigenständige NestJS-API mit PostgreSQL oder eine C#-API mit Microsoft SQL Server. Supabase ist eine Referenzoption; die Projektbeschreibung legt die Auswahl fest. NestJS und ASP.NET Core liegen als separate serverseitige Komponenten zwischen Frontend und Datenbank. Swagger UI und OpenAPI-Endpunkte sind geschützt und nicht öffentlich erreichbar.
- **SQLite:** Kann alternativ als serverseitige Datenbank hinter einer API oder lokal im Browser über WebAssembly mit persistentem Browserspeicher eingesetzt werden. Server-SQLite ist für gemeinsam genutzte Daten nur passend, wenn Persistenz, Schreibkonkurrenz und Hosting-Topologie dazu passen. Browser-SQLite ist pro Browser-Origin lokal und synchronisiert sich nicht von selbst mit anderen Nutzern oder Geräten.
- **Externe Dienste:** beispielhaft Mistral für KI, Stripe für Zahlungen und Brevo für E-Mails.
- **Build und Veröffentlichung:** GitHub für Versionsverwaltung und CI/CD; Hostinger als dargestelltes Hosting-Ziel.
- **Verbindungen:** Browser und Server haben unterschiedliche Vertrauensgrenzen. Privilegierte Zugriffe und geheime Schlüssel gehören auf die Serverseite.

## Architektur bei Projektarbeit anwenden

Halte die Auswahl und ihre Begründung bei Bedarf mit `.codex/rules/templates/BACKEND-ENTSCHEIDUNG.md` oder in gleichwertigen bestehenden Architekturunterlagen fest. Verlinke die Entscheidung aus dem Plan; überschreibe keine vorhandenen Projektentscheidungen.

1. Ermittle zuerst, ob das Projekt eine native Apple-App, eine Web-App oder eine Kombination daraus ist. Lies `.codex/PROJECT.md` und untersuche die vorhandene Architektur.
   Ermittle vor der Erstellung eines Backends die vereinbarte Backend-Art und das Hosting aus Projektbeschreibung, bestehenden Entscheidungen und Codebasis. Fehlt eine wesentliche Entscheidung, frage den Entwickler vor der Umsetzung direkt. Biete je nach Bedarf Supabase, NestJS mit PostgreSQL, C# mit Microsoft SQL Server oder ein Backend mit SQLite an; lokale Anwendungen können auch ohne Backend auskommen. Frage bei Bedarf zuerst nach Serverbetriebssystem, Hosting, Datenbank und betrieblichen Vorgaben. NestJS kann auf verschiedenen Serverplattformen laufen, sofern Node.js und die gewählte Datenbank dort unterstützt werden. Für C# ist Windows Server, vorzugsweise mit IIS, die bevorzugte Zielumgebung. ASP.NET Core kann auch auf Linux laufen: Weicht die Projektbeschreibung davon ab, etwa C# auf Linux, frage den Entwickler ausdrücklich, ob diese Kombination gewollt ist, und dokumentiere die Entscheidung; behandle sie nicht als technisch unmöglich. Bei widersprüchlichen Vorgaben kläre die Entscheidung vor der Backend-Erstellung.
   Für ein NestJS- oder C#-API-Backend ist Swagger/OpenAPI mit visueller Swagger UI die empfohlene Standardauswahl. Frage den Entwickler vor der Erstellung ausdrücklich nach seiner Entscheidung, sofern sie nicht bereits eindeutig getroffen wurde. Dokumentiere die Entscheidung, bei Verzicht den Grund und gegebenenfalls eine Alternative. Für Supabase und SQLite allein ist keine Swagger-Abfrage oder -Implementierung erforderlich. Wird SQLite zusammen mit einer NestJS- oder C#-API genutzt, gilt die Entscheidungspflicht für die jeweilige API. Bei anderen Backends richte dich nach den Projektanforderungen. Wenn Swagger bereitgestellt wird, müssen UI und alle OpenAPI-Dokumentendpunkte gegen unberechtigten Zugriff geschützt und nicht öffentlich erreichbar sein; kläre Zugang und Umgebungen.
   Kläre bei SQLite zusätzlich, ob die Daten app-/browserlokal, serverseitig hinter einer API oder beides sein sollen und ob sie Cache, lokale Arbeitskopie oder führender Datenspeicher sind. Bei Synchronisierung müssen Datenhoheit, Konfliktverhalten und Offline-Garantien feststehen oder als offene Entscheidung mit Auswirkung markiert sein.
2. Nutze für jede betroffene Plattform die vier Bausteine in diesem Dokument: Spec-Vorgaben, Planvorgaben, Startkriterien und Abschlusskriterien.
3. Bewahre die Trennung zwischen UI, Anwendungslogik, Backend-Zugriff und externen Diensten. Passe die Trennung an die vorhandenen Muster des Projekts an.
4. Schütze Daten und Zugangsdaten: nutze serverseitige Geheimnisse, angemessene Autorisierung und Datenbankrichtlinien wie RLS, sofern die Architektur sie verwendet. Lege keine geheimen Schlüssel in Client-Code ab.
5. Behandle Anbieter in den Diagrammen als Beispiele. Übernimm sie nur, wenn sie im Projekt bereits eingesetzt oder ausdrücklich als Anforderung festgelegt sind.
6. Aktualisiere die Projektbeschreibung oder Architekturunterlagen, wenn eine Änderung Komponenten, Datenflüsse, Hosting, Integrationen oder Sicherheitsgrenzen wesentlich verändert.

## 1. Spec-Vorgaben

Vor der Planung beschreibt die Spec das gewünschte Verhalten und mindestens die für die Aufgabe relevanten Punkte:

- Zielplattform und betroffene Nutzer
- wichtige Nutzerabläufe, Zustände und beobachtbare Ergebnisse
- benötigte Berechtigungen und deren nutzerseitiger Zweck
- verarbeitete Daten, Speicherbedarf, Aufbewahrung und Löschung, soweit relevant
- externe Integrationen und erwartetes Verhalten bei Ausfall oder Fehlern
- Barrierefreiheitsanforderungen
- relevante Qualitätsziele wie Leistung, Zuverlässigkeit, Datenschutz, Sicherheit und Kompatibilität

Die Spec formuliert Anforderungen aus Nutzer- und Produktsicht. Frameworks, Laufzeit, Architekturpattern und konkrete Implementierung gehören in den Plan, außer eine technische Vorgabe ist ausdrücklich als Einschränkung gesetzt.

## 2. Plattformspezifische Planvorgaben

Der Plan untersucht die vorhandene Codebasis und hält relevante Entscheidungen, Begründungen und offene Punkte fest.

### Native Apple-App

Je nach Änderung berücksichtigen und dokumentieren:

- UI-Technologie und Deployment-Ziele für jede unterstützte Plattform und Mindestversion
- Navigation und Zustandsverwaltung
- plattformgerechte Layouts, Navigation und Eingabe (z. B. Touch auf iPhone, adaptive iPad-Oberflächen, Fenster, Menüs und Tastatur auf Mac)
- Persistenz und Backend-Zugriff
- Berechtigungen und verwendete Apple-Frameworks
- App-Lebenszyklus, Hintergrundverhalten und relevante Systemintegration
- Verifikationsschritte auf Build-, Simulator- oder Geräteebene

### Web-App

Je nach Änderung berücksichtigen und dokumentieren:

- Framework und Laufzeit, einschließlich Next.js oder Angular, falls zutreffend
- Rendering- und Routing-Modell
- Komponentenstruktur und Datenfluss
- APIs, Authentifizierung und Vertrauensgrenzen zwischen Browser, Server und Backend
- ausgewähltes Backend und Hosting; bei NestJS/C# dokumentierte Swagger-Entscheidung, bei Bereitstellung geschützte und nicht öffentlich erreichbare UI und OpenAPI-Endpunkte
- lokale Persistenz und SQLite-Einsatzort: Serverdatei hinter API oder Browser-WASM/OPFS; bei lokaler Speicherung unterstützte Browser, Worker-/Speicheranforderungen, Quoten- und Fehlerverhalten
- Sync-Vertrag für lokale SQLite-Kopien: Datenhoheit, Outbox/Retry/Idempotenz, Konfliktauflösung, Löschungen, Kontowechsel und Offline-Verhalten
- unterstützte Browser und Viewports
- Hosting- und Deployment-Ziel

## 3. Prüfkriterien vor der Umsetzung

Der Übergang von Plan zu Implementierung ist erst freigegeben, wenn die relevanten Punkte erfüllt oder als begründete, sichtbare Annahmen dokumentiert sind:

- Plattform und betroffene Architekturkomponenten sind identifiziert.
- Technische Architekturentscheidungen sind begründet und passen zu Projektbeschreibung und Codebasis.
- Datenflüsse, Vertrauensgrenzen, Berechtigungen und Integrationen sind verstanden.
- Wesentliche offene Entscheidungen sind geklärt oder mit Auswirkung als Annahmen markiert.
- Jedes Abnahmekriterium beschreibt ein prüfbares Ergebnis und ist im Plan durch Schritte und Nachweise abgedeckt.

## 4. Prüfkriterien zum Abschluss

Prüfe jedes Spec-Abnahmekriterium einzeln und ergänze für die betroffene Plattform die passenden Checks. Führe nur sinnvolle und im Projekt möglichen Checks aus. Weise nicht ausgeführte Checks und bekannte Einschränkungen ausdrücklich aus.

### Native Apple-App

- Build für das festgelegte Deployment-Ziel
- relevante Abläufe im Simulator oder auf einem Gerät
- Berechtigungs- und App-Lebenszyklusverhalten
- Accessibility für betroffene Abläufe und Oberflächen

### Web-App

- Build und passende automatisierte Tests
- zentrale Abläufe in unterstützten Browsern und Viewports
- Accessibility für betroffene Abläufe und Oberflächen
- Fehler- und Ladezustände sowie Sicherheitsgrenzen
- Offline-, Wiederverbindungs- und Synchronisierungsverhalten, falls lokale SQLite-Speicherung Teil der Web-App ist
