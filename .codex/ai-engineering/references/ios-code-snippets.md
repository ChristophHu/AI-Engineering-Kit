# iOS-Code-Snippets

## Überblick

Diese Referenz sammelt wiederverwendbare Swift- und SwiftUI-Snippets für die iOS-Entwicklung. Jedes Snippet beschreibt seinen Zweck, seinen Einsatzbereich und die erforderlichen Anpassungen. Versionsangaben werden ergänzt, wenn sie bekannt und für das Beispiel relevant sind.

Die Beispiele sind Ausgangspunkte: Sie müssen an die Architektur, unterstützten Plattformen und Anforderungen des jeweiligen Projekts angepasst werden.

## Vorlage für neue Snippets

````markdown
### Aussagekräftiger Name

**Zweck:** Welches Problem löst das Snippet?

**Verwenden, wenn:** In welcher Situation ist es geeignet?

**Voraussetzungen:** Benötigte Frameworks und gegebenenfalls Mindestversion von iOS, Swift oder Xcode.

**Beispiel:**

```swift
// Vollständiges oder klar abgegrenztes Code-Beispiel
```

**Anpassen:** Welche Namen, Werte oder Abhängigkeiten müssen für das Projekt geändert werden?

**Beachten:** Welche Grenzen, Nebenwirkungen oder häufigen Fehler gibt es?

**Prüfen:** Wie lässt sich feststellen, ob das Snippet funktioniert?

**Quelle:** Link zur offiziellen Dokumentation oder Herkunft des Snippets, falls vorhanden.
````

## SwiftUI

### Navigation

### Zustand und Datenfluss

#### Ladezustand in einer View anzeigen

**Zweck:** Zeigt während eines Ladevorgangs einen Fortschrittsindikator und danach den Inhalt an.

**Verwenden, wenn:** Eine View zwischen einem Ladezustand und verfügbaren Daten unterscheiden soll.

**Voraussetzungen:** SwiftUI.

**Beispiel:**

```swift
import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ProgressView("Daten werden geladen")
        } else {
            Text("Inhalt ist bereit")
        }
    }
}
```

**Anpassen:** Den Beispieltext durch den tatsächlichen Inhalt ersetzen und `isLoading` mit dem Zustand des jeweiligen Ladevorgangs verbinden.

**Beachten:** Das Snippet zeigt nur die Darstellung des Zustands. Es startet selbst keinen Ladevorgang und behandelt keine Fehler.

**Prüfen:** `isLoading` testweise auf `true` und `false` setzen und kontrollieren, ob jeweils die erwartete Ansicht erscheint.

### Barrierefreiheit

## Daten und Persistenz

## Nebenläufigkeit

## Tests
