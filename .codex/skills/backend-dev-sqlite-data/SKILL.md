---
name: backend-dev-sqlite-data
description: Plant, implementiert oder prüft SQLite-Persistenz für native Apple-Apps, serverseitige APIs und browserbasierten WebAssembly/OPFS-Speicher einschließlich Offline-Synchronisierung und Konfliktbehandlung.
---

# Datenentwicklung mit SQLite

Kläre Speicherort sowie ein etwaiges Backend und Hosting gemäß `.codex/rules/ARCHITECTURE.md`. SQLite allein erfordert weder eine Swagger-Entscheidung noch eine Swagger-Implementierung. Verwendet eine separate NestJS- oder C#-API SQLite, gelten deren Regeln zur ausdrücklichen Swagger-Entscheidung und zum Schutz. Folge bei anderen APIs den Projektanforderungen; schütze tatsächlich bereitgestellte Swagger UI und OpenAPI-Dokumente vor öffentlichem und unberechtigtem Zugriff. Lokales SQLite allein setzt kein API-Backend voraus.

Nutze diesen Skill, wenn ein Projekt Daten in SQLite auf iOS, iPadOS, macOS, einem Server oder im Browser speichert. Ermittle zuerst, welche Laufzeit für welche Datenbank zuständig ist und ob diese führender Datenbestand, Cache, lokale Arbeitskopie oder Serverdatenbank ist. SQLite in einer Laufzeit wird nicht automatisch mit SQLite in einer anderen Laufzeit geteilt oder synchronisiert.

Folge bei größeren Änderungen der abgestimmten Spec und dem Plan. Nutze `$spec-driven-development` und `$feature-planning`, wenn Verhalten oder Architektur unklar sind. Bewahre das gewählte Backend: Lokales SQLite kann Supabase, NestJS/PostgreSQL oder C#/SQL Server als Offline-Speicher oder Cache ergänzen; ersetze das Server-Backend des Projekts nicht stillschweigend durch SQLite.

## Wann verwenden

- SQLite-Persistenz für eine native iOS-, iPadOS- oder macOS-App planen, implementieren oder prüfen.
- SQLite als serverseitigen Datenspeicher hinter einer Web-API oder lokal im Browser mit WebAssembly und gegebenenfalls OPFS einsetzen.
- Lokale SQLite-Daten für Offline-Nutzung, Cache oder Synchronisierung mit einem bestehenden Backend gestalten oder prüfen.
- SQLite-Schema, Migrationen, Transaktionen, Datensicherung, Wiederherstellung oder Konfliktbehandlung bearbeiten.

**Nicht verwenden, wenn:**

- Weder SQLite noch eine darauf beruhende Persistenz für die Aufgabe vorgesehen ist und keine Entscheidung oder Integration zu SQLite ansteht. Nutze für den gewählten Datenspeicher oder Backend-Stack den entsprechenden Skill.
- Ausschließlich die entfernte API oder Serverdatenbank eines Projekts ohne Bezug zur lokalen SQLite-Persistenz bearbeitet wird; nutze den passenden Backend-Skill.
- Es ausschließlich um eine Oberfläche ohne Bezug zur SQLite-Persistenz oder zum Offline-Verhalten geht; nutze den passenden Plattform- oder UI-Skill.

## Modell der Datenhoheit untersuchen

Kläre vor dem Entwurf eines Schemas oder einer Synchronisierung:

- Ziellaufzeit und Plattformen, unterstützte Betriebssystem- und Browserversionen sowie die bereits verwendete SQLite-Implementierung oder -Bibliothek
- Verantwortlichkeit und Geltungsbereich der Daten: gerätelokal, lokal zum Browserprofil, nutzerbezogen, mandantenweit oder global geteilt
- Führenden Datenbestand für jeden Datensatz: lokales SQLite, entfernte API oder Datenbank oder ein ausdrücklich definiertes Konfliktlösungsmodell
- Ob die Offline-Nutzung nur lesend ist, lokale Änderungen erlaubt oder den gesamten Ablauf unterstützt
- Welche Daten in welche Richtung synchronisiert werden und ob die Synchronisierung automatisch, manuell oder auf beide Arten erfolgt
- Erwartete Datenmenge, Schreibfrequenz, gleichzeitige Schreibzugriffe und Anforderungen an Aufbewahrung, Löschung, Export, Sicherung und Wiederherstellung
- Verhalten bei erstem Start, Upgrade, Abmeldung oder Kontowechsel, Verbindungsverlust und -wiederherstellung sowie Datenbankbeschädigung oder ausgeschöpftem Kontingent

Leite aus „offlinefähig“ weder eine bidirektionale Synchronisierung noch die Verbindlichkeit eines lokalen Caches ab. Sind Datenhoheit, Verhalten über mehrere Geräte oder Konfliktregeln nicht festgelegt und beeinflussen das für Nutzer sichtbare Ergebnis, markiere dies als offene Entscheidung und frage vor der Implementierung des betreffenden Verhaltens nach.

## Native Apple-Apps (iOS, iPadOS, macOS)

- Folge der bestehenden Persistenzarchitektur und den Mindestversionen des Betriebssystems. Prüfe, ob das Projekt SQLite direkt, SwiftData, Core Data, GRDB, SQLite.swift oder eine andere etablierte Schicht nutzt; ergänze oder ersetze keine Bibliothek ohne Anforderung und Plan.
- Halte Datenbankzugriffe hinter der Persistenzgrenze der Anwendung. Definiere Schemaverantwortung, versionierte Migrationen, Constraints, Indizes, Transaktionen und Wiederherstellungsverhalten. Führe blockierende Datenbankarbeit nicht auf dem UI-Thread aus.
- Bewahre die Datenbank im geeigneten Container der App und berücksichtige Hintergrundunterbrechungen unter iOS/iPadOS, den macOS-Lebenszyklus, App-Upgrades, Sicherungen und Dateischutzanforderungen der Plattform. Speichere sensible Daten nur mit ausdrücklich geprüfter Schutzregelung.
- Implementiere erforderliche entfernte Synchronisierung über die gewählte authentifizierte API beziehungsweise das Backend. Definiere inkrementelle Prüfpunkte, Wiederholungen mit Backoff, Idempotenz, Duplikatbehandlung, Löschweitergabe beziehungsweise Tombstones und einen für Nutzer sichtbaren Synchronisierungsstatus.
- Definiere das Konfliktverhalten je Datentyp: Server gewinnt, Client gewinnt, Zusammenführung auf Feldebene, Append-only- oder Event-Zusammenführung oder Auflösung durch Nutzer. Wähle keine allgemeine „last write wins“-Regel, ohne Zeitstempel, abweichende Uhren und gleichzeitige Änderungen auf Sicherheit zu prüfen.
- Stelle sicher, dass ein Kontowechsel keine lokalen Datensätze eines vorherigen Nutzers offenlegt. Lege fest, ob eine Abmeldung lokale Daten erhält, sperrt, löscht oder einreiht, und behandle ausstehende Schreibvorgänge konsistent.

## Webanwendungen: serverseitiges SQLite

- SQLite kann hinter einer serverseitigen API verwendet werden, wobei Datenbankdatei und Anwendungscode auf demselben Host beziehungsweise Speichersystem liegen. Clients müssen die API aufrufen; stelle niemals die Datenbankdatei bereit und akzeptiere kein beliebiges SQL von Clients.
- Bestätige, dass die Hostingplattform dauerhaften Dateispeicher, korrekte Dateisperren, Sicherung und Wiederherstellung sowie einen Betriebsprozess für Schemamigrationen bietet. Vergängliche Container-Dateisysteme dürfen nicht als dauerhafter Speicher behandelt werden.
- Beurteile konkurrierende Schreibzugriffe, gleichzeitige Anfragen, Datengröße, Deployment-Topologie und Skalierungsbedarf. SQLite erlaubt viele Leser, aber pro Datenbankdatei jeweils nur einen Schreibvorgang. Eine schreibarme Last mit einem Anwendungsserver kann passen; hohe Schreibkonkurrenz, mehrere Anwendungsinstanzen mit gemeinsamer Datei, direkter Zugriff über Netzwerkdateisysteme oder Wachstum über den geplanten Betriebsrahmen hinaus sprechen für eine Client-Server-Datenbank wie PostgreSQL.
- Halte API-Authentifizierung und Autorisierung je Nutzer oder Mandant an der Servergrenze. Eine gemeinsam genutzte SQLite-Datei ist kein Autorisierungsmodell.
- Nutze ausdrückliche Transaktionen, kurze Schreibtransaktionen, begrenzte Behandlung von Belegungszuständen und sichere parametrisierte Abfragen oder das gewählte ORM. Kopiere eine laufende Datenbankdatei niemals als Sicherung ohne konsistenten SQLite-Sicherungsmechanismus.
- Ist serverseitiges SQLite als primäres Backend gewählt, halte Entscheidung und Betriebsgrenzen in Projektbeschreibung beziehungsweise Architektur fest. Setze keine Kompatibilität mit mehreren Instanzen oder serverlosem Deployment voraus.

## Webanwendungen: SQLite im Browser mit WebAssembly

- Behandle SQLite im Browser als lokalen Speicher einer Browser-Origin beziehungsweise eines Browserprofils, nicht als gemeinsam genutzte Mehrbenutzerdatenbank oder automatische Sicherung. Synchronisierung, Export, Wiederherstellung und Sicherung muss die Anwendung gesondert gestalten.
- Prüfe die aktuelle SQLite-WASM-Implementierung und ihre offizielle Persistenzdokumentation. OPFS-basierte Konfigurationen haben Anforderungen an den Worker-Kontext; halte Datenbank-Ein- und -Ausgabe vom UI-Thread fern und prüfe die Unterstützung anhand der tatsächlichen Browsermatrix des Projekts.
- Wähle und dokumentiere den Persistenz- beziehungsweise VFS-Modus anhand von Browserunterstützung, Verhalten mehrerer Tabs, Sperren, erforderlichen Headern und Isolation sowie Produktbedarf. Setze keine identischen Anforderungen aller OPFS-Modi an Nebenläufigkeit oder Deployment voraus.
- Definiere das Verhalten, wenn OPFS, Worker, persistenter Speicher oder Browserkontingent nicht verfügbar sind. Biete eine unterstützte Ausweichlösung oder eine ausdrückliche nutzersichtbare Einschränkung; melde keinen erfolgreichen Speichervorgang, wenn die Speicherung fehlgeschlagen ist.
- Teste Neuladen, Tab-Duplizierung und -Nebenläufigkeit, Browserneustart, Speicherverweigerung oder Kontingentprobleme, Abmeldung und Kontowechsel sowie Schema-Upgrades. Berücksichtige Origin-Änderungen und browsergesteuerte Löschung als Datenverlustszenarien.
- Trenne nutzerspezifische Datensätze lokal nach authentifiziertem Konto und verhindere Datenlecks zwischen Konten. Speichere keine Geheimnisse, Zugangsdaten oder Autorisierungsentscheidungen in einer Client-Datenbank.

## Gestaltung der Synchronisierung

Wenn lokale und entfernte Speicher bestehen, dokumentiere vor der Implementierung den Synchronisierungsvertrag:

- Stabile Datensatz-IDs und Bindung an Eigentümer oder Mandant
- Lokale Darstellung ausstehender Operationen beziehungsweise der Outbox und dauerhafte Transaktionsgrenzen
- API-Vertrag, Authentifizierung, Paginierung, Delta-Cursor oder Prüfpunkt sowie Verhalten von Idempotenzschlüsseln
- Reihenfolge, Wiederholung und Backoff, Wiederherstellung nach teilweisem Fehler, mehrfache Zustellung und Abbruchverhalten
- Konfliktauflösung je Entität oder Feld und Darstellung abgelehnter Änderungen
- Weitergabe von Löschungen, Aufbewahrung, Datenexport und Verhalten bei Kontolöschung
- Synchronisierungsstatus und für Nutzer sichtbare Zusagen einschließlich der offline verfügbaren Funktionen

Führe lokale Schreibvorgänge und zugehörige ausstehende Synchronisierungsdatensätze atomar aus, wenn das Design eine Outbox verwendet. Gestalte Wiederholungen sicher. Ein erfolgreicher lokaler Schreibvorgang darf erst nach Bestätigung durch den Server als entfernt synchronisiert dargestellt werden. Vermeide destruktive vollständige Aktualisierungen, die noch nicht hochgeladene lokale Änderungen löschen können.

## Sicherheit und Datenschutz

- Betrachte jede lokale Datenbank als potenziell einsehbar für Personen mit Zugriff auf Gerät oder Browserprofil. Wende zur Sensibilität der Daten passende Speicherschutzmaßnahmen der Plattform an; behaupte Verschlüsselung nicht allein deshalb, weil Daten in SQLite oder OPFS liegen.
- Setze serverseitige Authentifizierung und Autorisierung unabhängig von lokaler Datenbank und UI durch. Prüfe die Eigentümerschaft bei Synchronisierung oder Annahme von Änderungen erneut.
- Vermeide Geheimnisse und unnötige personenbezogene Daten in Datensätzen, Debug-Logs, Fixtures und exportierten Datenbankdateien. Definiere Aufbewahrung und Löschung für lokale Kopien, Synchronisierungswarteschlangen, Serverdaten, Sicherungen und Exporte.
- Nutze `$dsgvo`, wenn personenbezogene Daten verarbeitet werden, und den gewählten Backend-Skill für entfernte API oder Datenbank.

## Verifikation

Wähle Prüfungen passend zur Plattform und zum abgestimmten Plan. Relevante Prüfungen können umfassen:

- Datenbank aus einer sauberen Installation und aus jeder unterstützten früheren Schemaversion erstellen, öffnen und migrieren.
- Constraints, Transaktions-Rollback, gleichzeitiges Lesen und Schreiben, Verhalten bei belegter oder gesperrter Datenbank und Wiederherstellung nach unterbrochener Operation testen.
- Lokales Verhalten bei deaktiviertem Netzwerk prüfen; anschließend Verbindung wiederherstellen und idempotente Synchronisierung sowie vereinbarte Konfliktregeln validieren.
- Konto- und Mandantentrennung, Abmeldeverhalten, Löschweitergabe und unberechtigte Serveranfragen prüfen.
- Verfügbarkeit von Browser-Workern und OPFS, Zielbrowser, mehrere Tabs, Kontingent- und Speicherfehler sowie Persistenz nach Neuladen und Neustart testen.
- Dauerhaftigkeit auf dem Server, Sicherungs- und Wiederherstellungsverfahren sowie Migrationen anhand einer lokalen oder Testkopie prüfen; richte Setup-Prüfungen nicht auf Produktion.
- Bestätigen, dass Sicherungen und Exporte konsistent sind und keine unbeabsichtigten Geheimnisse enthalten.

Führe destruktive Resets, Produktionsmigrationen oder Änderungen gehosteter Daten nicht ohne ausdrückliche Autorisierung für Umgebung und Aktion aus. Nutze `$verify-setup` für die Einsatzbereitschaft von Laufzeit und Umgebung, `$app-dev-swiftui`, `$app-dev-nextjs` oder `$app-dev-angular` für Plattformkonventionen und den gewählten Backend-Skill für entfernte Integration. Berichte ausgeführte und nicht ausgeführte Prüfungen, offene Entscheidungen und bekannte Speichergrenzen.

## Offizielle Dokumentation

Nutze die zur gewählten SQLite/WASM-Bibliothek und den Plattformversionen passende Dokumentation. Beginne mit:

- [Geeignete Anwendungsfälle für SQLite](https://www.sqlite.org/whentouse.html)
- [SQLite über ein Netzwerk: Einschränkungen und Hinweise](https://www.sqlite.org/useovernet.html)
- [Persistente Speicheroptionen für SQLite Wasm](https://sqlite.org/wasm/doc/trunk/persistence.md)
- [SQLite Online Backup API](https://www.sqlite.org/backup.html)
