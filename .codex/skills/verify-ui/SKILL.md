---
name: verify-ui
description: Wählt UI- und Funktionsprüfungen für native Apple-, Next.js- und Angular-Projekte aus, führt sie durch und berichtet Nachweise sowie nicht ausgeführte Prüfungen.
---

# UI-Verifikation

Nutze diesen Skill, um eine UI-Funktion oder einen Release-Kandidaten zu prüfen. Bei einer vollständigen Implementierung erfolgt die Prüfung nach Abschluss der Änderungen. Lies Spec, Plan und Projektanweisungen sowie `docs/design-system.md` und `.codex/rules/ARCHITECTURE.md`, sofern vorhanden.

## Prüfungen anhand des Projekts auswählen

1. Ermittle Plattform, betroffene Nutzerabläufe, Abnahmekriterien, unterstützte Ziele sowie verfügbare Test- und Build-Befehle.
2. Prüfe Projektskripte und bestehende Tests, bevor du Befehle auswählst. Bewahre die vorhandene Teststrategie; ergänze im Rahmen der Verifikation kein separates plattformweites Test-Framework.
3. Wähle aus dem zutreffenden Plattformprofil angemessene automatisierte und praktische Prüfungen. Ergänze weitere Prüfungen nur, wenn das geänderte Verhalten sie erfordert.
4. Dokumentiere für jede Prüfung Befehl oder Vorgehen, Umgebung, Ergebnis und die unterstützten Abnahmekriterien. Unterscheide ausgeführte von geplanten oder nicht verfügbaren Prüfungen.
5. Berichte fehlgeschlagene Prüfungen, ungeprüfte Abläufe, bekannte Einschränkungen sowie relevante Befunde zu Barrierefreiheit oder Sicherheit. Behaupte keine nicht durchgeführte Prüfung. Nutze `.codex/rules/templates/VERIFICATION.md`, wenn ein dauerhafter Nachweis sinnvoll ist.

## Profil für native Apple-Apps und SwiftUI

Wähle Prüfungen anhand der unterstützten Apple-Plattformen und Bereitstellungsziele. Berücksichtige für iPadOS bei betroffenen Änderungen adaptive Layouts, Größenänderungen oder Multitasking sowie Tastatur- und Zeigerverhalten. Berücksichtige für macOS bei betroffenen Änderungen Fenster, Menüs und Befehle sowie Tastatur- und Zeigerverhalten. Gehe nicht davon aus, dass jede App alle Plattformen unterstützt.

- Erstelle einen Build der App oder des betroffenen Targets für das konfigurierte Ziel.
- Führe relevante vorhandene Unit- oder UI-Tests aus.
- Prüfe den zentralen Ablauf für iOS/iPadOS in einem geeigneten Simulator oder auf einem physischen Gerät, sofern verfügbar; nutze für macOS die native macOS-Testumgebung oder einen Mac.
- Prüfe bei betroffenen Änderungen Berechtigungsabfragen sowie das Verhalten bei Ablehnung und erneutem Versuch.
- Prüfe bei betroffenen Änderungen Lebenszyklus, Hintergrund und Vordergrund, Unterbrechung oder Wiederherstellung.
- Prüfe VoiceOver, Dynamic Type, Fokus und Eingabe sowie weiteres relevantes Verhalten zur Barrierefreiheit.

Nutze die Xcode-Build- und Testumgebung des Projekts und die konfigurierten Unit- und UI-Testwerkzeuge. Native Apple-Oberflächen sind keine Browseroberflächen und dürfen nicht mit Chrome DevTools verifiziert werden. Berichte das genaue Ziel sowie nicht verfügbare oder nicht ausgeführte Simulator-, Geräte- oder macOS-Prüfungen.

## Web-Profil: Next.js oder Angular

Wähle Prüfungen anhand von Framework-Version, Router, Laufzeit, Browserunterstützung und Projektskripten:

- Führe den konfigurierten Produktions-Build und relevante vorhandene Tests aus.
- Prüfe zentrale Nutzerabläufe, sofern verfügbar, in unterstützten Browsern und repräsentativen Ansichtsgrößen.
- Nutze `$browser-testing-with-devtools`, wenn Chrome DevTools MCP konfiguriert und verfügbar ist. Verwende andernfalls ein anderes verfügbares und autorisiertes Browser-Testwerkzeug oder berichte Browserprüfungen als nicht ausgeführt.
- Berücksichtige von der Änderung betroffene Lade-, Leer-, Validierungs-, Fehler- und Wiederherstellungszustände.
- Prüfe bei Bedarf Tastaturinteraktion, Fokus, semantische Struktur, Screenreader-Namen, Kontrast sowie Zoom und Umbruch.
- Prüfe bei betroffenen Änderungen Authentifizierung, Autorisierung, API-Grenzen und den Umgang mit nicht vertrauenswürdigen Eingaben.

Berichte, welche Browser und Ansichtsgrößen tatsächlich geprüft wurden, und nenne nicht ausgeführte Prüfungen.

## Zusammenfassung der Abnahme

Ordne jedem Abnahmekriterium einen Nachweis und den Status „bestanden“, „fehlgeschlagen“ oder „offen“ zu. Ein erfolgreicher Build allein belegt nicht, dass Nutzerabläufe oder das Verhalten zur Barrierefreiheit funktionieren.
