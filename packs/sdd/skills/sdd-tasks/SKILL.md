---
name: sdd-tasks
description: Write tasks.md checklist lines from an SDD design bundle. Use after /sdd-plan. Do not write implementation code.
---

# SDD — Tasks

Turn the design bundle into a dependency-ordered checklist an implementor can execute without another design pass.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

Produce `tasks.md` with exact file paths, story labels, and quoted data-model constraints. Implementation code is forbidden here.

## Inputs

- **Required:** `plan.md` and `spec.md` in the resolved folder.
- Optional: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`.
- `docs/constitution.md` if present.
- Arguments may request tests (`TDD`, `include tests`).

## Outputs

`docs/sdd/<nnn>-<slug>/tasks.md`

Re-running overwrites only `tasks.md`. If `analyze.md` or `converge.md` exists, **warn**; do not delete them.

## Hard rules

- **No code blocks.** No function bodies, no snippets.
- Every line MUST match:

```text
- [ ] Tnnn [P?] [USn?] Description with exact file path
```

  - Checkbox and sequential id (`T001`, `T002`, …) in execution order.
  - `[P]` only if the task uses different files and has no dependency on incomplete work.
  - `[USn]` required on user-story phase tasks; omit on Setup, Foundational, Polish, and later Convergence phases (those are appended by `/sdd-converge`).
  - Description includes an exact path (exception: a setup task that only creates empty directories named in `plan.md`).
- Quote field constraints from `data-model.md` in the task line (max length, required, enums).
- **Test tasks only** if `spec.md` asks for tests or the user argument asks. Place them in that story's phase **before** implementation tasks for the same story.
- Do not write source files.
- Map buildable FR/SC/US acceptance to tasks. Skip post-launch KPI-style SCs.

## Phases (required order)

1. **Setup** — project/layout init from `plan.md`.
2. **Foundational** — blocking shared work. No user story starts until this phase is complete.
3. **One phase per user story** in spec priority (`US1` P1 first). Each phase: goal, independent test (copy from spec), optional test tasks, implementation tasks, checkpoint.
4. **Polish** — cross-cutting; include running `quickstart.md`.

Do not invent a Convergence phase here.

## Output outline

```markdown
# Tasks: <Feature>

**Folder:** `docs/sdd/<nnn>-<slug>/`
**Plan:** `plan.md` | **Spec:** `spec.md`

## Format

`- [ ] Tnnn [P?] [USn?] Action with exact file path`

## Phase 1: Setup

- [ ] T001 …

## Phase 2: Foundational

- [ ] T00n …

**Checkpoint:** foundation ready.

## Phase 3: User Story 1 — <title> (P1)

**Goal:** …
**Independent test:** …

### Tests (omit this heading if tests were not requested)

- [ ] T00n [P] [US1] …

### Implementation

- [ ] T00n [US1] … in `path`

**Checkpoint:** US1 independently testable.

## Phase N: Polish

- [ ] Txxx Run validation in `docs/sdd/<nnn>-<slug>/quickstart.md`

## Dependencies

- Setup → Foundational (blocks all stories) → stories (priority or [P] across stories) → Polish
```

## When invoked

1. Resolve the folder. Read spec, plan, and any design extras.
2. Map stories, entities, and contracts to phases.
3. Write `tasks.md`. Replace sample lines; do not leave placeholders.
4. Report task count per story, parallel `[P]` opportunities, and MVP (typically US1).
5. **Stop.** Name `/sdd-analyze` next (not `/sdd-implement`).
