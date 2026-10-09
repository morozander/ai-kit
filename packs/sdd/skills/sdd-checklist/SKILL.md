---
name: sdd-checklist
description: Generate reviewer-owned requirements-quality checklists (unit tests for English) under the feature checklists/ folder. Do not test implementation or write code.
---

# SDD — Checklist

Validate whether requirements are well-written, not whether the product works.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

Write or append `docs/sdd/<nnn>-<slug>/checklists/<domain>.md` whose items test completeness, clarity, consistency, measurability, and coverage of the spec (and plan/tasks if they exist).

## Inputs

- User argument: domain/theme (ux, api, security, performance, …) and any must-have items.
- `spec.md` (required). `plan.md` / `tasks.md` if present.
- `docs/constitution.md` if present.

If the argument is empty, ask up to **three** questions that change checklist content (scope, risk, depth). Skip a question that the argument already answered.

## Outputs

`checklists/<domain>.md` — create or **append**. Never delete existing items. Newly generated items stay `- [ ]`. `[x]` is for the **reviewer**, not this skill, and does **not** mean implementation is done.

`checklists/requirements.md` is owned by Specify/Clarify. Do not treat it as a custom checklist; do not overwrite it here unless the user explicitly asked to extend it.

This is **not** a code gate for `/sdd-implement`.

## Item rules

Every item is a question about what is **written** (or missing) in the spec/plan:

- Correct: "Are error responses specified for every failure mode? [Completeness]"
- Wrong: "Verify the API returns 200" / "Test the button click"

≥80% of items must cite `[Spec §…]`, `[Gap]`, `[Ambiguity]`, `[Conflict]`, or `[Assumption]`. IDs `CHK001`, `CHK002`, … continuing from the last id in that file.

Soft cap ~40 items; merge duplicates; group by quality dimension.

## Output outline

```markdown
# Checklist: <domain> — <Feature>

**Purpose:** Requirements quality (not implementation)
**Folder:** `docs/sdd/<nnn>-<slug>/`
**Ownership:** Reviewer ticks `[x]` when the requirement text is good enough.

## Completeness

- [ ] CHK001 Are … defined for …? [Completeness, Spec §…]

## Clarity

- [ ] CHK00n Is "<vague term>" quantified? [Clarity]

## Consistency

- [ ] CHK00n Do … and … agree? [Consistency]

## Coverage / edge cases

- [ ] CHK00n Are … requirements present or explicitly out of scope? [Gap]

## Notes

`/sdd-implement` does not modify these markers.
```

## When invoked

1. Resolve the folder. Read spec (and plan/tasks if useful).
2. Derive domain filename (`ux.md`, `security.md`, …).
3. Append items; leave them unchecked.
4. **Stop.** Report path, item count, created vs appended. Name `/sdd-plan` if plan is missing, else `/sdd-analyze` if `tasks.md` exists, else `/sdd-plan` or `/sdd-tasks` as appropriate.
