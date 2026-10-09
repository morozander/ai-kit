---
name: feature-dev
description: Full feature loop from idea to review — grill spec, plan, verify coverage, TDD implement, code-review. Use when the user says build this feature, ship this feature, or wants the spec-plan-implement loop.
---

# Feature dev

Run the full loop in this session. Read each listed skill or agent and execute that role with explicit file paths. Do not assume a subagent spawn.

## Size gate

If the change is an obvious bugfix or one-file tweak: skip spec and plan. Still follow `.agents/skills/tdd/SKILL.md` when behavior changes, then `.agents/skills/code-review/SKILL.md`. Stop after review.

Otherwise continue:

1. Read and follow `.agents/skills/grill-spec/SKILL.md`. Spec path: `docs/specs/YYYY-MM-DD-<name>.md`.
2. If the system shape is still unclear, read and follow `.agents/skills/brainstorming/SKILL.md` (optional design at `docs/plans/YYYY-MM-DD-<name>-design.md`).
3. Read and follow `.agents/skills/writing-plans/SKILL.md`. Plan path: `docs/plans/YYYY-MM-DD-<name>.md`.
4. **Hard gate:** read `.agents/agents/plan-verifier.md` and run **coverage-only** mode (Pass 1: spec → plan). Pass 2 is N/A before code. Do not implement until coverage is COVERED or the user accepts OUT OF SCOPE items.
5. Read and follow `.agents/skills/implement-and-review/SKILL.md`.
