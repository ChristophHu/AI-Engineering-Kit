# Projektbezogene Codex-Agenten

Jede TOML-Datei definiert ein Agentenprofil für eine eng umrissene Rolle. Codex lädt projektbezogene Profile aus `.codex/agents/`.

Die Auswahl erfolgt aufgabenbezogen:

- `codebase-explorer.toml` – liest Code und Dokumentation, liefert belegte Pfade und Muster.
- `spec-plan-reviewer.toml` – prüft Spec und Plan gegen Ziel, Kriterien und Architektur.
- `implementation-worker.toml` – setzt nur einen ausdrücklich abgegrenzten Auftrag um.
- `code-reviewer.toml` – prüft Änderungen unabhängig und nimmt selbst keine Änderungen vor.
- `supabase-specialist.toml` – bearbeitet zugewiesene Supabase-Aufgaben mit dem passenden Skill.
- `nestjs-postgres-specialist.toml` – bearbeitet zugewiesene NestJS-/PostgreSQL-Aufgaben mit dem passenden Skill.

Nutze die [Delegationsregeln](../rules/DELEGATION.md), bevor du Arbeit auf mehrere Agenten verteilst. Profile ändern keine Berechtigungen der übergeordneten Sitzung. Modelle und Reasoning-Stufen bleiben standardmäßig von der Sitzung steuerbar.
