# Projektstruktur

Das Hauptprojekt ist `c44-polmanrsdb.xcodeproj`, der Swift-Code liegt unter `c44-polmanrsdb/`. `FaceIDTest/` ist ein separates Experiment, kein Teil des hier extrahierten Grundmusters.

```text
AppName/
├── AppNameApp.swift          # @main, WindowGroup mit AppStartingView
├── Core/
│   ├── Views/                # AppStartingView, OnboardingView, SettingsView, DarstellungView, ProfileView
│   └── Domain/AccentColor/   # Accent-Modell, Daten, persistierte Einstellungen
├── Components/               # spezialisierte Komponenten, z. B. WebView und MailView
├── Extensions/View/          # kleine SwiftUI-Modifier und Design-Tokens
├── Extensions/               # weitere Erweiterungen; Container-Registrierung ist auskommentiert
├── Helper/Onboarding.swift   # eigenständige Onboarding-View
└── Assets.xcassets/          # semantische Farben, Bilder, Icon
```

`AppStartingView` entscheidet anhand von `@AppStorage("hasSeenOnboarding")` zwischen Onboarding und Hauptansicht und setzt Tint und Farbschema. `SettingsView` verlinkt zur Darstellung und setzt den Onboarding-Schlüssel für eine erneute Anzeige zurück. Die Views sind in diesem Projekt nicht durchgehend in ViewModels getrennt; keine zusätzliche Architektur als bestehend ausgeben. Die auskommentierte Factory-Registrierung ist keine aktive Dependency-Injection-Lösung.

Für neue Apps den Aufbau sinngemäß anpassen. Swift-Dateien und Asset-Kataloge dem App-Target zuordnen; bei bestehendem Katalog die gewünschten Colorsets einzeln übernehmen und Namenskonflikte prüfen. Das Xcode-Projekt nennt für das App-Target iOS 26.3, die Projektkonfiguration enthält auch 26.4; die Zielkonfiguration ist maßgeblich. Swift-Version-Einstellung: 5.0. Bei niedrigeren Versionen verwendete APIs und Alternativen separat prüfen.

Die Ordnerstruktur ist eine Orientierung für SwiftUI-Projekte auf iOS, iPadOS und macOS, keine Vorgabe. Bei mehreren Targets gemeinsame und plattformspezifische Dateien sowie Assets passend zuordnen; bestehende Projektstrukturen beibehalten.
