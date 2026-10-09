---
name: sdd-constitution
description: Write or amend docs/constitution.md for the SDD loop. Use when starting spec-driven development or changing project principles. Do not write feature specs or code.
---

# SDD — Constitution

Write or amend the project constitution. This file is the non-negotiable contract later SDD stages must obey. It is not `AGENTS.md`.

First: read `.agents/skills/sdd-shared/SKILL.md`.

## Objective

Capture principles, constraints, and quality gates that every later stage (`/sdd-specify` through `/sdd-loop`) must satisfy.

## Inputs

- Arguments: principles to record, or an amendment request.
- Existing `docs/constitution.md` when amending (merge; do not drop settled principles unless the user names them).
- Do not invent a product stack. Stay stack-neutral unless the user states a constraint.

## Outputs

`docs/constitution.md` (create `docs/` if needed).

Re-running this skill overwrites only `docs/constitution.md`. If any `docs/sdd/<nnn>-<slug>/` folders exist, warn that later artifacts may now conflict; do not delete them.

## Hard rules

- Do not write `spec.md`, plans, tasks, or code.
- Do not put kit-maintenance rules (symlinks, install) here.
- If the argument is a feature to build, extract that as a deferred intent; do not specify or implement it here.
- Running `/sdd-specify` is the approval to continue.

## Output outline

```markdown
# Constitution

## Purpose

<one paragraph: what this project is for>

## Principles

1. <non-negotiable>
2. <non-negotiable>

## Constraints

- <stack, security, ops, or process constraints the user stated>

## Quality gates

- <what must be true before a change is done, e.g. tests, review, no secrets>

## Amendments

Change this file only through `/sdd-constitution`. Specs and plans may not override it.
```

## When invoked

1. Read `.agents/skills/sdd-shared/SKILL.md`, then `docs/constitution.md` if it exists.
2. Fill the outline from the argument and the existing file.
3. Write `docs/constitution.md`.
4. **Stop.** Name `/sdd-specify` next. Summarize what changed in a few bullets. List deferred non-governance intents without executing them.
