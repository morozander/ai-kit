---
name: sdd-plan
description: Write the SDD design bundle (plan.md, research, data-model, quickstart, optional contracts) for a feature folder. Do not write tasks.md or code.
---

# SDD — Plan

Turn an approved spec into a technical design. Tasks and implementation stay in later stages.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

Choose approach, structure, and contracts so `/sdd-tasks` can emit an executable checklist without inventing design.

## Inputs

- **Required:** `docs/constitution.md` and `spec.md` in the resolved folder.
- Existing codebase: real directories, patterns, and the project's test command when one exists.

## Outputs (this feature folder only)

| File | When |
|------|------|
| `plan.md` | always |
| `research.md` | always (each tech choice) |
| `data-model.md` | always (entities, fields, rules, states) |
| `quickstart.md` | always (run/validation guide) |
| `contracts/` | only if the feature exposes an external interface |

Do **not** create `tasks.md`. Re-running overwrites only the files in the table. If `tasks.md`, `analyze.md`, or `converge.md` exists, **warn**; do not delete them.

`quickstart.md` must not contain implementation bodies, migrations, or full test suites.

Ignore post-launch KPI-style success criteria (e.g. "reduce support tickets 50%") when designing build work. Use buildable FR/SC/US acceptance only.

## Hard rules

- If `spec.md` still contains `[NEEDS CLARIFICATION]`, **stop**. Do not write the bundle. Name `/sdd-clarify`.
- No application source code in any plan artifact.
- Constitution check **before** research and **again** after design. Unjustified violations: **stop**, do not write the bundle. Justified violations go only in Complexity Tracking.
- Do not leave `NEEDS CLARIFICATION` in `plan.md` after research.
- Stack follows the repo and constitution. Do not invent a stack.

## Output outline — `plan.md`

```markdown
# Implementation Plan: <Feature>

**Spec:** `docs/sdd/<nnn>-<slug>/spec.md`
**Constitution:** `docs/constitution.md`

## Summary

<requirement + chosen approach>

## Technical Context

- Language/Version:
- Primary Dependencies:
- Storage:
- Testing: <command to run, from the repo>
- Target Platform:
- Project Type:
- Performance / Constraints / Scale: <or N/A>

## Constitution Check

*Gate before research; re-check after design.*

- <principle>: pass | fail — <note>

## Project Structure

### Documentation (this feature)

docs/sdd/<nnn>-<slug>/
  spec.md, plan.md, research.md, data-model.md, quickstart.md
  checklists/
  contracts/     # omit if unused
  tasks.md       # later, /sdd-tasks
  analyze.md     # later, /sdd-analyze
  converge.md    # later, /sdd-converge

### Source Code

<tree of real or planned paths in this repo>

**Structure Decision:** <why this layout>

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| <omit table if none> | | |
```

## Output outline — `research.md`

```markdown
# Research

## <Topic>

- **Decision:**
- **Rationale:**
- **Alternatives considered:**
```

## Output outline — `data-model.md`

```markdown
# Data model

## <Entity>

- Fields: <name, type, constraints quoted for tasks>
- Relationships:
- Validation / state transitions:
```

## Output outline — `quickstart.md`

```markdown
# Quickstart

## Prerequisites

## Validate

1. <command>
2. Expected: <observable>
```

## When invoked

1. Resolve the feature folder. Read constitution and `spec.md`.
2. If `[NEEDS CLARIFICATION]` remains, **stop** and name `/sdd-clarify`.
3. Run the constitution gate. On failure with no justification, **stop**.
4. Explore the repo. Write `research.md`, then `data-model.md`, `quickstart.md`, and `contracts/` if needed.
5. Fill `plan.md`. Re-run the constitution gate. On new unjustified failure, **stop** and do not leave a half-written bundle as done.
6. **Stop.** Name `/sdd-tasks` next. Do not implement.
