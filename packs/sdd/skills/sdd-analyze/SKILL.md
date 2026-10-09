---
name: sdd-analyze
description: Read-only consistency analysis of spec.md, plan.md, and tasks.md. Write analyze.md. Use after /sdd-tasks, before implement or loop. Do not edit artifacts or code.
---

# SDD — Analyze

Identify inconsistencies, gaps, and constitution conflicts **before** code. Strictly read-only except writing `analyze.md`.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

Produce `analyze.md` with a Critical Issues Count. `/sdd-implement` and `/sdd-loop` refuse to code unless that count is `0` and the file is fresh.

## Inputs

- **Required:** `spec.md`, `plan.md`, `tasks.md` in the resolved folder. If any is missing, **stop** and name the prerequisite command.
- `docs/constitution.md` (conflicts with MUST principles are always CRITICAL).
- Optional: research, data-model, contracts, quickstart.

## Outputs

`analyze.md` only. Do not modify spec, plan, tasks, constitution, or source.

## Detection (cap 50 findings; summarize overflow)

- Duplication of FRs
- Ambiguity (vague adjectives, placeholders)
- Underspecification (verb without object/outcome; stories without acceptance)
- Constitution alignment (MUST violations; missing mandated gates)
- Coverage: FR/buildable SC/US acceptance with zero tasks; tasks with no mapped requirement
- Inconsistency: terminology drift, entities in plan missing from spec, task order vs Foundational-before-stories, conflicting requirements

Skip post-launch KPI SCs in coverage. Constitution is non-negotiable: do not recommend diluting a principle.

## Severity

- **CRITICAL:** constitution MUST violated; missing core artifact; P1 requirement with zero task coverage
- **HIGH:** conflicting/duplicate requirement; untestable acceptance; ambiguous security/performance
- **MEDIUM:** terminology drift; missing NFR tasks; underspecified edge
- **LOW:** wording

## Output outline — `analyze.md`

```markdown
# Analyze: <Feature>

**Folder:** `docs/sdd/<nnn>-<slug>/`
**Date:** YYYY-MM-DD

## Findings

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| C1 | Coverage | CRITICAL | spec.md FR-001 | No task | Add task in /sdd-tasks |

## Coverage

| Requirement Key | Has Task? | Task IDs | Notes |
|-----------------|-----------|----------|-------|

## Constitution

- <principle>: pass | fail — <note>

## Unmapped tasks

- T00n — …

## Metrics

- Total Requirements:
- Total Tasks:
- Coverage % (requirements with ≥1 task):
- Ambiguity Count:
- Duplication Count:
- **Critical Issues Count:** 0

## Next

- If Critical Issues Count is 0: `/sdd-implement` (one phase) or `/sdd-loop`
- If not 0: name **Specify**, **Plan**, or **Tasks** (the stage to reopen). Do not implement.
```

Finding IDs: prefix by category (`D` duplication, `A` ambiguity, `U` underspec, `C` constitution, `G` coverage, `I` inconsistency) plus a number.

## When invoked

1. Resolve the folder. Abort if spec/plan/tasks missing.
2. Build inventories; run detection; assign severity.
3. Write `analyze.md`.
4. **Stop.** If Critical Issues Count is 0, name `/sdd-implement` or `/sdd-loop`. Else name the reopen stage. Offer concrete remediations only if asked; do not apply them.
