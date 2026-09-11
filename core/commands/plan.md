# Plan

Create a step-by-step implementation plan for an approved design or feature.

## Instructions

Read and follow the writing-plans skill at `.agents/skills/writing-plans/SKILL.md` exactly as presented.

The skill will guide you through:

- Understanding the approved design or feature spec
- Breaking work into 2-5 minute tasks
- Specifying exact file paths, code, and verification steps
- Ordering tasks sequentially with correct dependency order
- Writing the plan to `docs/plans/`

## Workflow

### 1. Gather Context

Before writing the plan, understand the full scope:

- Read the approved design, feature spec, or user description thoroughly.
- Explore the existing codebase to identify relevant files, patterns, and conventions.
- Identify which feature module (`src/features/`) this belongs to, or whether new modules are needed.
- Check for existing components, hooks, or utilities that can be reused.

### 2. Draft the Plan

Follow the plan template from the writing-plans skill:

- **Goal** — 1-2 sentence summary.
- **Architecture Overview** — how the pieces fit together, files to create, files to modify.
- **Tasks** — sequential, small, verifiable steps.

### 3. Validate the Plan

Before finalizing, check every task against these rules:

- [ ] Has an exact file path
- [ ] Includes the code to write or change (not vague descriptions)
- [ ] References existing project patterns where applicable
- [ ] Has a concrete verification step
- [ ] Is small enough for 2-5 minutes of work
- [ ] Does not depend on a later task

### 4. Write the Plan

Save the plan to `docs/plans/YYYY-MM-DD-<feature-name>.md` using today's date.

## Important

- Every task **must** have a verification step.
- Tasks should be small enough for 2-5 minutes each.
- Include exact file paths and code patterns.
- Reference existing project patterns (e.g., "follow the pattern in `useGetCases.ts`").
- If anything is unclear, note it as an **Open Question** in the plan rather than guessing.
