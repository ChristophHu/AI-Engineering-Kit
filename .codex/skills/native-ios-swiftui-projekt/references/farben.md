# Farben und Darstellung

Es gibt zwei unabhängige Systeme:

1. **Semantische Asset-Farben:** `Color.appTheme` bündelt `accent`, `accentContrastText`, `cellBackground`, `destructive`, `divider`, `text`, `secondaryText`, `viewBackground`. `assets/Colors.xcassets` enthält die acht Original-Colorsets mit ihren Light-/Dark-Varianten; `references/Extensions/Color.swift` definiert das Modell. Zum Beispiel:

   ```swift
   Text("Titel")
       .foregroundStyle(Color.appTheme.text)
       .infinityFrame()
       .background(Color.appTheme.viewBackground)
   ```

   Für `.infinityFrame()` zusätzlich die entsprechende Extension übernehmen. Die Asset-Initialisierer im Original verwenden generierte Swift-Symbole wie `.accentContrastText`; entsprechende Generierung aktivieren oder `Color("AccentContrastTextColor")` und die übrigen Assetnamen explizit verwenden. Die Werte einschließlich systemgebundener Farben stehen in den jeweiligen `Contents.json`.

2. **Nutzerdefinierter Tint:** `Accent` enthält ID, Name und Farbe. `accentData` bietet Blau, Grün, Orange, Rot, Violett, Pink, Mint, Teal und Kontrast. `AccentSettings.shared` speichert einen Integer unter `UserDefaults`-Key `Accent` und veröffentlicht Änderungen via `@Published`. Die Ausgangs-App zeigt die Auswahl in `DarstellungView` und setzt `.tint(...)` am Root sowie explizit am Onboarding.

```swift
@ObservedObject private var accent = AccentSettings.shared

var selectedAccent: Color {
    accentData.first(where: { $0.id == accent.accentSettings })?.accentColor ?? .blue
}

// An Root-View und ggf. Onboarding anwenden:
// .tint(selectedAccent)
```

Die sichere Suche nach ID vermeidet den Absturz des Originalcodes bei ungültigem gespeichertem Array-Index und erlaubt Änderungen an der Reihenfolge. `Color.appTheme.accent` bleibt dabei die Asset-Farbe: `.tint` verändert sie nicht. Wenn beide gemeinsam reagieren sollen, die Architektur im Zielprojekt ausdrücklich verbinden und Kontrast sicherstellen.

Für die Darstellung speichert das Original `@AppStorage("colorScheme")` einen Integer: System = 0, Hell = 1, Dunkel = 2. Die Root-View wendet `.preferredColorScheme(nil/.light/.dark)` an, wobei unbekannte Werte auf System fallen. Auswahl erfolgt über einen Picker in den Einstellungen. Das Onboarding überschreibt die Auswahl selbst mit `.preferredColorScheme(.dark)`. Prüfe die Darstellung aller semantischen Farben und Texte in beiden Erscheinungsbildern sowie den Kontrast für jede wählbare Akzentfarbe.
