# AI Engineering Kit für Codex

Ein projektübergreifend wiederverwendbares Spec-Driven-Development-Kit. Die Paketdateien liegen im Verzeichnis `.codex`; nach der Installation enthält das Zielprojekt dort die Unterordner `agents`, `rules` und `skills`. Das Installationsskript kopiert die Skills zusätzlich an Codex' projektweiten Skill-Erkennungspfad `.agents/skills` und ergänzt `AGENTS.md` um einen kurzen Verweis auf die Kit-Regeln.

## Installation in einem Codex-Projekt

Führe das Installationsskript aus dem Kit-Ordner aus und gib den gewünschten Ziel-Projektordner als Argument an. Der Ordner wird angelegt, falls er noch nicht existiert:

```sh
bash install.sh /pfad/zum/projekt
```

Beispiel:

```sh
bash install.sh "$HOME/Projects/mein-projekt"
```

Ohne genau einen Zielpfad bricht das Skript mit einer Verwendungshilfe ab. Das Kit wird nicht in seinen eigenen Quellordner installiert. Existiert der Zielpfad bereits als Datei, bricht das Skript mit einer Fehlermeldung ab.

Das Skript legt eine Sicherung vorhandener `AGENTS.md` an, fügt einen markierten Kit-Abschnitt hinzu und installiert Skills ohne vorhandene gleichnamige Skills zu überschreiben. Bei Namenskonflikten bricht es ab und nennt die betroffenen Pfade. Regeln, Workflow und Vorlagen liegen unter `.codex/rules/`, Skills unter `.codex/skills/`; Skills werden zusätzlich nach `.agents/skills/` kopiert, damit Codex sie erkennt.

Nach der Installation fragt das Skript interaktiv nach einer ersten Projektbeschreibung und speichert sie unter `.codex/PROJECT.md`. Als Orientierung nennt es mögliche Inhalte wie Projektziel, Plattform und Frontend-Technologie (z. B. Next.js oder Angular), Anwendungsstruktur, Systemdesign, Referenzprodukt, Nutzer, Monetarisierung, Integrationen und Datenbankstrukturen. Bei nicht-interaktiver Ausführung wird dort eine ausfüllbare Vorlage mit diesen Hinweisen angelegt.

## Ablauf

1. **Specify:** Ziel, Nutzer, Kontext, Grenzen und Abnahmekriterien festhalten.
2. **Plan:** Die Spec in kleine, überprüfbare Arbeitspakete und Risiken übersetzen.
3. **Implement:** Änderungen entlang des Plans umsetzen; Abweichungen in Spec/Plan dokumentieren.
4. **Verify:** Abnahmekriterien gegen die Implementierung prüfen und offene Punkte benennen.

Für kleine, eindeutige Aufgaben kann Codex Spec und Plan knapp halten. Bei Änderungen mit mehreren Komponenten, unklaren Anforderungen oder hohem Risiko wird vor der Implementierung eine explizite Spec erwartet. Der Workflow ist ein Entscheidungsrahmen, kein bürokratisches Gate.

## Inhalt

- `.codex/PROJECT.md` – erste Beschreibung des installierten Projekts (wird vom Installer angelegt)
- `.codex/agents/` – Ablage für projektspezifische Agent-Definitionen
- `.codex/rules/WORKFLOW.md` – Phasen, Übergänge und Artefakte
- `.codex/rules/RULES.md` – projektweite Arbeitsregeln
- `.codex/rules/ARCHITECTURE.md` und die beiden Architekturdiagramme – Referenzarchitekturen für native Apple-Apps und Web-Apps
- `.codex/rules/templates/` – Spec-, Plan- und Verifikationsvorlagen
- `.codex/skills/` – Spec-/Planungs- und DSGVO-Skills, Entwicklungs-Skills für SwiftUI, Next.js und Angular sowie gemeinsame UI-Accessibility- und UI-Verifikations-Skills
- `install.sh` – idempotente, konfliktbewusste Integration

Nach Installation kann ein Skill mit `$spec-driven-development`, `$feature-planning` oder `$implementation-review` aufgerufen werden.
