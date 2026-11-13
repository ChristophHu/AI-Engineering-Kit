# Backend- und Speicherentscheidung: <Projekt oder Vorhaben>

Diese Vorlage dient zur Dokumentation einer anstehenden oder bestehenden Architekturentscheidung. Nutze vorhandene Architekturunterlagen, wenn das Projekt bereits einen passenden Ort hat, und verlinke sie aus Spec oder Plan. Fülle nur relevante Abschnitte aus; kennzeichne Unbekanntes als offen und nicht zutreffende Punkte als „nicht relevant“. Keine Zugangsdaten oder geheimen URLs eintragen.

## Ausgangslage und Entscheidung

- **Status und Datum:** <offen / entschieden / zu überprüfen; Datum>
- **Entscheidung durch:** <Entwickler bzw. verantwortliche Person und Bezug zur Entscheidung>
- **Quellen:** <Projektbeschreibung, bestehende Architektur, Spec, relevante Vorgaben>
- **Anforderungen:** <Nutzer, gemeinsame oder lokale Daten, Offlinebedarf, Schnittstellen, Skalierung und Betrieb>
- **Gewählte Architektur:** <kein Backend / bestehendes Backend / Supabase / NestJS mit PostgreSQL / C# mit SQL Server / API mit serverseitigem SQLite / andere>
- **Begründung und Folgen:** <warum passt die Wahl zu Anforderungen, Betrieb und vorhandener Architektur?>
- **Abweichungen oder Widersprüche:** <Vorgabe, Rückfrage an Entwickler, ausdrückliche Entscheidung und Auswirkung; sonst nicht relevant>

## Alternativen

| Alternative | Vorteile und Eignung | Nachteile oder Ausschlussgrund |
|---|---|---|
| <geprüfte Alternative> | <Bezug zu Anforderungen und Hosting> | <Begründung> |

## Daten, Speicher und Datenhoheit

- **Speicherort und Zweck je Datenkategorie:** <Gerät/App-Container, Browser-Origin, Server oder verwalteter Dienst; führende Daten, Cache oder Offline-Arbeitskopie>
- **Datenhoheit und Zugriff:** <wer ist verantwortlich, welche Nutzer oder Dienste dürfen lesen und schreiben, welche Instanz ist führend?>
- **Lokale-only Speicherung:** <wenn gewählt: Geräte-/Browserbindung, Export, Sicherung und Verhalten bei Verlust; sonst nicht relevant>
- **Synchronisierung:** <erforderlich oder nicht; Gegenstellen, Offline-Änderungen, Konflikte und Löschungen; keine automatische Synchronisierung annehmen>
- **Serverseitiges SQLite:** <API-Zugriff, dauerhafter Speicher, Schreibkonkurrenz, Datei-Sperren, Hostingtopologie sowie Backup und Wiederherstellung; sonst nicht relevant>
- **Browser-SQLite:** <Browser-/Worker-Anforderungen, Persistenz, Kontingent und Verlustverhalten; lokale Daten sind nicht automatisch gemeinsam oder synchronisiert>

## Hosting und Umgebungen

- **Betriebsmodell und Zielplattform:** <verwalteter Dienst / eigener Server / Container; Betriebssystem und Laufzeit>
- **Backend und Datenbank:** <Technologien, Versionen soweit bekannt, Standort/Region und Zuständigkeiten>
- **Entwicklung, Test und Produktion:** <Trennung und Auswahl der Ziele ohne Zugangsdaten>
- **Besondere Vorgaben:** <NestJS: unterstützte Node.js-Laufzeit; C#: bevorzugt Windows Server/IIS; bei C# auf Linux ausdrückliche Bestätigung des Entwicklers dokumentieren>

## Swagger / OpenAPI

- **Entscheidung des Entwicklers:** <bei NestJS-/C#-API: Swagger/OpenAPI mit visueller UI als empfohlene Standardauswahl oder ausdrücklicher Verzicht; Quelle der Entscheidung. Supabase und SQLite allein: keine Entscheidung erforderlich>
- **Bei Verzicht:** <Grund und gegebenenfalls Alternative; sonst nicht relevant>
- **Berechtigter Zugang:** <Personen/Rollen, Authentifizierung und Autorisierung; Zugriffspfad für berechtigte Personen>
- **Schutz von UI und OpenAPI-Dokument:** <Schutzmechanismus und Vertrauensgrenze für beide Endpunkte; öffentlich und für Unbefugte nicht erreichbar>
- **Produktionsverhalten und Nachweis:** <bei Bereitstellung: aktiviert und geschützt oder deaktiviert; aktivierte Endpunkte auf zulässigen, unzulässigen und öffentlichen Zugriff, deaktivierte auf Nichterreichbarkeit prüfen; sonst nicht relevant>

## Offene Punkte und Übergabe

| Frage oder Risiko | Auswirkung | Verantwortlich / nächster Schritt | Status |
|---|---|---|---|
| <Punkt> | <Auswirkung> | <Person oder Aufgabe> | <offen / geklärt> |

Vor Erstellung eines Backends müssen Backend-Art und wesentliche Hostingvorgaben geklärt sein; für NestJS- und C#-APIs zusätzlich die ausdrückliche Swagger-Entscheidung, auch wenn SQLite als Datenbank dient. Widersprüche werden mit dem Entwickler geklärt; dokumentiere vereinbarte Entscheidungen und verlinke dieses Dokument im Plan. Bei relevanter SQLite-Synchronisierung den Sync-Vertrag im Plan oder in den vorhandenen Architekturunterlagen konkretisieren.
