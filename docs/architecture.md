# Architecture

## Source of truth vs adapters

Kit and consuming projects use the **esc-tutor / bootstrap** model:

- Real files: `AGENTS.md`, `skills/<name>/`, `agents/<name>.md`, `commands/<name>.md`
- Adapters (relative symlinks only): `CLAUDE.md`, `.cursorrules`, `.claude/*`, `.cursor/skills`, `.cursor/commands`

Skill **directories** are linked so `SKILL.md` and `reference.md` stay together.

## Difference from shield-view-ai-frontend

Shield View keeps canonical content under `.claude/` and symlinks `.cursor/{skills,agents,commands}` to those folders. Product rules live in `.cursor/rules/*.mdc`.

This kit does **not** adopt that layout for portable packs. Install always writes root `skills|agents|commands`, then `scripts/link.sh` builds adapters.

## Layers

```
bootstrap/     → greenfield paste prompt
core/          → cross-project software workflow
packs/*        → optional domain or stack bundles (pack.yaml)
templates/*    → empty stubs for new repos
```

## What was extracted vs left behind

From Shield into `core` / `packs/software-frontend`: git-workflow, brainstorming, writing-plans, systematic-debugging, meta-task-observer, React skills, shared agents/commands (paths generalized; `SHIEL-` → `TICKET-`).

Left in Shield only: `deploy-stage`, `ds-audit`, `commands/training/*`, product `CLAUDE.md`, `.cursor/rules/*`.
