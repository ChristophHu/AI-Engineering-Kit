---
name: app-dev-swiftui
description: Plant, implementiert oder prüft Funktionen einer bestehenden nativen Apple-App mit SwiftUI unter Beachtung ihrer unterstützten Plattformen, Bereitstellungsziele und Projektkonventionen.
---

# SwiftUI-App-Entwicklung

Nutze diesen Skill für native Apple-Apps mit SwiftUI, einschließlich iOS, iPadOS und macOS. Beginne mit der abgestimmten Spec und dem Plan, sofern vorhanden; nutze bei größeren Aufgaben zuerst `$spec-driven-development` und `$feature-planning`.

## Projekt vor Änderungen untersuchen

1. Lies die Projektanweisungen, `.codex/PROJECT.md` und, falls vorhanden, `docs/design-system.md`.
2. Untersuche das Xcode-Projekt oder den Workspace, Build-Konfiguration, Paketmanifest sowie relevante Quell- und Testdateien.
3. Ermittle unterstützte Apple-Plattformen, Bereitstellungsziele, Swift- und SDK-Versionen, App-Lebenszyklus, Navigation, Zustandsverwaltung, Persistenz und vorhandene Apple-Frameworks. Schließe aus SwiftUI nicht auf die Unterstützung sämtlicher Apple-Plattformen.
4. Beachte die Konventionen der Codebasis. Führe keine neue Architektur, Abhängigkeit, kein Framework und keine neue Betriebssystemmindestversion allein wegen verbreiteter SwiftUI-Muster ein.

## Planen und umsetzen

Berücksichtige für die jeweilige Funktion die relevanten Bereiche:

- Zusammensetzung von SwiftUI-Views, wiederverwendbare Komponenten und plattformgerechte Interaktionen
- Navigation, Zustandsverantwortung und Datenfluss nach vorhandenen Mustern
- asynchrone Arbeit mit Swift Concurrency einschließlich Actor-Isolation, Abbruch und Lebenszyklus
- Persistenz und Backend-Zugriff
- bei Bedarf lokale SQLite-Persistenz, Schemamigrationen, Datenschutz und Offline-Synchronisierung mit `$backend-dev-sqlite-data`
- Berechtigungen, ihr nutzerseitiger Zweck und erforderliche Nutzungsbeschreibungen
- App-Lebenszyklus, Hintergrundverhalten und plattformspezifische Systemintegration
- Accessibility-Beschriftungen, Fokus, Dynamic Type, Kontrast und relevante Eingabearten

Berücksichtige plattformspezifisches Verhalten, soweit relevant:

- **iPhone:** kompakte Layouts, Touch-Bedienung und bestehende Navigationsmuster.
- **iPad:** adaptive Layouts, Multitasking und Größenänderung, Tastatur- und Zeigereingabe sowie Navigation für größere Displays.
- **Mac:** Fenstergröße und Wiederherstellung, Menüs und Befehle, Tastaturkürzel, Zeigereingabe und macOS-Navigationskonventionen.

Dies sind Prüfpunkte und keine Pflichtfunktionen. Folge den Produktanforderungen und bestehenden Konventionen; ergänze Menüs, Mehrfensterverhalten oder Plattformunterstützung nur bei entsprechendem Projektbedarf.

Halte die bestehenden Grenzen zwischen UI, Anwendungsverhalten, Persistenz und Servicezugriff ein. Aktualisiere Spec oder Plan, wenn die Umsetzung eine notwendige Verhaltens- oder Architekturänderung ergibt.

## UI-Verifikation übergeben

Nutze bei UI-Änderungen `$frontend-design-accessibility` für eine gezielte Qualitätsprüfung und `$verify-ui` zur Auswahl und Dokumentation relevanter Prüfungen. Ziehe für SwiftUI-Oberflächen auf iOS und iPadOS zusätzlich `$native-ios-design` heran; bei macOS nutze daraus nur plattformübergreifend passende Hinweise. Beachte jeweils die unterstützten Betriebssystemversionen und bestehenden Projektkonventionen, insbesondere bei Liquid Glass. Halte das tatsächliche Bereitstellungsziel und die Verfügbarkeit von Simulator oder Gerät im Prüfplan fest; behaupte keine nicht ausgeführte Prüfung.
