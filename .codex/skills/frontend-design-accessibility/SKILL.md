---
name: frontend-design-accessibility
description: Gestaltet oder prüft Oberflächen nativer Apple- und Web-Apps hinsichtlich Anpassungsfähigkeit, Barrierefreiheit sowie bestehender visueller und interaktiver Projektmuster.
---

# Frontend-Gestaltung und Barrierefreiheit

Nutze diesen Skill beim Erstellen oder Prüfen von App-Oberflächen, Interaktionsmustern oder Barrierefreiheit. Er umfasst SwiftUI- und browserbasierte Oberflächen und gibt weder eine visuelle Marke vor noch ersetzt er die nativen Konventionen der Plattform.

Nutze für native SwiftUI-Oberflächen auf iOS und iPadOS zusätzlich `$native-ios-design`; wende bei macOS nur dessen plattformübergreifende Hinweise an, die zu den macOS-Konventionen passen. Beachte die unterstützten Betriebssystemversionen und das bestehende Design des Projekts, insbesondere vor der Verwendung von Liquid-Glass-APIs.

## Vor der Gestaltung prüfen

1. Lies Projektanweisungen, `.codex/PROJECT.md`, `docs/design-system.md`, sofern vorhanden, relevante Specs und bestehende Gestaltungs- oder Barrierefreiheitsvorgaben.
2. Prüfe benachbarte Ansichten und Komponenten, Design-Tokens, Typografie, Abstände, Navigation und Interaktionsmuster. Verwende sie wieder, soweit sie passen.
3. Ermittle Zielplattform, unterstützte Geräte oder Ansichtsgrößen, Eingabemethoden und Anforderungen an die Barrierefreiheit aus Projekt und Spec. Frage nur nach, wenn eine fehlende Entscheidung die Oberfläche wesentlich verändern würde.

## Gestalten und prüfen

Prüfe für betroffene Ansichten und Abläufe die relevanten Bereiche:

- Layouts passen sich an unterstützte Bildschirmgrößen und Inhaltslängen an.
- Visuelle Hierarchie, Abstände, Typografie, Farben und Interaktionszustände passen zum Produkt.
- Web-Oberflächen verwenden semantisches HTML sowie aussagekräftige Überschriften, Beschriftungen und Orientierungspunkte.
- Tastaturnutzer können Bedienelemente erreichen und bedienen; der Fokus ist sichtbar und vorhersehbar.
- Screenreader erhalten hilfreiche Namen, Rollen, Werte und Zustandsänderungen.
- Text und Bedienelemente bieten ausreichenden Kontrast; Textskalierung und Zoom bleiben nutzbar.
- Lade-, Leer-, Validierungs-, Erfolgs- und Fehlerzustände sind verständlich.
- Native Apple-Oberflächen beachten plattformgerechte Interaktion, Dynamic Type, VoiceOver sowie relevantes Fokus- und Eingabeverhalten.

Berichte konkrete Befunde je Ansicht oder Komponente und beschreibe ihre Auswirkung auf Nutzer. Nimm gezielte Änderungen passend zum bestehenden Designsystem vor; vermeide nicht beauftragte Neugestaltungen und die Einführung einer neuen Komponentenbibliothek.

Nutze `$verify-ui`, um praktische UI-Prüfungen auszuwählen und zu dokumentieren, wenn die Aufgabe eine Verifikation umfasst.
