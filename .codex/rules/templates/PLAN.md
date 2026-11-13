# Implementierungsplan: <Titel>

## Bezug zur Spec
Pfad/Link zur Spec und wichtige Entscheidungen.

## Plattform und Architekturentscheidungen
Plattform(en), betroffene Komponenten und begründete technische Entscheidungen. Nur relevante Punkte ausfüllen.

- Backend-Art und Hosting (einschließlich Serverbetriebssystem):
- Bei abweichenden oder widersprüchlichen Vorgaben: Entscheidung des Entwicklers und Begründung:
- Bei NestJS-/C#-API: ausdrückliche Swagger-Entscheidung (empfohlener Standard: Swagger/OpenAPI mit UI), gegebenenfalls Verzichtsgrund und Alternative; bei Bereitstellung Zugangsschutz, Umgebungen und Prüfung für UI und Dokument. Bei Supabase oder SQLite allein nicht erforderlich:

### Native Apple-App
- UI-Technologie und Deployment-Ziel:
- Navigation und Zustandsverwaltung:
- Persistenz und Backend-Zugriff:
- Berechtigungen und Apple-Frameworks:
- Lebenszyklus und Systemintegration:

### Web-App
- Framework und Laufzeit (z. B. Next.js oder Angular):
- Rendering- und Routing-Modell:
- Komponenten- und Datenfluss:
- APIs, Authentifizierung und Vertrauensgrenzen:
- Unterstützte Browser und Viewports:
- Hosting und Deployment:

## Startfreigabe vor Implementierung
- [ ] Plattform und Architekturentscheidungen sind begründet.
- [ ] Datenflüsse, Vertrauensgrenzen, Berechtigungen und Integrationen sind verstanden.
- [ ] Offene Entscheidungen sind geklärt oder als Annahmen mit Auswirkung festgehalten.
- [ ] Abnahmekriterien sind prüfbar und durch Plan-Schritte sowie Nachweise abgedeckt.

## Schritte
Aufgaben und Status können hier stehen. Wenn ein vorhandenes Aufgabensystem maßgeblich ist, verlinke die Aufgaben und ihren Status dort; führe keinen zweiten Aufgabenstatus.

1. [ ] <Ergebnis/Änderung> — Kriterien: <IDs> — Verifikation: <Nachweis> — Abhängigkeiten (falls relevant): <Aufgaben/keine>
2. [ ] <Ergebnis/Änderung> — Kriterien: <IDs> — Verifikation: <Nachweis> — Abhängigkeiten (falls relevant): <Aufgaben/keine>

## Abhängigkeiten und Risiken
-

## Verifikation
- [ ] <gezielter Test/Check>
- [ ] <manuelle Prüfung, falls nötig>
- [ ] Relevante plattformspezifische Abschlusschecks aus `.codex/rules/ARCHITECTURE.md` sind eingeplant.

## Abweichungen
Während der Umsetzung erkannte notwendige Änderungen und Begründungen.
