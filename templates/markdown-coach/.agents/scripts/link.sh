#!/bin/sh
# Recreate relative IDE adapters for this project.
# Run: sh .agents/scripts/link.sh
set -e
ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

SKILLS="review-document"
AGENTS=""
COMMANDS="review"

mkdir -p .claude/skills .claude/agents .claude/commands
mkdir -p .cursor/commands

for name in $SKILLS; do
  [ -d ".agents/skills/$name" ] || continue
  ln -sfn ../../.agents/skills/"$name" .claude/skills/"$name"
done

for name in $AGENTS; do
  [ -f ".agents/agents/$name.md" ] || continue
  ln -sfn ../../.agents/agents/"$name".md .claude/agents/"$name".md
done

for name in $COMMANDS; do
  [ -f ".agents/commands/$name.md" ] || continue
  ln -sfn ../../.agents/commands/"$name".md .claude/commands/"$name".md
  ln -sfn ../../.agents/commands/"$name".md .cursor/commands/"$name".md
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
