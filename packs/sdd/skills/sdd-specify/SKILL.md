---
name: sdd-specify
description: Write a WHAT-not-HOW spec.md under docs/sdd/<nnn>-<slug>/. Use after a constitution exists. Do not plan, design files, or write code.
---

# SDD — Specify

Write a feature specification from the user's description in one pass. Code serves this spec.

First: read `.agents/skills/sdd-shared/SKILL.md` and follow folder allocation there.

## Objective

Record what to build and how success is judged, without how to implement it.

## Inputs

- **Required:** `docs/constitution.md`. If missing, **stop** and tell the user to run `/sdd-constitution`.
- Arguments: feature description, optional existing folder to update.
- Constitution principles (requirements must not contradict them).

## Outputs

- `docs/sdd/<nnn>-<slug>/spec.md`
- `docs/sdd/<nnn>-<slug>/checklists/requirements.md` (spec-quality; tick items this pass can prove)
- `docs/sdd/current.md` (shared resolver)

Re-running overwrites only `spec.md` and `checklists/requirements.md`. Warn if later artifacts exist; do not delete them.

## Hard rules

- WHAT, not HOW. No file map, no libraries, no code, no signatures.
- At most **three** `[NEEDS CLARIFICATION]` markers. Prefer a documented default in **Assumptions** over a fourth marker.
- No interview loop. Do not call grilling, `/grill-spec`, or `/sdd-clarify` in this invocation.
- Do not write `docs/specs/` or `docs/plans/`.
- Do not write plan, tasks, or code.
- Success criteria MUST be measurable and technology-agnostic (user/business outcomes, not API latency or frameworks).

## Output outline — `spec.md`

```markdown
# Spec: <Feature name>

**Folder:** `docs/sdd/<nnn>-<slug>/`
**Constitution:** `docs/constitution.md`

## Summary

<2–4 sentences>

## User stories

### US1 — <title> (P1)

As a <role>, I want <capability> so that <outcome>.

**Why this priority:** <why P1 vs later>

**Independent test:** <how to verify this story alone>

**Acceptance:**

- Given <context>, when <action>, then <observable result>.
- Given <edge>, when <action>, then <result>.

### US2 — <title> (P2)

…

## Edge cases

- <boundary or failure>

## Functional requirements

- **FR-001**: <one testable sentence>
- **FR-002**: …

## Key entities

- **<Entity>**: <what it is; attributes in product language, not schema>

Omit this section if the feature has no lasting data.

## Success criteria

- **SC-001**: <measurable, technology-agnostic outcome>
- **SC-002**: …

## Assumptions

- <default used because the description omitted it>

## Out of scope

- <bounded decline>

## Clarifications

- [NEEDS CLARIFICATION]: <question> (omit section if none; max 3)
```

## Output outline — `checklists/requirements.md`

```markdown
# Specification Quality Checklist: <Feature>

**Feature:** `spec.md`

## Content quality

- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value
- [ ] All mandatory sections completed

## Requirement completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable and technology-agnostic
- [ ] Acceptance scenarios and edge cases are defined
- [ ] Scope is bounded; assumptions documented

## Feature readiness

- [ ] Each FR has a path to acceptance
- [ ] User stories cover the primary flow
- [ ] No HOW leaked into the spec
```

Tick an item only when the spec as written satisfies it. Leave `[NEEDS CLARIFICATION]` items unchecked.

## When invoked

1. Confirm `docs/constitution.md` exists and read it.
2. Allocate or reuse the feature folder (shared skill). Write `docs/sdd/current.md`.
3. Write `spec.md` from the argument. Flag constitution conflicts as `[NEEDS CLARIFICATION]` or stop if a principle is clearly violated.
4. Write and tick `checklists/requirements.md`.
5. **Stop.** If Clarifications is non-empty, name `/sdd-clarify` next. Else name `/sdd-plan`. Mention `/sdd-checklist` as optional.
