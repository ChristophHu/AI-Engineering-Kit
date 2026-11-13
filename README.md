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

Das Skript fügt einer vorhandenen `AGENTS.md` einen markierten Kit-Abschnitt hinzu und installiert Skills ohne vorhandene gleichnamige Skills zu überschreiben. Bei Namenskonflikten bricht es ab und nennt die betroffenen Pfade. Regeln, Workflow und Vorlagen liegen unter `.codex/rules/`, Skills unter `.codex/skills/`; Skills werden zusätzlich nach `.agents/skills/` kopiert, damit Codex sie erkennt.

Nach der Installation fragt das Skript interaktiv nach einer ersten Projektbeschreibung und speichert sie als ursprüngliche Idee unter `.codex/IDEA.md`. Als Orientierung nennt es mögliche Inhalte wie Projektziel, Plattform und Frontend-Technologie (z. B. Next.js oder Angular), Anwendungsstruktur, Systemdesign, Referenzprodukt, Nutzer, Monetarisierung, Integrationen und Datenbankstrukturen. Bei nicht-interaktiver Ausführung wird dort eine ausfüllbare Vorlage mit diesen Hinweisen angelegt.

Der erste Agent, der danach im Projekt arbeitet, prüft den Git-Status und folgt `$git`: Er initialisiert ein eigenständiges Projekt mit `git init`, falls noch kein übergeordnetes Repository zuständig ist, und erstellt nach Prüfung der Dateien den initialen Commit. In einem bestehenden Repository mit Historie bleiben fremde Änderungen unberührt; es wird kein verschachteltes Repository angelegt.

## Projektarbeit nach der Installation starten

Das Installationsskript startet keinen Agenten. Öffne nach erfolgreicher Installation das Zielprojekt in Codex oder starte eine Codex-Sitzung im Zielverzeichnis. Ergänze bei Bedarf die ursprüngliche Idee in `.codex/IDEA.md`.

Gib dem Agenten anschließend beispielsweise diesen Auftrag:

> Beginne mit `$init` die Arbeit an diesem Projekt und prüfe zuerst Git gemäß dem installierten Git-Workflow. Nutze `.codex/IDEA.md` als ursprüngliche Projektidee.

Der erste Agent prüft Git wie oben beschrieben. `$init` liest `.codex/IDEA.md`, klärt bei Bedarf die Absicht mit `$interview-me` und schärft die Idee mit `$idea-refine`. Dieser erstellt nach der Abstimmung die konkrete Ausarbeitung in `.codex/PROJECT.md` und verweist auf die erhaltene ursprüngliche Idee. Besteht bereits eine Projektdatei, wird sie nach der Ideenschärfung vor Änderungen gelesen und abgeglichen. Anschließend arbeitet `$init` Produktvision, Designrichtung und Prioritäten aus und legt sie dem Nutzer zur Bestätigung vor. Für die vereinbarte Aufgabe folgen `$spec-driven-development` und `$feature-planning`; danach die vereinbarte Umsetzung und passende Verifikation.

## Ablauf

1. **Specify:** Ziel, Nutzer, Kontext, Grenzen und Abnahmekriterien festhalten.
2. **Plan:** Die Spec in kleine, überprüfbare Arbeitspakete und Risiken übersetzen.
3. **Implement:** Änderungen entlang des Plans umsetzen; Abweichungen in Spec/Plan dokumentieren.
4. **Verify:** Abnahmekriterien gegen die Implementierung prüfen und offene Punkte benennen.

Für kleine, eindeutige Aufgaben kann Codex Spec und Plan knapp halten. Bei Änderungen mit mehreren Komponenten, unklaren Anforderungen oder hohem Risiko wird vor der Implementierung eine explizite Spec erwartet. Der Workflow ist ein Entscheidungsrahmen, kein bürokratisches Gate.

## Inhalt

- `.codex/IDEA.md` – ursprüngliche Projektidee (wird vom Installer angelegt)
- `.codex/PROJECT.md` – mit `$idea-refine` konkretisierte Projektbeschreibung mit Bezug auf die ursprüngliche Idee
- `.codex/agents/` – projektbezogene Agentenprofile für Exploration, Planung, Umsetzung, Review und Backend-Arbeit
- `.codex/rules/WORKFLOW.md` – Phasen, Übergänge und Artefakte
- `.codex/rules/RULES.md` – projektweite Arbeitsregeln
- `.codex/rules/DELEGATION.md` – Delegationskriterien, Auftragsübergabe, Berechtigungsgrenzen und Ergebniskontrolle
- `.codex/rules/ARCHITECTURE.md` und die beiden Architekturdiagramme – Referenzarchitekturen für native Apple-Apps und Web-Apps
- `.codex/rules/templates/` – Spec-, Plan-, Verifikations- und Backend-Entscheidungsvorlagen
- `.codex/skills/` – Projektinitialisierung, Setup-Verifikation, Git-Skill, Spec-/Planungs-, Supabase-, NestJS/PostgreSQL-, C#/SQL-Server- und SQLite-Datenspeicher-Skills, DSGVO- und Deploy-Skills, Entwicklungs-Skills für SwiftUI, Next.js und Angular sowie gemeinsame UI-Accessibility- und UI-Verifikations-Skills
- `$init` – Discovery-Interview, Produktvision, priorisierte Feature-Map und Design-System vor der Implementierung
- `install.sh` – idempotente, konfliktbewusste Integration

Nach Installation kann ein Skill mit `$init`, `$spec-driven-development`, `$feature-planning`, `$verify-setup` oder `$implementation-review` aufgerufen werden.
