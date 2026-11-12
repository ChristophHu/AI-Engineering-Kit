---
name: app-dev-angular
description: Plant, implementiert oder prüft Funktionen einer bestehenden Angular-Anwendung unter Beachtung ihrer Angular-Version und Projektkonventionen.
---

# Angular-App-Entwicklung

Nutze diesen Skill für Arbeiten in einem Angular-Projekt. Beginne mit der abgestimmten Spec und dem Plan, sofern vorhanden; nutze bei größeren Aufgaben zuerst `$spec-driven-development` und `$feature-planning`.

## Projekt vor Änderungen untersuchen

1. Lies die Projektanweisungen, `.codex/PROJECT.md` und, falls vorhanden, `docs/design-system.md`.
2. Untersuche `package.json`, Lockdatei, Angular-Version, `angular.json`, Build- und Testskripte, Routenkonfiguration sowie relevante Quell- und Testdateien.
3. Ermittle Komponentenmodell, Dependency Injection, Routing, Formulare, HTTP-/Datenzugriff, Zustandsverwaltung, unterstützte Browser und Deployment-Konfiguration.
4. Beachte bestehende Konventionen. Konvertiere keine Komponenten, ersetze keine Zustandsverwaltung und füge keine Bibliothek ohne Anforderung und ausdrücklichen Plan hinzu.

## Planen und umsetzen

Berücksichtige für die jeweilige Funktion die relevanten Bereiche:

- Standalone-Komponenten und ihre Templates nach dem bestehenden Projektstil
- Dependency Injection und Abgrenzung von Services
- Routing, Guards, Formulare, Validierung und Navigation
- RxJS oder Signals gemäß bestehendem Code und Anforderungen der Funktion
- HTTP-Aufrufe, Lade- und Fehlerzustände, Authentifizierung und Autorisierung
- bei SQLite: serverseitiges SQLite hinter einer API von browserlokalem SQLite/WASM unterscheiden; OPFS-, Worker- und Browserbedingungen sowie einen etwaigen Synchronisationsvertrag mit `$backend-dev-sqlite-data` planen
- Barrierefreiheit in Templates einschließlich semantischer Elemente, Beschriftungen, Fokus und Tastaturbedienung
- Build-Konfiguration, Umgebungen und Browserunterstützung

Halte Komponenten und Services mit bestehenden Zuständigkeiten konsistent. Aktualisiere Spec oder Plan, wenn die Umsetzung eine notwendige Verhaltens- oder Architekturänderung ergibt.

## UI-Verifikation übergeben

Nutze bei UI-Änderungen `$frontend-design-accessibility` für eine gezielte Qualitätsprüfung und `$verify-ui` zur Auswahl und Dokumentation relevanter Prüfungen. Richte Build- und Testbefehle an den Repository-Skripten aus; prüfe zentrale Abläufe nach Möglichkeit in unterstützten Browsern und Viewports.
