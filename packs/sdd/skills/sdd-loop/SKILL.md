---
name: sdd-loop
description: Run remaining SDD implement phases then converge until Converged. Use after a fresh zero-CRITICAL analyze.md when the user wants the automatic implement-converge loop. Do not commit.
---

# SDD — Loop

Conductor. Read each listed skill and execute it in this session. Do not assume a subagent spawn.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder. Apply the **Analyze gate** from that file (same as `/sdd-implement`).

## Objective

Finish remaining `tasks.md` phases, then close implement → converge until verdict **Converged**.

`/sdd-implement` stays one phase per **its** invocation. This skill is the one that repeats those invocations.

## Sequence

1. Analyze gate. On failure, **stop** (do not code).
2. While `tasks.md` has a phase with `- [ ]` tasks: read and follow `.agents/skills/sdd-implement/SKILL.md` for **that next phase only**, then continue the while-loop in this session.
3. Read and follow `.agents/skills/sdd-converge/SKILL.md`.
4. If Converge appended a Convergence phase: follow Implement for **that** phase only, then follow Converge again.
5. Repeat step 4 until Converge reports **Converged**, or a skill stops (analyze stale after a tasks.md append counts as: after append, **re-run** `.agents/skills/sdd-analyze/SKILL.md` before the next Implement if `tasks.md` is now newer than `analyze.md`; if that analyze has Critical ≠ 0, **stop** and name the stage).
6. Do not commit or push unless the user asks.

After Converge appends tasks, `tasks.md` is newer than `analyze.md`. Follow shared Analyze gate: run Analyze (read-only report) before implementing the Convergence phase. If the new tasks are the remediation (Critical should be 0 if the only change is appended work that covers prior gaps), proceed. If Analyze still reports Critical, **stop**.

## Hard rules

- Do not skip Analyze after a Convergence append.
- Do not edit spec or plan.
- Stop immediately on a failed non-`[P]` implement task.
- Custom checklists are not a code gate.

## When invoked

1. Shared resolve + Analyze gate.
2. Drain existing incomplete phases via Implement.
3. Converge; implement appended phases; converge until Converged or stop.
4. Report verdict and paths. **Stop.**
