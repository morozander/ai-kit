---
name: implement-and-review
description: Implement an approved plan with TDD, then run code-review. Use when following a docs/plans implementation plan after plan-verifier Pass 1, or when the user says implement the plan.
---

# Implement and review

Follow a written implementation plan with TDD. Review only after the last task.

1. Require a plan path (`docs/plans/YYYY-MM-DD-<name>.md`). If none is given and none is obvious, **stop** and tell the user to run `/plan`.
2. Read the plan. For **each** task, read and follow `.agents/skills/tdd/SKILL.md` (red → green, one slice). Tick that task’s verification boxes on the plan.
3. After the last task, clear session and read and follow `.agents/skills/code-review/SKILL.md` on the working tree. Implementor self-review is not a substitute.
4. Do not start code-review until implementation claims done. Do not commit or push unless the user asks.
