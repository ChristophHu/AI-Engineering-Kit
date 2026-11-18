---
name: ios-swiftui-projektmuster
description: Überträgt die SwiftUI-Projektstruktur, View-Extensions, das Screenshot-Onboarding und das Farb- und Darstellungssystem aus PolMan RS-DB für SwiftUI-Projekte auf iOS, iPadOS und macOS und passt die Vorlagen an bestehende Projektkonventionen und Plattformen an.
---

# SwiftUI-Projektmuster aus PolMan RS-DB

Verwende diesen Skill bei der Planung, Erstellung oder Erweiterung nativer SwiftUI-Projekte für iOS, iPadOS und macOS, wenn Projektstruktur, gemeinsame View-Modifier, Onboarding oder das Farb- und Darstellungssystem relevant sind. Die Muster stammen aus einer iOS-App und sind eine anpassbare Referenz, keine verbindliche Architektur. Prüfe zuerst die bestehende Ziel-App, ihren Deployment-Target und vorhandene Typen, Assets und Einstellungen. Übernimm nur benötigte Teile und integriere sie in die vorhandene Architektur; die Vorlage ist kein vollständiges App-Gerüst.

- Für Aufbau und Einordnung lies [Projektstruktur](references/projektstruktur.md).
- Für kurze View-Modifier und ihre Abhängigkeiten lies [Extensions](references/extensions.md); die ursprünglichen Swift-Dateien liegen in [references/Extensions](references/Extensions).
- Für Einbindung und Zustand des Screenshot-Onboardings lies [Onboarding](references/onboarding.md); die Komponente liegt in [references/Onboarding](references/Onboarding).
- Für semantische Farben, Akzentwahl und Appearance lies [Farben](references/farben.md); Quelldateien und Farbassets liegen in [assets/AccentColor](assets/AccentColor) und [assets/Colors.xcassets](assets/Colors.xcassets).

Die Assets sind extrahierte Ausgangsversionen, keine ungeprüft universell einsetzbare Bibliothek. Passe App-Texte, Screenshots, Plattformverfügbarkeit und Target-Zugehörigkeit an. Überprüfe bei der Integration insbesondere Default-Werte, Farbkontrast, gespeicherte Indizes und Deployment-Target anhand der jeweiligen Referenz. Teste die betroffenen Ansichten und Abläufe im Zielprojekt.

## Plattformen und Zusammenspiel

- Ergänze bei SwiftUI-Entwicklung `$app-dev-swiftui`; die vorhandene Zielarchitektur und die unterstützten Plattformen haben Vorrang vor der Vorlage. Für iOS- und iPadOS-Oberflächen ergänze bei Bedarf `$native-ios-design`.
- Prüfe je Ziel-Target APIs, Imports, Asset-Zugehörigkeit und Deployment-Target. Plattformübergreifende SwiftUI-Muster können angepasst werden; UIKit, `UIImage`, `UIApplication`, Bildschirmtastatur und iPhone-Rahmen sind nicht ohne Anpassung auf natives macOS übertragbar. Verwende dort passende SwiftUI- oder AppKit-Alternativen und plattformgerechte Fenster-, Tastatur- und Zeigerinteraktionen.
- Übernimm nur für die Aufgabe geeignete Bausteine; ergänze keine Plattformunterstützung oder Onboarding-Funktion allein aufgrund dieses Skills. Prüfe Build und betroffene Abläufe für jedes tatsächlich unterstützte Ziel, soweit die Umgebung es ermöglicht.
