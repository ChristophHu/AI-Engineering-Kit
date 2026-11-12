---
name: app-dev-nextjs
description: Plant, implementiert oder prüft Funktionen einer bestehenden Next.js-Anwendung unter Beachtung ihrer Version, ihres Routers, ihrer Laufzeit und Projektkonventionen.
---

# Next.js-App-Entwicklung

Nutze diesen Skill für Arbeiten in einem Next.js-Projekt. Beginne mit der abgestimmten Spec und dem Plan, sofern vorhanden; nutze bei größeren Aufgaben zuerst `$spec-driven-development` und `$feature-planning`.

## Projekt vor Änderungen untersuchen

1. Lies die Projektanweisungen, `.codex/PROJECT.md` und, falls vorhanden, `docs/design-system.md`.
2. Untersuche `package.json`, Lockdatei, Next.js-Version, Skripte, Konfiguration, Routenbaum sowie relevante Komponenten und Tests.
3. Ermittle, ob das Projekt App Router, Pages Router oder eine bewusste Kombination verwendet; bestimme Laufzeit, Rendering, Datenabruf, Authentifizierung und Deployment-Vorgaben.
4. Beachte bestehende Konventionen. Migriere keine Router, ändere keine Rendering-Strategie und füge keine Zustands- oder Datenbibliothek ohne Anforderung und ausdrücklichen Plan hinzu.

## Planen und umsetzen

Berücksichtige für die jeweilige Funktion die relevanten Bereiche:

- Grenzen zwischen Server- und Client-Komponenten und Ausführungsort des Codes
- Rendering-Strategie, Routing, Layouts, Metadaten und Navigation
- Datenabruf, Änderungen, Caching und Invalidierung
- Lade-, Fehler-, Leer- und Nicht-gefunden-Zustände
- Authentifizierung und Autorisierung über Browser-, Server-, API- und Backend-Grenzen hinweg
- Laufzeitkompatibilität sowie Umgang mit Geheimnissen und ausschließlich serverseitigen Abhängigkeiten
- bei SQLite: serverseitiges SQLite hinter einer API von browserlokalem SQLite/WASM unterscheiden; OPFS-, Worker- und Browserbedingungen sowie einen etwaigen Synchronisationsvertrag mit `$backend-dev-sqlite-data` planen
- responsives Verhalten und Barrierefreiheit betroffener Routen und Komponenten

Halte privilegierte Zugriffe und Geheimnisse auf dem Server. Bewahre Router, Rendering und Datenfluss des Projekts, sofern die Spec keine Änderung verlangt. Aktualisiere Spec oder Plan, wenn die Umsetzung eine notwendige Verhaltens- oder Architekturänderung ergibt.

## UI-Verifikation übergeben

Nutze bei UI-Änderungen `$frontend-design-accessibility` für eine gezielte Qualitätsprüfung und `$verify-ui` zur Auswahl und Dokumentation relevanter Prüfungen. Richte Build- und Testbefehle an den Repository-Skripten aus; prüfe zentrale Abläufe nach Möglichkeit in unterstützten Browsern und Viewports.
