---
name: grill-spec
description: Grill the user on a feature idea, then write a WHAT-not-HOW spec to docs/specs/. Use when starting a feature, capturing requirements, or the user says grill spec.
---

# Grill spec

Interview until shared understanding, then write the spec. Do not plan or write code.

1. Read and follow `.agents/skills/grilling/SKILL.md` until the frontier is empty and the user confirms a shared understanding.
2. Read and follow `.agents/skills/writing-specs/SKILL.md`. Save `docs/specs/YYYY-MM-DD-<name>.md`.
3. **Stop.** Suggest `/plan` next. Suggest `/brainstorm` only if the system shape is still unclear.
4. If glossary terms crystallized, mention `.agents/skills/grill-with-docs/SKILL.md` as an optional follow-up. Do not write ADRs unless the user asks.
5. A strong functional requirement is a contract with a:
5.1 ### Edge cases
* empty fields
* huge inputs
* odd formats
Decide the required behavior instead of leaving it to chance.
5.2 ### Out-of-scope inputs
Requests outside the feature's job.
Define a graceful decline so scope stays bounded.
5.3 ### Ambiguous requests
Vague or missing details.
Ask for clarification or apply a documented default.
