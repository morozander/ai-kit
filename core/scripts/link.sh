#!/bin/sh
# Recreate relative IDE adapters for a project with root skills/agents/commands.
# Install this file as <project>/scripts/link.sh then run: sh scripts/link.sh
# Optional env: SKILLS AGENTS COMMANDS (space/newline-separated). Else discover dirs.
set -e
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

discover() {
  dir="$1"
  [ -d "$dir" ] || return 0
  for path in "$dir"/*; do
    [ -e "$path" ] || continue
    base=$(basename "$path")
    base=${base%.md}
    printf '%s\n' "$base"
  done
}

if [ -z "${SKILLS:-}" ]; then
  SKILLS=$(discover skills)
fi
if [ -z "${AGENTS:-}" ]; then
  AGENTS=$(discover agents)
fi
if [ -z "${COMMANDS:-}" ]; then
  COMMANDS=$(discover commands)
fi

mkdir -p .claude/skills .claude/agents .claude/commands
mkdir -p .cursor/skills .cursor/commands

for name in $SKILLS; do
  [ -d "skills/$name" ] || continue
  ln -sfn ../../skills/"$name" .claude/skills/"$name"
  ln -sfn ../../skills/"$name" .cursor/skills/"$name"
done

for name in $AGENTS; do
  [ -f "agents/$name.md" ] || continue
  ln -sfn ../../agents/"$name".md .claude/agents/"$name".md
done

for name in $COMMANDS; do
  [ -f "commands/$name.md" ] || continue
  ln -sfn ../../commands/"$name".md .claude/commands/"$name".md
  ln -sfn ../../commands/"$name".md .cursor/commands/"$name".md
done

if [ -e CLAUDE.md ] && [ ! -L CLAUDE.md ]; then
  echo "Refusing to replace real file CLAUDE.md. Remove it, then re-run." >&2
  exit 1
fi
if [ -e .cursorrules ] && [ ! -L .cursorrules ]; then
  echo "Refusing to replace real file .cursorrules. Remove it, then re-run." >&2
  exit 1
fi

if [ -f AGENTS.md ]; then
  ln -sfn AGENTS.md CLAUDE.md
  ln -sfn AGENTS.md .cursorrules
fi

echo "Adapters linked in $ROOT"
