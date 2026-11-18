# View-Extensions

Die Dateien unter `references/Extensions/` sind die Originale einschließlich Previews. Sie hängen teilweise voneinander und von den Farbassets ab; gezielt übernehmen, alle verwendeten Swift-Dateien ins App-Target einbinden und vorhandene Symbole auf Kollisionen prüfen. `Color.swift` benötigt die acht Colorsets und deren generierte Swift-Asset-Symbole; bei fehlender Symbolgenerierung alternativ explizite Assetnamen mit `Color("TextColor")` usw. verwenden.

| API | Wirkung und Voraussetzung |
| --- | --- |
| `.infinityFrame()` | Maximale verfügbare Breite und Höhe. |
| `.button(.press) { … }` / `.button { … }` | Macht eine View zum Button; `.press` skaliert beim Drücken auf 0,95, Standard ist `.plain`. |
| `.primaryButton(color:)`, `.destructiveButton()`, `.plainButton()` | Gestalten eine View als Button-Label; ergänzend `.button(...)` verwenden. Abhängigkeiten: Color, CornerRadius, Shadow, Button. |
| `.cornerRadius(.button/.cell/.overall/.textfield)` | Projekttokens mit jeweils 8 Punkten. |
| `.shadow(.none/.light/.regular/.heavy/.top)` | Projekttokens für Schatten; `.top` hat negativen y-Versatz. |
| `.inputTextfield()` | Decimal-Pad, Padding, Zellenhintergrund, Radius und Schatten; nur für numerische Eingabe sinnvoll. |
| `hideKeyboard()` / `.hideKeyboardOnTap()` | UIKit-First-Responder zurücksetzen bzw. per Tap auslösen; Gesteninteraktionen beachten. Die Datei heißt im Original `HideKeyboardOnTab.swift`. |
| `Color.appTheme` | Semantisches Farbmodell; Details siehe Farben-Referenz. |

Beispiel:

```swift
Text("Weiter")
    .primaryButton(color: Color.appTheme.accent)
    .button(.press) { advance() }
```

Achtung: Im Original ist der Default von `primaryButton(color:)` **accentContrastText**, während die Schrift ebenfalls `accentContrastText` ist. Das kann unsichtbaren Text ergeben. Für eine verwendbare Vorlage explizit `.appTheme.accent` als Hintergrund setzen oder den Default im Zielprojekt entsprechend korrigieren und Hell/Dunkel-Kontrast prüfen. Die Modifier ändern nicht automatisch ihre Farbe bei Auswahl einer dynamischen Akzentfarbe. Die meisten dieser Abkürzungen erscheinen im Ausgangsprojekt vor allem in Extension-Previews; die eigentlichen App-Views verwenden häufig reguläres SwiftUI.

Für natives macOS sind die UIKit-basierten Tastaturhelfer und der Decimal-Pad-Modifier nicht unverändert geeignet. Wähle plattformgerechte Eingabe und Fokussteuerung; prüfe auch bei den übrigen Modifiern API-Verfügbarkeit und Interaktion pro Target.
