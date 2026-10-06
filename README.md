# AI Kit

Portable Cursor + Claude Code kit: reusable skills, agents, commands, scripts, and a greenfield bootstrap.

## Layout

| Path | Purpose |
|------|---------|
| [AGENTS.md](AGENTS.md) | Kit maintenance instructions (edit this only for root context) |
| [bootstrap/bootstrap-cursor-claude.md](bootstrap/bootstrap-cursor-claude.md) | Paste into an agent in an empty folder to scaffold a project |
| [core/](core/) | Shared git/plan/debug skills, commands, agents. Feature loop: `/feature-dev` (grill spec → `docs/specs/` → plan → verify → TDD → review) |
| [packs/software-frontend/](packs/software-frontend/) | React-oriented skills and agents |
| [packs/hiking-tutor/](packs/hiking-tutor/) | Hiking coach domain pack (from esc-tutor) |
| [templates/](templates/) | Minimal project stubs |
| [docs/](docs/) | Architecture and how to add a pack |

| Tool | Reads |
|------|--------|
| Codex / Cursor | `AGENTS.md` |
| Claude Code | `CLAUDE.md` → `AGENTS.md` |
| Cursor (legacy) | `.cursorrules` → `AGENTS.md` |

Do not replace those symlinks with copies.

## Install a pack into a project

```bash
cd /Users/oleksandrmorozov/www/ai-kit
sh core/scripts/install-into.sh --target /path/to/project --pack core
sh core/scripts/install-into.sh --target /path/to/project --pack software-frontend
sh core/scripts/install-into.sh --target /path/to/project --pack hiking-tutor --link
```

`--force` overwrites existing names. `--link` runs the project’s `.agents/scripts/link.sh` after copy.

Target projects keep **`.agents/skills/`**, **`.agents/agents/`**, **`.agents/commands/`** as source of truth (Cursor loads `.agents/skills/` natively; Claude adapters under `.claude/`), not Shield’s `.claude/`-canonical layout.

## New empty project

1. Fill the brief in `bootstrap/bootstrap-cursor-claude.md`.
2. Paste the whole file to an agent in an empty folder.
3. Optionally install packs with `install-into.sh`.

## Ticket placeholders

`core` git-workflow uses `TICKET-1234` examples. Override naming in the consuming project’s `AGENTS.md` or a local fork of the skill.
