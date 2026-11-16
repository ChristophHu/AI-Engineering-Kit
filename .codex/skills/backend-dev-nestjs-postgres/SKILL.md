---
name: backend-dev-nestjs-postgres
description: Plant, implementiert oder prüft eine NestJS-API mit PostgreSQL einschließlich Authentifizierung, Autorisierung, Schemamigrationen und geschützter Swagger/OpenAPI-Dokumentation.
---

# Backend-Entwicklung mit NestJS und PostgreSQL

Nutze diesen Skill, wenn die Projektbeschreibung oder die bestehende Codebasis ein NestJS-Backend mit PostgreSQL vorsieht. Er eignet sich besonders für Webanwendungen mit separat betriebener API. Folge bei größeren Änderungen der abgestimmten Spec und dem Plan; nutze `$spec-driven-development` und `$feature-planning`, wenn Anforderungen oder Umfang zuerst geklärt werden müssen. Ersetze Supabase oder ein anderes bestehendes Backend nicht ohne ausdrückliche Projektentscheidung durch diesen Stack.

## Bestehendes Projekt untersuchen

1. Lies Projektanweisungen, `.codex/PROJECT.md`, relevante Specs und Pläne sowie Datenmodell- und Deployment-Dokumentation.
2. Prüfe die bereits eingesetzten Versionen und Konventionen für NestJS, Node.js, TypeScript, Paketverwaltung, PostgreSQL, ORM oder Query-Builder, Migrationen, Validierung, Authentifizierung und Tests. Bewahre bestehende Entscheidungen, sofern der abgestimmte Plan keine Änderung vorsieht.
3. Ermittle lokale, Entwicklungs-, Staging-/Preview- und Produktionsumgebungen sowie deren Auswahl. Bestimme Datenbankziele vor der Ausführung von Befehlen; lege keine Zugangsdaten offen.
4. Prüfe die für die Aufgabe relevanten Modulgrenzen, Controller, Provider, DTOs, Guards, Interceptors, Ausnahmebehandlung, Datenbankzugriffe, Migrationen, Seeds sowie CI- und Deployment-Konfiguration.
5. Ziehe aktuelle offizielle Dokumentation zu NestJS, PostgreSQL und dem gewählten ORM oder Werkzeug hinzu, wenn das Verhalten von Version oder Konfiguration abhängt.

## API- und Modulgestaltung

- Ordne Module nach Produktverantwortlichkeiten und beschränke Controller auf HTTP-Aufgaben. Hinterlege Geschäftsregeln in Providern oder Services und Datenbankzugriffe hinter klaren Persistenzgrenzen entsprechend der Codebasis.
- Definiere DTOs für Anfragen und Antworten; validiere und transformiere nicht vertrauenswürdige Eingaben an der API-Grenze. Vermeide Datenbankentitäten als öffentliche Antwortverträge.
- Verwende einheitliche HTTP-Semantik, Paginierung, Fehlerformate und API-Versionierung, soweit das Projekt sie benötigt. Gib Stacktraces, SQL-Details oder interne Kennungen nicht ohne Produktbedarf preis.
- Halte Geheimnisse und privilegierte Operationen auf dem Server. Betrachte Browser- und nativen Client-Code als öffentlich und setze Autorisierung unabhängig von clientseitigen Route-Guards oder UI-Zuständen in der API durch.

## PostgreSQL-Schema und Migrationen

- Modelliere nur Daten, die die Spec benötigt. Halte Eigentümerschaft, Beziehungen, Constraints, Indizes, Löschverhalten und Mandantengrenzen ausdrücklich fest; aktualisiere `docs/data-model.md`, sofern vorhanden.
- Nutze das bestehende Migrationswerkzeug und den Workflow des Repositorys. Gestalte Schemaänderungen reproduzierbar; prüfe erzeugte Migrationen und berücksichtige Nachbefüllung, Sperrdauer und Kompatibilität mit bereitgestellten Anwendungsversionen.
- Trenne Entwicklungs-, Preview- und Produktionsdatenbanken entsprechend der vereinbarten Umgebungsstrategie. Verwende für Seeds ausschließlich synthetische oder anderweitig autorisierte Nichtproduktionsdaten.
- Verwende parametrisierte Abfragen oder sichere Abfrage-APIs des gewählten ORM. Nutze Transaktionen und Datenbank-Constraints, soweit für Korrektheit erforderlich; verlasse dich bei durch die Datenbank durchsetzbaren Invarianten nicht allein auf Prüfungen der Anwendung.
- Hinterlege Datenbank-URLs und Passwörter in vertrauenswürdiger Umgebungskonfiguration oder einem freigegebenen Secret Store. Lege sie niemals in Browser-Bundles, Logs, Berichten oder der Versionsverwaltung ab.

## Authentifizierung und Autorisierung

- Implementiere nur die Authentifizierungsmethoden und das Kontolebenszyklusverhalten, die Spec und bestehendes Projekt benötigen. Halte fest, ob diese API oder ein separat ausgewählter Identitätsanbieter Identitäten verwaltet; setze keinen Anbieter voraus.
- Authentifiziere jede geschützte Anfrage und setze Autorisierung auf Ressourcenebene serverseitig durch. Prüfe bei jeder relevanten Operation Objektzugehörigkeit und Mandantenmitgliedschaft; ein gültiges JWT oder ein Rollenname allein berechtigt nicht zum Zugriff auf beliebige Datensätze.
- Nutze etablierte, zum gewählten Authentifizierungsdesign passende Verfahren für Passwort-Hashing, Sitzungs- und Tokenvalidierung, Rotation, Ablauf und Widerruf. Protokolliere niemals Zugangsdaten, Tokens, Autorisierungsheader oder sensible personenbezogene Daten.
- Berücksichtige relevante abgelehnte Zugriffe ebenso wie erfolgreiche Operationen. Halte Autorisierungsentscheidungen unabhängig vom Zugriffsschutz der Swagger UI.

## Geschütztes Swagger / OpenAPI

- Kläre vor Erstellung eines Backends nach `.codex/rules/ARCHITECTURE.md` Backend-Art, Hosting und die ausdrückliche Swagger/OpenAPI-Entscheidung des Entwicklers. Empfiehl Swagger/OpenAPI mit visueller Swagger UI als Standard; beachte eine bereits vereinbarte Entscheidung und dokumentiere einen Verzicht, dessen Grund und eine etwaige Alternative. Fahre mit der Erstellung nicht fort, solange diese Entscheidung offen ist. Beschreibe bei bereitgestellter Dokumentation DTO-Schemata, Authentifizierungsschemata, relevante Erfolgs- und Fehlerantworten sowie Versionierung korrekt.
- **Swagger UI und jeder bereitgestellte OpenAPI-JSON- oder Dokumentendpunkt dürfen nicht öffentlich erreichbar sein.** Setze einen nicht öffentlichen Netzwerkzugang, etwa VPN oder privaten Ingress, und ausdrückliche serverseitige Authentifizierung und Autorisierung für vorgesehene Betreiber durch. Authentifizierung allein macht eine öffentliche URL nicht privat. Verlasse dich nicht auf eine versteckte URL, CORS, Frontend-Routing oder einen undokumentierten Query-Token.
- Deaktiviere Dokumentationsendpunkte standardmäßig in Produktion, sofern das freigegebene Deployment-Design keinen geschützten, nicht öffentlichen Zugriff ausdrücklich vorsieht. Prüfe bei aktivierten Endpunkten erlaubte und abgelehnte Zugriffe; prüfe bei deaktivierten, dass beide Endpunkte nicht erreichbar sind.
- Vermeide Geheimnisse, echte Zugangsdaten, interne Hostnamen und sensible Beispieldaten im OpenAPI-Dokument. Verwende unkritische Beispiele und deklariere Bearer- oder API-Authentifizierungsschemata ohne echte Tokens.
- Dokumentiere, wie berechtigte Entwickler und Betreiber die UI erreichen. Erfolgt die Zugriffskontrolle über einen Ingress oder identitätsbewussten Proxy, dokumentiere diese Abhängigkeit und prüfe, dass die Anwendung in der vorgesehenen Deployment-Topologie nicht daran vorbei erreichbar ist.

## Verifikation

Wähle Prüfungen passend zur Änderung und zur bestehenden Repository-Konfiguration. Relevante Prüfungen können umfassen:

- Migrationen auf eine saubere lokale oder Testdatenbank anwenden und das resultierende Schema bestätigen; Migrationsreihenfolge und, soweit unterstützt, Rückfallstrategie prüfen.
- Unit- und Integrationstests für geänderte Services, Controller, Validierung, Transaktionen und Fehlerzuordnung ausführen.
- Authentifizierte und nicht authentifizierte Anfragen, Eigentümer- und Mandantengrenzen sowie erwartete abgelehnte Operationen prüfen.
- Falls Swagger bereitgestellt wird, bei aktivierten Endpunkten berechtigten sowie abgelehnten anonymen und unberechtigten Zugriff auf UI und Dokument einschließlich nicht öffentlichem Netzwerkzugang prüfen; bei deaktivierten prüfen, dass beide nicht erreichbar sind.
- Falls bereitgestellt, das erzeugte OpenAPI-Dokument gegen aktuelle DTOs und das Authentifizierungsverhalten validieren.
- Backend-Build und Frontend-Integration gegen den API-Vertrag prüfen.
- Bestätigen, dass die Umgebungskonfiguration die vorgesehene Datenbank verwendet, ohne URL oder Zugangsdaten offenzulegen.

Führe destruktive Datenbank-Resets, Produktionsmigrationen, Änderungen an Produktionsdaten oder Geheimnissen nicht ohne ausdrückliche Autorisierung für Umgebung und Aktion aus. Bevorzuge zunächst lokale oder Testprüfungen. Nutze `$verify-setup` für die Einsatzbereitschaft von Laufzeit, CLI, Konfiguration und Umgebung, `$dsgvo` bei Verarbeitung personenbezogener Daten und `$deploy` für Release- und Deployment-Arbeiten. Berichte ausgeführte Prüfungen, offene Risiken und nicht ausgeführte Prüfungen.

## Offizielle Dokumentation

Nutze die zu den installierten Versionen passende Dokumentation. Beginne mit:

- [NestJS OpenAPI](https://docs.nestjs.com/openapi/introduction)
- [NestJS-Authentifizierung](https://docs.nestjs.com/security/authentication)
- [NestJS-Autorisierung](https://docs.nestjs.com/security/authorization)
- [NestJS-Validierung](https://docs.nestjs.com/techniques/validation)
- [PostgreSQL-Dokumentation](https://www.postgresql.org/docs/)
