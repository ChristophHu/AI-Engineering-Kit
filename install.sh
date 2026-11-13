#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
if [[ $# -ne 1 ]]; then
  printf 'Verwendung: bash %s /pfad/zum/projekt\n' "$0" >&2
  printf 'Bitte gib genau einen bestehenden Projektordner als Ziel an.\n' >&2
  exit 2
fi

TARGET_DIR="$1"
if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ -e "$TARGET_DIR" ]]; then
    printf 'Fehler: Der Zielpfad existiert, ist aber kein Ordner: %s\n' "$TARGET_DIR" >&2
    exit 2
  fi
  mkdir -p -- "$TARGET_DIR"
fi
TARGET_DIR="$(cd -- "$TARGET_DIR" && pwd)"
KIT_SOURCE="$SOURCE_DIR/.codex"
KIT_DEST="$TARGET_DIR/.codex"
MARKER_START="<!-- AI-ENGINEERING-KIT:START -->"
MARKER_END="<!-- AI-ENGINEERING-KIT:END -->"

if [[ ! -d "$KIT_SOURCE" ]]; then
  printf 'Fehler: Paketordner .codex fehlt in %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

if [[ "$TARGET_DIR" == "$SOURCE_DIR" ]]; then
  printf 'Fehler: Das Kit kann nicht in seinen eigenen Paketordner installiert werden.\n' >&2
  printf 'Gib den Pfad zu einem anderen Projektordner an.\n' >&2
  exit 2
fi

AGENTS="$TARGET_DIR/AGENTS.md"
if [[ -f "$AGENTS" ]] && grep -Fq "$MARKER_START" "$AGENTS"; then
  printf 'Fehler: AGENTS.md enthält bereits einen AI-Engineering-Kit-Abschnitt.\n' >&2
  exit 1
fi

for category in agents rules skills; do
  if [[ -e "$KIT_DEST/$category" ]]; then
    printf 'Fehler: %s existiert bereits; Kit-Dateien werden nicht überschrieben.\n' "$KIT_DEST/$category" >&2
    exit 1
  fi
done
if [[ -e "$KIT_DEST/PROJECT.md" ]]; then
  printf 'Fehler: %s existiert bereits; die Projektbeschreibung wird nicht überschrieben.\n' "$KIT_DEST/PROJECT.md" >&2
  exit 1
fi
if [[ -e "$KIT_DEST/IDEA.md" ]]; then
  printf 'Fehler: %s existiert bereits; die ursprüngliche Idee wird nicht überschrieben.\n' "$KIT_DEST/IDEA.md" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR/.agents/skills"
for skill_dir in "$KIT_SOURCE"/skills/*; do
  skill_name="$(basename -- "$skill_dir")"
  skill_dest="$TARGET_DIR/.agents/skills/$skill_name"
  if [[ -e "$skill_dest" ]]; then
    printf 'Fehler: Skill-Konflikt bei %s; vorhandene Dateien bleiben unverändert.\n' "$skill_dest" >&2
    exit 1
  fi
done

BLOCK="$MARKER_START
## AI Engineering Kit

Für Entwicklungsaufgaben beachte \`.codex/rules/RULES.md\` und den passenden Ablauf in \`.codex/rules/WORKFLOW.md\`. Spec-Driven Development ist der Standard für mehrteilige oder unklare Anforderungen; halte einfache Änderungen leichtgewichtig. Skills liegen unter \`.codex/skills/\` und \`.agents/skills/\`.

Beim ersten Arbeitsauftrag nach dieser Installation prüfe zuerst den Repository-Status und folge \`.codex/skills/git/SKILL.md\`: Nutze ein vorhandenes Repository ohne verschachteltes \`.git\`; initialisiere mit \`git init\` nur dann am Projektstamm, wenn noch kein Repository zuständig ist. Erstelle bei einem frischen Repository nach Prüfung der Dateien direkt den ersten Commit.
$MARKER_END"

mkdir -p "$KIT_DEST"
for category in agents rules skills; do
  cp -R "$KIT_SOURCE/$category" "$KIT_DEST/"
done

if [[ -f "$AGENTS" ]]; then
  printf '\n\n%s\n' "$BLOCK" >> "$AGENTS"
else
  printf '%s\n' "$BLOCK" > "$AGENTS"
fi

for skill_dir in "$KIT_DEST"/skills/*; do
  skill_name="$(basename -- "$skill_dir")"
  skill_dest="$TARGET_DIR/.agents/skills/$skill_name"
  cp -R "$skill_dir" "$skill_dest"
done

PROJECT_FILE="$KIT_DEST/IDEA.md"
if [[ -t 0 ]]; then
  printf 'AI Engineering Kit installiert in %s\n\n' "$TARGET_DIR"
  printf 'Beschreibe jetzt das Projekt. Du kannst zum Beispiel Ziel, Plattform (native Apple-App oder Web-App), Frontend (z. B. Next.js oder Angular), Anwendungsstruktur, Systemdesign, Technologien, Referenzprodukt, Nutzer, Monetarisierung, Integrationen und Datenbankstrukturen beschreiben.\n'
  printf 'Beende die Eingabe mit einer leeren Zeile.\n'
  PROJECT_DESCRIPTION=""
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    PROJECT_DESCRIPTION+="$line"$'\n'
  done

  if [[ -z "$PROJECT_DESCRIPTION" ]]; then
    printf 'Bitte ergänze die Projektbeschreibung später in %s.\n' "$PROJECT_FILE"
    printf '# Projektbeschreibung\n\nBeschreibe die für dieses Projekt relevanten Punkte, zum Beispiel:\n\n- Ziel des Projekts\n- Plattform (native Apple-App, Web-App oder beides)\n- Frontend-Technologie (z. B. Next.js oder Angular)\n- Anwendungsstruktur, Systemdesign und weitere Technologien\n- Referenzprodukt und Nutzer\n- Monetarisierung und Integrationen\n- Datenbankstrukturen\n' > "$PROJECT_FILE"
  else
    printf '# Projektbeschreibung\n\n%s' "$PROJECT_DESCRIPTION" > "$PROJECT_FILE"
  fi
else
  printf '# Projektbeschreibung\n\nBeschreibe die für dieses Projekt relevanten Punkte, zum Beispiel:\n\n- Ziel des Projekts\n- Plattform (native Apple-App, Web-App oder beides)\n- Frontend-Technologie (z. B. Next.js oder Angular)\n- Anwendungsstruktur, Systemdesign und weitere Technologien\n- Referenzprodukt und Nutzer\n- Monetarisierung und Integrationen\n- Datenbankstrukturen\n' > "$PROJECT_FILE"
  printf 'AI Engineering Kit installiert in %s\n' "$TARGET_DIR"
  printf 'Ergänze die erste Projektbeschreibung in %s.\n' "$PROJECT_FILE"
fi
