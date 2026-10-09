# Workflow Lapa

Feature loop for Cursor / Claude Code: grill a spec, plan it, verify coverage, implement with TDD, then review. Stack-neutral.

Artifacts live under `docs/specs/` and `docs/plans/`. Separate from the SDD pack (`docs/sdd/`).

This README stays in the kit. `install-into.sh` copies skills, agents, and commands only; it does not copy this file into a consuming project.

## Install

From the kit root:

```bash
sh core/scripts/install-into.sh --target /path/to/project --pack workflow-lapa --link
```

Use `--force` if those names already exist. Skills land in `.agents/skills/`; agents in `.agents/agents/`; commands in `.agents/commands/`.

`grill-spec` and `implement-and-review` read `grilling` and `tdd` from this same pack, at `.agents/skills/grilling/SKILL.md` and `.agents/skills/tdd/SKILL.md`.

## Main flow

1. **`/grill-spec`** interviews, then writes `docs/specs/YYYY-MM-DD-<name>.md`.
2. **`/brainstorm`** only if the system shape is still unclear.
3. **`/plan`** writes `docs/plans/YYYY-MM-DD-<name>.md`, then `plan-verifier` coverage-only (spec → plan).
4. **`/implement-and-review`** follows the plan with TDD, then **`/code-review`**.

**`/feature-dev`** runs that whole loop in one session. A one-file bugfix skips spec and plan, and still uses TDD and code review.

```text
grill-spec → [brainstorm] → plan → plan-verifier → implement-and-review
                                                      → tdd → code-review
```
