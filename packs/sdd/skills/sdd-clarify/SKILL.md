---
name: sdd-clarify
description: Ask up to 5 sequential clarification questions and encode answers into spec.md. Use after /sdd-specify when requirements are underspecified. Do not plan or write code.
---

# SDD — Clarify

Reduce ambiguity in the active feature spec. Encode each accepted answer into `spec.md` before asking the next question.

First: read `.agents/skills/sdd-shared/SKILL.md` and resolve the feature folder.

## Objective

At most **five** high-impact questions, one at a time. After the loop, the spec is ready for `/sdd-plan`.

## Inputs

- **Required:** `spec.md` in the resolved folder. If missing, **stop** and name `/sdd-specify`.
- `docs/constitution.md` if present.
- `checklists/requirements.md` if present (re-tick after edits).

## Outputs

In-place updates to `spec.md` only (plus checkbox state in `checklists/requirements.md` when that file exists). Do not write plan, tasks, or code.

## Hard rules

- Maximum **5** asked questions per invocation. Retries on the same question do not count as new questions.
- Present **exactly one** question at a time. Wait for the answer before the next. Never preview the queue.
- Each question is either 2–5 mutually exclusive options or a ≤5 word short answer.
- Recommend an option (or a suggested short answer) with 1–2 sentences of why.
- Skip questions that would not change architecture, data, acceptance tests, UX, ops, or compliance.
- Do not ask implementation-method or stack-comparison questions unless they block functional clarity.
- User may stop early (`done`, `good`, `no more`).
- If there are no critical ambiguities, say so and name `/sdd-plan`. Do not invent filler questions.

## Question format

```markdown
**Question:** <full interrogative>?

Why it matters: <one sentence>

**Recommended:** Option A — <reasoning>

| Option | Description |
|--------|-------------|
| A | … |
| B | … |
| C | … |

Reply with the letter, "yes"/"recommended" to accept, or a short answer (≤5 words).
```

The question line must stand alone as a question. Do not use a topic label as the prompt.

## After each accepted answer

1. Ensure `## Clarifications` exists (after Summary if missing), with `### Session YYYY-MM-DD` for today.
2. Append `- Q: <question> → A: <answer>`.
3. Patch the matching section (FR, story, edge case, SC, entity, terminology). Replace obsolete text; do not leave contradictions.
4. Save `spec.md` immediately.
5. If `checklists/requirements.md` exists, re-evaluate only checkbox markers.

## Coverage scan (internal)

Mark Clear / Partial / Missing, then queue by impact: scope > security/privacy > UX > everything else. Categories: functional scope, domain/data, interaction/UX, NFRs, integrations, edge/failure, constraints, terminology, completion signals, placeholders/vague adjectives.

## When invoked

1. Resolve the folder. Load spec (and constitution).
2. Scan. If nothing material, **stop** and name `/sdd-plan`.
3. Ask up to 5 questions, integrating after each answer.
4. Report: questions asked, sections touched, remaining deferred items.
5. **Stop.** Name `/sdd-plan` next (or `/sdd-clarify` again if high-impact items were deferred because of the quota).
