---
name: native-ios-design
description: Gestaltet und erstellt native iOS- und iPadOS-Apps mit SwiftUI unter Beachtung der Human Interface Guidelines, Liquid Glass, Leistung und Dynamic Type. Nutze den Skill für SwiftUI-Oberflächen, Typografie, Farben, gemeinsame Komponenten, Liquid Glass, adaptive Layouts und HIG-Prüfungen.
---

# Native Gestaltung für iOS

Erstelle Apps mit plattformtypischem Erscheinungsbild, die sich durch Zurückhaltung und Details statt durch eigene Bedienelementrahmen auszeichnen.
Diese Regeln stammen aus der Veröffentlichung einer SwiftUI-Chat-App für iOS 26+ unter Beachtung der Human Interface Guidelines und der Liquid-Glass-Empfehlungen. Die Begründungen helfen bei der Beurteilung nicht abgedeckter Fälle.

## Vorgehen

1. **Beginne mit Systemkomponenten.** `NavigationSplitView`, `NavigationStack`, `List`, `Form`, `toolbar`, `sheet`,
   `Menu`, `contextMenu`, `confirmationDialog`, `searchable`, `PhotosPicker`. Sie bringen Liquid Glass, Dynamic Type,
   VoiceOver, Tastatur-, Zeiger- und iPad-Verhalten mit. Verwende eine eigene View nur, wenn keine Systemkomponente passt.
2. **Bündele Designentscheidungen.** Eine `Typography.swift` für Schriftrollen, eine `Colors.swift` für Farbrollen und eine
   `Components.swift` für gemeinsame Bausteine. Views verwenden Rollen statt direkter Größen oder Farben. Nutze die Vorlagen in [templates/](templates/) als Ausgangspunkt und benenne Rollen passend zur App.
3. **Prüfe jede Ansicht mit drei Einstellungen**, bevor sie als fertig gilt: Standardtextgröße, größte
   Barrierefreiheitsgröße (AX5) und Dark Mode. Prüfe anschließend einmal mit Increase Contrast und Reduce Transparency.
4. **Prüfe anhand von [references/review-checklist.md](references/review-checklist.md)**, wenn eine Ansicht oder App überprüft werden soll.

## Typografie für große Schriftgrößen

Vollständige Anleitung: [references/typography.md](references/typography.md).

- **Nur Systemtextstile.** Verwende `.largeTitle` bis `.caption2` und ändere bei Bedarf das Gewicht. Verwende für Text niemals
  `.font(.system(size: 17))`. Feste Größen skalieren nicht mit Dynamic Type oder Bold Text und verlieren Laufweite und Zeilenabstand des Systems.
- **Benenne Schriften in einer Datei nach Rolle.** Verwende `Font.rowTitle`, `Font.messageBody`, `Font.sectionLabel` statt
  `.font(.subheadline.weight(.semibold))` über Views zu verteilen. Die Skalierung lässt sich so an einer Stelle ändern.
- **Mindestgröße und Schriftgewicht.** Lesetext nicht kleiner als Caption 1 (12 pt bei Standardgröße; 11 pt als HIG-Minimum). Verwende für UI-Text weder Ultralight, Thin noch Light.
- **Keine feste Texthöhe.** Setze `minHeight`, Padding und `lineLimit` sorgfältig ein. Ein festes `frame(height:)` schneidet Text bei großen Größen ab.
- **Bei Barrierefreiheitsgrößen neu anordnen.** Wenn `dynamicTypeSize.isAccessibilitySize`, ordne Zeilen statt horizontal vertikal an (`AdaptiveStack` in den Vorlagen), entferne platzraubende Symbole, zeige weniger Elemente pro Zeile und entferne `lineLimit`s. Wörter sollen nicht mitten im Wort umbrechen.
- **Begrenze Bedienelemente, nicht Inhalte.** Inhaltstext wächst unbegrenzt. Leistensteuerungen, Badges und kleine runde Schaltflächen enden wie systemeigene Toolbars bei `.dynamicTypeSize(...DynamicTypeSize.accessibility1)`. Ihre Größen stammen aus `@ScaledMetric` mit Obergrenze: `min(scaledSize, 64)`.
- **Symbole skalieren mit Text.** Bemaße SF Symbols über eine Schrift (`.font(.body.weight(.semibold))`) statt über einen Frame, damit sie Dynamic Type und dem benachbarten Schriftgewicht folgen.
- **UIKit-Text-Views** verwenden `UIFont.preferredFont(forTextStyle:)` und `adjustsFontForContentSizeCategory = true`.
- **Kurze Texte erhalten ausgeglichene Zeilen** (`BalancedText` in den Vorlagen), damit eine Sprechblase oder ein Titel nicht mit einem einzelnen Wort endet.

## Liquid Glass

Vollständige Anleitung: [references/liquid-glass.md](references/liquid-glass.md).

- **Glass gehört zur Navigationsebene, nicht zum Inhalt.** Toolbars, Tab-Leisten, schwebende Bedienelemente und Sheets schweben als Glass über dem Inhalt. Listen, Karten und Nachrichtenblasen bleiben deckend.
- **Lass zuerst das System zeichnen.** Standard-Toolbars, Tab-Leisten, Sheets, Menüs und `.buttonStyle(.glass)` /
  `.glassProminent` nutzen bereits Liquid Glass. Entferne eigene Hintergründe, Rahmen und `presentationBackground`s, die es verdecken.
- **Eigene schwebende Bedienelemente** verwenden `.glassEffect(.regular.interactive(), in: .circle)` oder ein abgerundetes Rechteck. Gruppiere sie in einem `GlassEffectContainer`, damit benachbarte Formen ineinander übergehen und gemeinsam gerendert werden.
- **Kein Glass auf Glass.** Eine Schaltfläche innerhalb eines Glass-Feldes erhält eine deckende Füllung, etwa einen schwarzen Send-Kreis, keine weitere Glass-Ebene.
- **Leisten über scrollendem Inhalt** gehören in `safeAreaBar(edge:)`, damit der Scroll-Edge-Effekt den Inhalt darunter abschwächt. Nutze `safeAreaInset` nur, wenn dieser Effekt nicht gewünscht ist.
- **Schließen-Schaltflächen** sind `Button(role: .close)` an einer `.cancellationAction`-Position der Toolbar; das System zeichnet das Glass-`xmark`.
- **Barrierefreiheitseinstellungen passen Glass an**, darunter Reduce Transparency, Increase Contrast und Reduce Motion, sofern System-Glass statt nachgebildeter Materialien und Unschärfe verwendet wird.

## Layout und Komponenten

Vollständige Anleitung: [references/layout-and-components.md](references/layout-and-components.md).

- **Das iPad erhält eine Seitenleiste.** Nutze `NavigationSplitView` mit Auswahl in einem Router und auf dem iPhone einem zusammengeklappten Stack. Sorge auf breiten Bildschirmen für lesbare Breiten, etwa 560 pt für Chatblasen.
- **Treffbereiche:** Strebe für iOS und iPadOS den Standardwert von 44 × 44 pt an. Ein 20 pt großes sichtbares Element kann mit `contentShape` innerhalb eines interaktiven Bereichs von mindestens 44 × 44 pt liegen. Apple nennt in seinen Barrierefreiheitshinweisen 28 × 28 pt als Mindestgröße für Bedienelemente unter iOS/iPadOS; verwende kleinere Elemente nur, wenn angemessen, und berücksichtige Abstände. Für macOS nennt Apple 28 × 28 pt als Standard und 20 × 20 pt als Minimum; beachte macOS-Konventionen. Siehe [Apples Barrierefreiheitshinweise](https://developer.apple.com/design/human-interface-guidelines/accessibility) und [Hinweise zu Schaltflächen](https://developer.apple.com/design/human-interface-guidelines/buttons).
- **Menüs statt eigener Pop-ups.** Nutze `Menu`, `contextMenu` mit einer `ControlGroup` als Palette für Reaktionen, `confirmationDialog` zur Bestätigung destruktiver Aktionen und `.sheet` mit `presentationDetents` für sekundäre Aufgaben.
- **Tastatur wie in Messages.** Ein Tippen auf Inhalte blendet die Tastatur aus, Scrollen nicht (`.scrollDismissesKeyboard(.never)` zusammen mit einer Tippgeste). Beim Fokussieren des Feldes springt die Scrollposition nicht.
- **Links öffnen sich innerhalb der App** mit `SFSafariViewController` über eine `OpenURLAction` in der Umgebung.
- **Zoom-Übergänge** (`matchedTransitionSource` + `.navigationTransition(.zoom(sourceID:in:))`) beim Öffnen eines Fotos oder Details aus einem Vorschaubild verwenden.

## Farben und Symbole

Vollständige Anleitung: [references/color-and-icons.md](references/color-and-icons.md).

- **Systemfarben zuerst** (`.primary`, `.secondary`, `Color(uiColor: .secondarySystemBackground)`); sie passen sich an Dark Mode und Increase Contrast an. Benenne eigene Farben nach ihrer Rolle.
- **Textkontrast mindestens 4.5:1**, beziehungsweise 3:1 ab 18 pt oder 14 pt fett. Systemfarben in Orange, Grün und Blau auf Weiß erfüllen dies für Text nicht; verwende dunklere Varianten für den hellen Modus.
- **Farbe niemals allein verwenden.** Unterstreiche Links und ergänze Statusfarben durch ein Symbol oder Wort.
- **Zeilensymbole** sind SF Symbols auf 26–29 pt großen Kacheln mit kontinuierlich abgerundeten Ecken (Radius ≈ 22,5 % der Seitenlänge), wie in Settings.
- **Durch Zurückhaltung hervorheben:** eine klare Farbidentität, auch nur Schwarz und Weiß, eine Akzentfarbe und ein markantes, mehrschichtiges App-Icon aus Icon Composer. Keine eigenen Navigationsrahmen.

## Bewegung, Feedback und Leistung

Vollständige Anleitungen: [references/accessibility.md](references/accessibility.md),
[references/performance.md](references/performance.md).

- **Animiere Zustände statt ruckelnder Layouts.** Begrenze `.animation(.smooth(duration: 0.2), value:)` auf den geänderten Wert; nutze `.transition(.move(edge: .bottom).combined(with: .opacity))` für erscheinende Leisten.
- **Beachte Reduce Motion** bei dekorativer Bewegung: Prüfe `accessibilityReduceMotion` und entferne oder vereinfache sie.
- **Haptik über SwiftUI:** `.sensoryFeedback(.selection, trigger:)` für Picker und `.success` / `.error` für Ergebnisse. Setze sie sparsam ein.
- **Lange Listen** verwenden `LazyVStack` / `List` mit stabilen IDs, kein `AnyView` in Zeilen und keine aufwendige Arbeit in `body`.
- **Scroll-Beobachtung** liefert den kleinsten benötigten Wert (`onScrollGeometryChange(for: Bool.self)`), damit Views nur bei dessen Wechsel aktualisiert werden.
- **Bilder** werden vor der Anzeige heruntergerechnet (`preparingThumbnail(of:)`) und in Listen niemals in voller Größe dekodiert.
- **Asynchrone Arbeit** liegt in `.task(id:)`, damit sie beim Verschwinden der View oder bei Änderung der Eingabe abgebrochen wird.

## Texte

- Schaltflächen und Menüpunkte im Stil von Überschriften und als Verben formulieren: „Remove Photo“, „Clear Chat“, „Cancel Reply“.
- Beschreibungen, Fußtexte und Warnungen kurz und in Satzschreibweise formulieren; sie beschreiben den nächsten Schritt.
- Beschriftungen für Barrierefreiheit beschreiben die Funktion eines Bedienelements, nicht sein Aussehen („Scroll to Bottom“, nicht „Chevron“).

## Was zu vermeiden ist

- Eigene Tab-Leisten, Navigationsleisten oder Zurück-Schaltflächen, die Systemkomponenten nachahmen.
- Feste Schriftgrößen, feste Texthöhen oder `minimumScaleFactor` für Lesetext.
- Glass auf Inhalt, Glass auf Glass oder Unschärfematerialien, die Glass vortäuschen.
- Gesten ohne sichtbare oder barrierefreie Alternative.
- Unterschiedliche Gestaltung zwischen Ansichten, weil jede View eigene Werte gewählt hat.
