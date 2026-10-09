# sdd-loop

Run remaining implement phases, then converge until Converged.

## Instructions

Read and follow `.agents/skills/sdd-shared/SKILL.md`, then `.agents/skills/sdd-loop/SKILL.md` exactly as presented.

The skill will apply the analyze gate, repeat `/sdd-implement` for each incomplete phase, run `/sdd-converge`, and implement appended Convergence phases until Converged.

## Important

- Require a fresh `analyze.md` with Critical Issues Count 0
- Re-run analyze after Converge appends tasks (tasks.md is then newer)
- Do NOT commit unless asked
- `/sdd-implement` alone still runs only one phase
