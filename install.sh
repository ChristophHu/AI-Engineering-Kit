#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
TARGET_DIR="${1:-$PWD}"
TARGET_DIR="$(cd -- "$TARGET_DIR" && pwd)"
KIT_SOURCE="$SOURCE_DIR/.codex"
KIT_DEST="$TARGET_DIR/.codex"
MARKER_START="<!-- AI-ENGINEERING-KIT:START -->"
MARKER_END="<!-- AI-ENGINEERING-KIT:END -->"

if [[ ! -d "$KIT_SOURCE" ]]; then
  printf 'Fehler: Paketordner .codex fehlt in %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$KIT_DEST"
if [[ -e "$KIT_DEST/ai-engineering" ]]; then
  printf 'Fehler: %s existiert bereits; Kit-Dateien werden nicht überschrieben.\n' "$KIT_DEST/ai-engineering" >&2
  exit 1
fi
AGENTS="$TARGET_DIR/AGENTS.md"
if [[ -f "$AGENTS" ]] && grep -Fq "$MARKER_START" "$AGENTS"; then
  printf 'Fehler: AGENTS.md enthält bereits einen AI-Engineering-Kit-Abschnitt.\n' >&2
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

Für Entwicklungsaufgaben beachte `.codex/ai-engineering/RULES.md` und den passenden Ablauf in `.codex/ai-engineering/WORKFLOW.md`. Spec-Driven Development ist der Standard für mehrteilige oder unklare Anforderungen; halte einfache Änderungen leichtgewichtig. Skills liegen unter `.agents/skills/`.
$MARKER_END"

cp -R "$KIT_SOURCE/ai-engineering" "$KIT_DEST/"
cp -R "$KIT_SOURCE/skills" "$KIT_DEST/"
if [[ -f "$AGENTS" ]]; then
  cp "$AGENTS" "$AGENTS.bak"
  printf '\n\n%s\n' "$BLOCK" >> "$AGENTS"
else
  printf '%s\n' "$BLOCK" > "$AGENTS"
fi

for skill_dir in "$KIT_DEST"/skills/*; do
  skill_name="$(basename -- "$skill_dir")"
  skill_dest="$TARGET_DIR/.agents/skills/$skill_name"
  cp -R "$skill_dir" "$skill_dest"
done

printf 'AI Engineering Kit installiert in %s\n' "$TARGET_DIR"
