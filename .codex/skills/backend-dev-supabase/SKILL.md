---
name: backend-dev-supabase
description: Plant, implementiert oder prüft Supabase-Änderungen an Datenbank, Authentifizierung, Autorisierung, Storage und Edge Functions anhand des bestehenden Schemas und Deployment-Workflows.
---

# Backend-Entwicklung mit Supabase

Kläre vor Erstellung eines Backends gemäß `.codex/rules/ARCHITECTURE.md` Backend-Art und Hostingvorgaben. Supabase allein erfordert weder eine Swagger-Entscheidung noch eine Swagger-Implementierung. Wird zusätzlich eine separate NestJS- oder C#-API gewählt, gelten deren Regeln zur Swagger-Entscheidung und zum Schutz. Schütze tatsächlich bereitgestellte Swagger UI und OpenAPI-Dokumente vor öffentlichem und unberechtigtem Zugriff.

Nutze diesen Skill, wenn ein Projekt Supabase für Backend-Funktionen verwendet. Er unterstützt Clients mit SwiftUI, Next.js und Angular. Folge bei größeren Änderungen der abgestimmten Spec und dem Plan; nutze `$spec-driven-development` und `$feature-planning`, wenn Anforderungen oder Umfang zuerst geklärt werden müssen.

## Wann verwenden

- Supabase ist für das Projekt als Backend gewählt oder bereits im Einsatz und soll eingerichtet, erweitert oder geprüft werden.
- Datenbankschema, Migrationen, Grants oder Row Level Security eines Supabase-Projekts planen, ändern oder prüfen.
- Supabase Auth, Storage, Edge Functions oder die Anbindung eines Clients an Supabase umsetzen oder überprüfen.

**Nicht verwenden, wenn:**

- Das Projekt kein Supabase verwendet oder vorsieht und die Aufgabe keine Supabase-Auswahl oder -Integration umfasst. Nutze für einen vereinbarten anderen Backend-Stack den entsprechenden Skill.
- Ausschließlich lokale SQLite-Persistenz ohne Supabase-Anbindung bearbeitet wird; nutze dafür `$backend-dev-sqlite-data`.
- Es ausschließlich um Gestaltung oder Verhalten einer Oberfläche ohne Bezug zu Supabase geht; nutze den passenden Plattform- oder UI-Skill.

## Bestehendes Projekt untersuchen

1. Lies Projektanweisungen, `.codex/PROJECT.md`, relevante Specs und Pläne sowie `docs/data-model.md`, sofern vorhanden.
2. Prüfe die Version der Supabase CLI, `supabase/config.toml`, Migrationshistorie, Schemadateien, Seeds, SQL-Tests, generierte Typen, Client-SDKs und den Deployment-Workflow.
3. Ermittle, ob das Projekt imperative Migrationen, deklarative Schemata oder einen anderen etablierten Datenbank-Workflow verwendet. Behalte ihn bei; vermische Verfahren zur Schemaverwaltung nicht ohne ausdrücklichen Plan.
4. Ermittle lokale, Entwicklungs-, Staging-/Preview- und Produktionsprojekte. Stelle vor Ausführung von Befehlen fest, welche Datenbank und Zugangsdaten sie verwenden. Gib geheime Werte niemals aus, committe sie nicht und lege sie nicht offen.
5. Ziehe die aktuelle offizielle Supabase-Dokumentation hinzu, wenn das Verhalten von CLI-/SDK-Version, Postgres-Version, Sicherheitsfunktionen oder Anbieterkonfiguration abhängt.

Nutze `$verify-setup`, wenn die Einsatzbereitschaft von lokaler Laufzeit, CLI, Konfiguration, vorhandenen Zugangsdaten oder Umgebungstrennung geprüft werden muss.

## Datenbankschema und Migrationen

- Modelliere nur die von der Spec benötigten Daten. Halte Eigentümerschaft, Beziehungen, Constraints, Indizes und Löschverhalten im Schema und in `docs/data-model.md` ausdrücklich fest, sofern das Projektdokument existiert.
- Mache Schema- und Policy-Änderungen über den etablierten Migrations- oder deklarativen Workflow des Repositorys reproduzierbar. Prüfe generiertes SQL, statt es ungeprüft zu übernehmen.
- Halte Migrationen nach Möglichkeit mit der Release-Reihenfolge kompatibel: Berücksichtige alte und neue Anwendungsversionen während des Rollouts, Nachbefüllungen, Sperren und Datenaufbewahrung.
- Verwende für Seeds ausschließlich synthetische oder anderweitig autorisierte Nichtproduktionsdaten. Kopiere personenbezogene Produktionsdaten nur in lokale oder Preview-Umgebungen, wenn das Projekt dafür einen freigegebenen, geschützten Prozess besitzt.
- Generiere Datenbanktypen mit dem konfigurierten Projektbefehl neu, wenn Schemaänderungen dies erfordern; prüfe den resultierenden Diff.

## Sicherheit und Row Level Security

- Betrachte die Datenbankautorisierung unabhängig von Client-UI, Route-Guards oder Anwendungsprüfungen als Sicherheitsgrenze.
- Prüfe für über Supabase-APIs bereitgestellte Tabellen sowohl Grants als auch RLS. Aktiviere RLS und definiere minimal erforderliche Grants und Policies für die tatsächlich benötigten Operationen und Rollen.
- Prüfe erlaubten und abgelehnten Zugriff: anonyme und authentifizierte Nutzer, unterschiedliche Nutzer-IDs und gegebenenfalls Mandantengrenzen. Teste `SELECT`, `INSERT`, `UPDATE` und `DELETE` nur dort, wo diese Operationen vorgesehen sind.
- Vermeide weitreichende Policies wie bedingungslosen Zugriff, sofern öffentlicher Zugriff keine ausdrückliche Produktanforderung ist. Prüfe Views, Funktionen, RPCs und `SECURITY DEFINER`-Code auf Umgehung von Berechtigungen oder RLS.
- Ein Publishable Key oder früherer Anon Key ersetzt keine Autorisierung. Secret Keys beziehungsweise frühere Service-Role Keys umgehen den normalen RLS-Schutz; verwahre sie nur in vertrauenswürdigen Server- oder Funktionsumgebungen, niemals im Browser oder nativen Client-Code.

## Authentifizierung und Nutzerdaten

- Implementiere nur die Authentifizierungsmethoden und den Kontolebenszyklus, die Spec und bestehendes Projekt benötigen.
- Speichere nutzerbezogene Profil- und Anwendungsdaten in projekteigenen Tabellen mit ausdrücklichen Fremdschlüsseln, Grants und RLS. Stelle das interne Supabase-Schema `auth` nicht über Anwendungs-APIs bereit.
- Halte einen verwendeten Registrierungs-Trigger oder eine andere automatische Bereitstellung schlank und teste das Fehlerverhalten, da ein fehlgeschlagener Trigger die Registrierung blockieren kann. Folge dem etablierten Verfahren zur Profilbereitstellung, statt standardmäßig einen Trigger einzuführen.
- Berücksichtige relevante Lebenszyklusfälle wie E-Mail-Verifizierung, Sitzungsaktualisierung, Abmeldung, Kontolöschung und verwaiste Daten, soweit sie zum Umfang gehören.

## Storage und Edge Functions

- Definiere für Storage nach Bedarf Bucket-Sichtbarkeit und Policies je Operation für Hochladen, Lesen, Aktualisieren oder Überschreiben sowie Löschen. Begrenze Zugriff gegebenenfalls nach Nutzer, Mandant und Objektpfad; mache einen Bucket nicht allein zur einfacheren Bereitstellung öffentlich.
- Validiere Dateitypen, Größen, Eigentümerschaft und Verarbeitungsanforderungen an der passenden Vertrauensgrenze. Nutze signierten Zugriff, wenn Dateien nicht öffentlich sein sollen.
- Nutze Edge Functions oder eine andere etablierte serverseitige Grenze, wenn die Funktion Geheimnisse, privilegierte Operationen, Webhooks oder ausschließlich serverseitige Integrationslogik benötigt. Prüfe Identität und Autorisierung in der Funktion selbst.
- Halte lokale Funktionsgeheimnisse aus Git heraus und konfiguriere gehostete Geheimnisse über den freigegebenen Secret Store des Projekts. Gib geheime Werte niemals im Terminal oder in Berichten aus.

## Client- und Framework-Grenzen

- Richte die Nutzung von Plattform-SDKs an bestehenden SwiftUI-, Next.js- oder Angular-Mustern und SDK-Versionen aus.
- Beachte in Next.js die Grenzen zwischen Server Components, Client Components und Laufzeiten; privilegierte Operationen und Service Keys bleiben serverseitig.
- Betrachte gebündelten Code und Client Keys in Angular- und SwiftUI-Clients als öffentlich. Setze sensiblen Zugriff mit RLS und vertrauenswürdigem serverseitigem Code durch.
- Vermeide, geschäftliche Autorisierungsregeln ausschließlich im Client abzubilden. Datenbank-Policies oder das vertrauenswürdige Backend müssen den Zugriff durchsetzen.

## Verifikation und Änderungen an entfernten Projekten

Wähle Prüfungen passend zur Änderung und zur bestehenden Testumgebung. Relevante Prüfungen können umfassen:

- Migrationen auf das lokale Supabase-Projekt anwenden beziehungsweise es damit neu aufbauen und das Schema aus einem sauberen Zustand bestätigen.
- RLS und Grants mit erlaubten und abgelehnten Identitäten anhand vorhandener SQL-Tests oder des konfigurierten Projekt-Testbefehls prüfen.
- Bei betroffenen Änderungen Registrierung und Profilbereitstellung, Sitzungsverhalten, Storage-Zugriff und Edge-Function-Autorisierung prüfen.
- Generierte Typen sowie den Client-Build und die Tests validieren, die sie verwenden.
- Vor gehosteten Änderungen Migrationsziel prüfen und Umgebungen vergleichen.

Schemaänderungen auf entfernten Systemen, Änderungen an Produktionsdaten oder Geheimnissen und destruktive Reset-Befehle können externe oder irreversible Auswirkungen haben. Führe sie nur aus, wenn der Nutzer Umgebung und Aktion ausdrücklich autorisiert hat. Bevorzuge zunächst lokale Verifikation; leite eine Autorisierung nicht aus einem Auftrag zur Codeimplementierung ab.

Nutze `$dsgvo`, wenn personenbezogene Daten verarbeitet werden, und `$deploy`, wenn Supabase-Änderungen Teil eines Releases sind. Berichte ausgeführte Prüfungen, offene Risiken und nicht ausgeführte Prüfungen.

## Offizielle Dokumentation

Nutze die Dokumentation passend zu den aktuellen CLI-, SDK- und Postgres-Versionen des Projekts. Nützliche Einstiege sind:

- [Lokale Entwicklung und CLI](https://supabase.com/docs/guides/local-development)
- [Datenbankmigrationen und CLI-Workflow](https://supabase.com/docs/guides/local-development/cli-workflows)
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Nutzerdaten verwalten](https://supabase.com/docs/guides/auth/managing-user-data)
- [Storage-Zugriffskontrolle](https://supabase.com/docs/guides/storage/security/access-control)
- [Geheimnisse für Edge Functions](https://supabase.com/docs/guides/functions/secrets)
