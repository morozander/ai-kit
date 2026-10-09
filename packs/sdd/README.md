# SDD pack

Opt-in spec-driven development loop for Cursor / Claude Code. **Code serves specifications.** Stack-neutral. Inspired by [GitHub Spec Kit](https://github.com/github/spec-kit); this pack is the editable copy, not the CLI.

Separate from `/feature-dev` (`docs/specs/`, `docs/plans/`). SDD artifacts live under `docs/constitution.md` and `docs/sdd/`.

This README stays in the kit. `install-into.sh` copies skills and commands only; it does not copy this file into a consuming project.

## Install

From the kit root:

```bash
sh core/scripts/install-into.sh --target /path/to/project --pack sdd --link
```

Use `--force` if those names already exist. Skills land in `.agents/skills/`; commands in `.agents/commands/`. Invoke `/sdd-*` in the target project’s agent chat.

## Main flow

Running the next command is approval. Re-running a stage overwrites only that stage’s files and warns if later artifacts exist.

1. **`/sdd-constitution`** once per project → `docs/constitution.md` (not `AGENTS.md`).
2. **`/sdd-specify`** per feature → `docs/sdd/<nnn>-<slug>/spec.md` and `docs/sdd/current.md`.
3. Optional: **`/sdd-clarify`** (up to 5 sequential questions) and/or **`/sdd-checklist`** (requirements quality, not code tests).
4. **`/sdd-plan`** → `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, optional `contracts/`. Stops if `[NEEDS CLARIFICATION]` remains.
5. **`/sdd-tasks`** → `tasks.md` (checklist lines, no code).
6. **`/sdd-analyze`** → `analyze.md`. **Critical Issues Count must be 0** before any code.
7. Either **`/sdd-implement`** (one `tasks.md` phase, then stop) repeatedly, or **`/sdd-loop`** (remaining phases, then converge until Converged).
8. **`/sdd-converge`** if you did not use the loop: inspect **code** (not `[x]` boxes), write `converge.md`, append a Convergence phase on `tasks.md` when work remains.

```text
constitution → specify → [clarify | checklist] → plan → tasks → analyze
                → implement (one phase)  ─┐
                → loop (phases + converge)─┴→ converge until Converged
```

## Skills and commands

Thin commands only point at `.agents/skills/<name>/SKILL.md`. `sdd-shared` has no command; every other skill reads it first.

| Skill / command | Role | Main output |
|-----------------|------|-------------|
| `sdd-shared` | Feature folder via `docs/sdd/current.md`; analyze gate for implement/loop | — |
| `/sdd-constitution` | Project principles | `docs/constitution.md` |
| `/sdd-specify` | WHAT-not-HOW spec (one pass) | `spec.md`, `checklists/requirements.md`, `docs/sdd/current.md` |
| `/sdd-clarify` | Up to 5 sequential questions; encode answers | in-place `spec.md` |
| `/sdd-checklist` | Unit tests for English (reviewer-owned) | `checklists/<domain>.md` (append-only) |
| `/sdd-plan` | Technical design bundle; no `tasks.md` | `plan.md`, research, data-model, quickstart, optional contracts |
| `/sdd-tasks` | Executable checklist with file paths | `tasks.md` |
| `/sdd-analyze` | Read-only spec/plan/tasks consistency | `analyze.md` |
| `/sdd-implement` | Next incomplete phase only | application code; ticks in `tasks.md` |
| `/sdd-converge` | Code vs artifacts; append remaining work | `converge.md`; maybe Convergence phase on `tasks.md` |
| `/sdd-loop` | Drain phases, then implement → converge until Converged | none of its own |

Feature folder layout after a full run:

```text
docs/constitution.md
docs/sdd/current.md
docs/sdd/<nnn>-<slug>/
  spec.md
  plan.md research.md data-model.md quickstart.md
  contracts/          # if an external interface
  checklists/
  tasks.md
  analyze.md
  converge.md
```

## Notes

- Do not mix with `/feature-dev`. That loop uses `docs/specs/` and `docs/plans/`.
- Pass a folder in the argument or rely on `docs/sdd/current.md`. The agent must not pick the highest-numbered folder.
- No git branch is created. Use `/create-branch` from `core` if you want one.
- Custom checklists are reviewer-owned (`[x]` means the requirement text is good enough). They are **not** an implement gate.
- `core` is optional. If `.agents/skills/tdd/SKILL.md` or `code-review` is installed, Implement / Converge follow them.
- `spec-kit-main/` in this repo is reference only. It is not installed with the pack.
- This README is not copied into the target project.
