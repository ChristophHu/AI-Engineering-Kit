# AI Engineering Kit für Codex

Ein projektübergreifend wiederverwendbares Spec-Driven-Development-Kit. Die Paketdateien liegen im Verzeichnis `.codex`; das Installationsskript kopiert die Skills an Codex' projektweiten Skill-Erkennungspfad `.agents/skills` und ergänzt `AGENTS.md` um einen kurzen Verweis auf die Kit-Regeln.

## Installation in einem Codex-Projekt

Kopiere den Ordner `.codex` und `install.sh` in das Projekt-Root und führe dort aus:

```sh
./install.sh
```

Alternativ:

```sh
bash install.sh /pfad/zum/projekt
```

Das Skript legt eine Sicherung vorhandener `AGENTS.md` an, fügt einen markierten Kit-Abschnitt hinzu und installiert Skills ohne vorhandene gleichnamige Skills zu überschreiben. Bei Namenskonflikten bricht es ab und nennt die betroffenen Pfade. Die installierte Kit-Kopie bleibt unter `.codex/ai-engineering/`; Skills werden aus `.codex/skills/` nach `.agents/skills/` kopiert, damit Codex sie erkennt.

## Ablauf

1. **Specify:** Ziel, Nutzer, Kontext, Grenzen und Abnahmekriterien festhalten.
2. **Plan:** Die Spec in kleine, überprüfbare Arbeitspakete und Risiken übersetzen.
3. **Implement:** Änderungen entlang des Plans umsetzen; Abweichungen in Spec/Plan dokumentieren.
4. **Verify:** Abnahmekriterien gegen die Implementierung prüfen und offene Punkte benennen.

Für kleine, eindeutige Aufgaben kann Codex Spec und Plan knapp halten. Bei Änderungen mit mehreren Komponenten, unklaren Anforderungen oder hohem Risiko wird vor der Implementierung eine explizite Spec erwartet. Der Workflow ist ein Entscheidungsrahmen, kein bürokratisches Gate.

## Inhalt

- `.codex/ai-engineering/WORKFLOW.md` – Phasen, Übergänge und Artefakte
- `.codex/ai-engineering/RULES.md` – projektweite Arbeitsregeln
- `.codex/ai-engineering/templates/` – Spec-, Plan- und Verifikationsvorlagen
- `.codex/skills/` – drei Codex-Skills für Spec, Planung und Umsetzung/Review
- `install.sh` – idempotente, konfliktbewusste Integration

Nach Installation kann ein Skill mit `$spec-driven-development`, `$feature-planning` oder `$implementation-review` aufgerufen werden.
