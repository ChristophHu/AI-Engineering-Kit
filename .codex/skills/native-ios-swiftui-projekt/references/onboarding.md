# Screenshot-Onboarding

`references/Onboarding/Onboarding.swift` enthält die Originalkomponente. Sie zeigt eine nicht manuell scrollbar gemachte Screenshot- und Textfolge, animierte Seitenindikatoren, Zurück, Weiter/Abschluss und Überspringen. Pro `Item` gibt es ID, Titel, Untertitel, optionales `UIImage`, `zoomScale` und `zoomAnchor`; `tint` bestimmt die Buttonfarbe, `hideBezel` blendet den Rahmen aus. Abschluss und Überspringen setzen `@AppStorage("hasSeenOnboarding")` auf `true` und rufen `onComplete` auf. Die View erzwingt Dark Mode. Die Inhalte der Ursprungs-App sind nicht Teil der generischen Komponente.

Integration: Swift-Datei ins Ziel-Target aufnehmen, eigene Screenshot-Assets hinzufügen, mindestens ein Item bereitstellen und die Startansicht mit demselben Storage-Key steuern. Beispiel:

```swift
struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        if hasSeenOnboarding {
            ContentView()
        } else {
            Onboarding(tint: .blue, items: [
                .init(id: 0, title: "Willkommen", subtitle: "Entdecke die App.",
                      screenshot: UIImage(named: "welcome")),
                .init(id: 1, title: "Loslegen", subtitle: "Alle Funktionen im Blick.",
                      screenshot: UIImage(named: "overview"), zoomScale: 1.3,
                      zoomAnchor: .bottom)
            ]) { }
        }
    }
}
```

Zum erneuten Anzeigen `hasSeenOnboarding = false` setzen. Der Abschluss-Callback kann weitere Aktionen ausführen; das erneute Setzen des Schlüssels darin ist nicht nötig. Im Ausgangscode hat `AppStartingView` den Default `true`, die Onboarding-Komponente dagegen `false`: Beim Übertragen einen einheitlichen Default wählen; `false` zeigt das Onboarding bei Erststart. `alwaysShowOnboarding` ist dort nicht fertig implementiert und der entsprechende Schalter deaktiviert.

Die Komponente indexiert `items[currentIndex]`: Ein leeres Array würde abstürzen. Validierung vorsehen, falls die Daten variabel sind. Fehlende Bilder erscheinen schwarz. Die ursprüngliche Datei verwendet moderne APIs wie Glass-Effekte und `ConcentricRectangle`; das Ausgangs-Target ist iOS 26.3. Bei niedrigeren Deployment-Targets Verfügbarkeit prüfen und geeignete Fallbacks implementieren. Dark Mode, feste Höhen und Texte bei kleinen Geräten, Dynamic Type sowie Hell-/Dunkel-Kontrast im Zielprojekt prüfen.

Die Originalkomponente verwendet UIKit und `UIImage` und ist daher keine direkt übertragbare native macOS-Komponente. Für macOS Bildtypen, Layout, Navigation und Eingaben plattformgerecht neu anpassen; für iPadOS insbesondere variable Fenstergrößen und Eingabearten prüfen.
