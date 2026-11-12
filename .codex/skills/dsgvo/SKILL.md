---
name: dsgvo
description: Plant, implement, or review privacy-related behavior in native Apple and web apps that process personal data, with traceable assumptions and current authoritative sources.
---

# DSGVO und Datenschutz

Nutze diesen Skill, sobald eine Änderung personenbezogene Daten erhebt, verwendet, speichert, übermittelt, offenlegt oder löscht. Er unterstützt eine datenschutzbewusste technische Umsetzung; er ersetzt keine rechtliche Prüfung und stellt keine DSGVO-Konformität fest.

## 1. Verarbeitung und offene Entscheidungen erfassen

Lies Projektanweisungen, `.codex/PROJECT.md`, Spec, Plan und `.codex/rules/ARCHITECTURE.md`, sofern vorhanden. Untersuche die tatsächlichen Datenflüsse und erfasse für die betroffene Funktion mindestens:

- Zweck der Verarbeitung und betroffene Nutzergruppen
- Datenkategorien und ob besondere Kategorien, Kinder- oder andere sensible Daten betroffen sein könnten
- Erhebung, Verwendung, Speicherung, Empfänger, externe Dienste und Datenflüsse über Ländergrenzen
- Aufbewahrung, Löschung und gegebenenfalls Backups
- Zugriff, Rollen, Mandantentrennung, Berechtigungen und Schutzmaßnahmen
- Transparenz gegenüber Nutzern und relevante Betroffenenrechte
- Einwilligungen oder andere rechtliche Grundlagen, sofern sie für die Funktion eine Rolle spielen

Trenne belegte Fakten von Annahmen. Erfinde oder wähle keine Rechtsgrundlage, Aufbewahrungsfrist, Verantwortlichen-/Auftragsverarbeiterrolle, Drittland-Transfergrundlage oder DPIA-Entscheidung. Markiere fehlende rechtliche oder organisatorische Entscheidungen mit ihrer Auswirkung und leite sie an die zuständige Projektverantwortung, Datenschutzbeauftragte oder Rechtsberatung weiter.

## 2. Spec und Plan

Die Spec beschreibt das erforderliche Nutzerverhalten und, soweit relevant, Zweck, betroffene Daten, Empfänger, Aufbewahrung/Löschung, Transparenz, Rechte, Einwilligungsabläufe und Fehlerfälle. Technische Umsetzungsentscheidungen gehören in den Plan.

Der Plan soll für die Änderung passende Maßnahmen berücksichtigen:

- Datenminimierung und datenschutzfreundliche Voreinstellungen
- Zugriffskontrolle, Authentifizierung, Mandantentrennung und Autorisierung an allen relevanten Grenzen
- sichere Übertragung und Speicherung, angemessene Schlüssel- und Geheimnisverwaltung
- Begrenzung personenbezogener Daten in Telemetrie, Analytik, Fehlermeldungen und Logs
- Ablauf für Auskunft, Berichtigung, Export, Widerruf oder Löschung, soweit von der Funktion betroffen
- Verhalten bei Ausfällen, unvollständigen Daten, abgelehnter Berechtigung und externen Dienstfehlern

Leite keine pauschale neue Architektur oder Verarbeitung aus diesem Skill ab. Folge bestehenden Projektkonventionen und begründe notwendige Änderungen.

## 3. Plattformspezifische Umsetzung

- **Native Apple-Apps:** Prüfe Berechtigungen, Datenspeicherung, Synchronisation, Logs und App-Lifecycle im Kontext der unterstützten Apple-Plattformen. Eine Betriebssystem-Berechtigungsabfrage ist nicht automatisch eine DSGVO-Einwilligung. Erfasse nur benötigte Daten und erkläre Berechtigungsanfragen mit ihrem konkreten Zweck.
- **Next.js:** Prüfe Datenflüsse zwischen Browser, Server Components/Route Handlern, APIs und Backend. Halte geheime Schlüssel und privilegierte Zugriffe serverseitig; gib personenbezogene Daten nur aus, wenn die Autorisierung für den konkreten Nutzer und Zweck geprüft ist.
- **Angular:** Prüfe Datenflüsse zwischen Browser, Angular-Anwendung, APIs und Backend. Betrachte Browser-Code als öffentlich, halte Geheimnisse und privilegierte Zugriffe serverseitig und setze serverseitige Autorisierung unabhängig von UI- oder Routen-Guards durch.

## 4. Verifikation

Prüfe die relevanten Spec-Kriterien und dokumentiere Nachweise. Je nach Änderung können Checks Folgendes umfassen:

- Zugriff durch berechtigte und unberechtigte Nutzer sowie Mandantentrennung
- Speicher-, Export- und Löschverhalten der betroffenen Daten
- Umgang mit Berechtigungsablehnung, Widerruf und nicht verfügbaren Diensten
- Logs, Analytik, Fehlermeldungen, Netzwerkanfragen und Client-Bundles auf unnötige personenbezogene Daten oder offengelegte Geheimnisse
- wirksame Einwilligungs- und Widerrufsabläufe, sofern sie implementiert werden

Behaupte nicht, organisatorische oder rechtliche Compliance technisch bewiesen zu haben. Weise nicht ausgeführte Checks, bekannte Einschränkungen und offene Rechts-/Betriebsentscheidungen explizit aus.

## 5. Aktuelle Rechts- und Plattformquellen

Rechtliche Anforderungen, Leitlinien und Plattformregeln können sich ändern. Wenn eine konkrete rechtliche Aussage, Einwilligungsanforderung, Aufbewahrungsfrist, Drittlandübermittlung oder aktuelle Store-/Browserregel die Lösung beeinflusst:

1. Prüfe den aktuellen Wortlaut der DSGVO und einschlägige Leitlinien des Europäischen Datenschutzausschusses (EDPB) sowie gegebenenfalls die zuständige nationale Aufsichtsbehörde.
2. Nutze für Apple- oder Web-Plattformregeln die aktuelle offizielle Dokumentation des jeweiligen Anbieters.
3. Nenne Quelle und Prüfdatum in der Antwort oder im dauerhaften Entscheidungsartefakt. Wenn aktuelle Quellen nicht geprüft werden können, markiere die Aussage als ungeprüft und fahre bei entscheidungsrelevanter Unsicherheit nicht mit einer erfundenen Rechtsannahme fort.

Ausgangspunkt sind der [DSGVO-Text auf EUR-Lex](https://eur-lex.europa.eu/eli/reg/2016/679/oj?locale=de), die [EDPB-Leitlinien 4/2019 zu Datenschutz durch Technikgestaltung und datenschutzfreundlichen Voreinstellungen](https://www.edpb.europa.eu/documents/guideline/guidelines-42019-on-article-25-data-protection-by-design-and-by-default_en) und – falls Einwilligung relevant ist – die [EDPB-Leitlinien 05/2020 zur Einwilligung](https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-052020-consent-under-regulation-2016679_en).
