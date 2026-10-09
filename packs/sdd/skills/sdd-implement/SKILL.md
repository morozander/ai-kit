---
name: sdd-implement
description: Execute the next incomplete SDD tasks.md phase only, after a fresh zero-CRITICAL analyze.md. Use after /sdd-analyze. Do not run later phases in the same invocation.
---

# SDD — Implement

Execute one phase of `tasks.md`. This is the only SDD stage that writes application code (except `/sdd-loop`, which calls this skill repeatedly).

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder. Apply the **Analyze gate** from that file. Do not re-scan spec/plan/tasks for consistency here.

## Objective

Implement the next incomplete phase against the spec and plan, tick those tasks, and stop at the checkpoint.

## Inputs

- **Required:** `docs/constitution.md`, and in the feature folder: `spec.md`, `plan.md`, `tasks.md`, **fresh** `analyze.md` with Critical Issues Count `0`.
- Optional: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`.
- If `.agents/skills/tdd/SKILL.md` exists, follow it for **test tasks**.

## Outputs

- Application code and tests named in the current phase.
- Updated checkboxes in `tasks.md` for completed tasks in that phase (`[x]`).
- Do not write `converge.md` or `analyze.md`. Do not commit or push unless the user asks.

Re-running continues from remaining unchecked tasks. Warn if `converge.md` already exists; do not delete it.

Custom `checklists/*.md` files are not a code gate.

## Phase selection

Phases in `tasks.md`: Setup, Foundational, each user story, Polish, then any **Convergence** phases `/sdd-converge` appended.

Run **only the first phase that still has `- [ ]` tasks**. Complete every task in that phase (respect `[P]` within the phase: different files may proceed together; same-file tasks stay sequential). Then **stop**.

Do not start the next phase in this invocation.

## Test tasks

When the current phase includes test tasks:

1. If `.agents/skills/tdd/SKILL.md` exists, read and follow it for those tasks (failing check, then implementation).
2. Else write the failing check first, then the code that makes it pass.
3. Use the test command recorded in `plan.md` Technical Context.

Skip this section when the phase has no test tasks.

## Hard rules

- Do not invent work outside `tasks.md`.
- Halt the phase if a non-`[P]` task fails; report the task id and error.
- After the phase: tick completed tasks, report what shipped, name the next incomplete phase **or** `/sdd-converge` / `/sdd-loop` if every phase is checked.

## When invoked

1. Resolve the feature folder. Run the Analyze gate (shared skill).
2. Identify the next incomplete phase.
3. Execute that phase only. Tick tasks in `tasks.md`.
4. **Stop** at the checkpoint.
