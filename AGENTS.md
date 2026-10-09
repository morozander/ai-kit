# AI Kit — IDE guide

Personal portable kit of reusable Cursor / Claude Code skills, agents, commands, scripts, and project bootstrap. Not a product app.

This file is the **single source of truth** for kit-maintenance context.

- **Cursor** and **Codex** read `AGENTS.md` at the repo root. `.cursorrules` is a symlink to this file.
- **Claude Code** reads `CLAUDE.md`, which is a symlink to this file.

Edit **this file only** for root instructions. Do not copy it into other agent filenames.

## Your role

You maintain this kit. Prefer small, focused changes. Do not invent product stacks or domain advice that belongs in a consuming project. When installing into a project, **copy** packs (default); do not silently overwrite without `--force`.

## File map

```
AGENTS.md                         ← this file (master)
bootstrap/bootstrap-cursor-claude.md
core/
  skills/ agents/ commands/ scripts/
packs/
  software-frontend/
  hiking-tutor/
  sdd/
  mattpocock-fork/
templates/
  markdown-coach/
  software-app/
docs/
```

## How to work

1. Shared software workflow pieces live under `core/`.
2. Domain or stack bundles live under `packs/<name>/` with a `pack.yaml`.
3. Greenfield projects: paste `bootstrap/bootstrap-cursor-claude.md` (filled brief) into an empty folder agent session.
4. Existing projects: `sh core/scripts/install-into.sh --target <path> --pack <name>`.
5. Target projects use `.agents/skills/`, `.agents/agents/`, `.agents/commands/` as source of truth; recreate IDE adapters with the project’s `.agents/scripts/link.sh` (or the kit linker after install).

## Hard limits

1. Do not replace `CLAUDE.md` or `.cursorrules` with real copies — they must stay symlinks.
2. Do not put skill bodies under `.cursor/rules/` unless the user asks.
3. Do not copy Shield-only assets into the kit (`deploy-stage`, `ds-audit`, training commands, product `.mdc` rules).
4. Do not commit unless the user asks.
5. Ticket prefixes in `git-workflow` are placeholders (`TICKET-1234`); consuming projects may override.

## Recreating adapters (this kit)

From the kit root: `sh core/scripts/link.sh` (links kit-local adapters only if you add kit `.agents/` skills later). For installed projects, run that project’s `.agents/scripts/link.sh`.
