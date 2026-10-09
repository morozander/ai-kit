---
name: sdd-converge
description: Assess code against spec/plan/tasks, write converge.md, and append remaining work as a Convergence phase on tasks.md. Do not edit spec, plan, constitution, or application code.
---

# SDD — Converge

Close the gap between artifacts and the current code. Report in `converge.md`. Append new tasks when work remains. Completing those tasks is `/sdd-implement` or `/sdd-loop`.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

Inspect **code**, not `[x]` checkboxes. If the implementation already satisfies buildable intent, leave `tasks.md` unchanged and verdict **Converged**.

## Inputs

- **Required:** `docs/constitution.md` and the feature folder: `spec.md`, `plan.md`, `tasks.md`.
- Optional: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`, working tree.
- If `.agents/skills/code-review/SKILL.md` exists, read and follow it on the working tree and **cite** it in Evidence. Review does not authorize edits to spec, plan, or tasks.
- Do **not** require `.agents/agents/plan-verifier.md`.

## Outputs

- Always: `converge.md` (overwrite).
- If actionable findings: **append** `## Phase N: Convergence` to `tasks.md` (never rewrite, renumber, or delete existing tasks, including prior Convergence phases).
- If no actionable findings: `tasks.md` **byte-for-byte unchanged** (no empty Convergence header).
- Do not edit spec, plan, constitution, or application source.

## Evidence rules

- Task checkboxes are **claims**, not proof. Verify behavior in files and by running the plan test command and `quickstart.md` scenarios.
- Trace FR-nnn, buildable SC-nnn, and US acceptance (e.g. `US1/AC2`). Skip post-launch KPI SCs.
- Bound the search to paths named in plan/tasks plus keyword hits for those requirements. Do not invent extra scope.

## Gap types

- `missing` — required work absent
- `partial` — present but incomplete
- `contradicts` — conflicts with intent or a constitution MUST
- `unrequested` — code not called for (append a review/justify-or-remove task; do not delete code here)

Severity: CRITICAL (MUST / P1 baseline missing or contradicting) → HIGH (core FR/AC missing or partial) → MEDIUM (secondary partial or unclear extra) → LOW (polish).

## Output outline — `converge.md`

```markdown
# Converge: <Feature>

**Folder:** `docs/sdd/<nnn>-<slug>/`
**Verdict:** Converged | tasks_appended

## Findings

| ID | Gap Type | Severity | Source | Evidence | Remaining Work |
|----|----------|----------|--------|----------|----------------|
| F1 | missing | HIGH | FR-008 | `path` — <what was observed> | <task intent> |

Omit the table when Verdict is Converged.

## Traceability

| Requirement | Code evidence (path or command) | Result |
|-------------|----------------------------------|--------|
| FR-001 / US1/AC1 | `path` / `<test command>` | pass \| fail \| missing |

Do not use task checkbox state as evidence.

## Evidence

- Tests: <command and outcome>
- Quickstart: <scenario and outcome>
- Review: <citation or "code-review skill not installed">

## Constitution

- <principle>: pass | fail — <note>

## Next

- Converged: stop. `/commit` only if the user asks.
- tasks_appended: `/sdd-implement` (Convergence phase) or `/sdd-loop`.
```

## Append contract (only when findings exist)

1. `M` = max existing `Tnnn`. `N` = highest phase number + 1.
2. Append:

```markdown
## Phase N: Convergence

- [ ] T{M+1} <imperative> per <source-ref> (<gap-type>) in `path`
```

Constitution-violation tasks first, labeled CRITICAL. Never reuse ids. A later converge adds a **new** phase below old ones.

## When invoked

1. Resolve the folder. Load artifacts. Assess code.
2. Present findings in-session, then write `converge.md`.
3. Append Convergence tasks or leave `tasks.md` untouched.
4. **Stop.** Do not implement appended tasks in this skill.
