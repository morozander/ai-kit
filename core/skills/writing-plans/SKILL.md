---
name: writing-plans
description: Create detailed, step-by-step implementation plans from approved designs or feature specs. Use when the user says "plan this", "break this into tasks", asks for an implementation plan, or when a design is approved and implementation needs to be scoped.
---

# Writing Implementation Plans

Create sequential, verifiable implementation plans that a junior engineer with no project context can follow mechanically.

## When to Use

- After a design or feature spec is approved, before implementation begins
- User says "plan this", "break this into tasks", "create a plan"
- A feature needs to be scoped into discrete work units

## Spec input

Look for an approved spec in `docs/specs/` (`YYYY-MM-DD-<name>.md`). If a spec exists for this feature, **require its path** in the plan (e.g. under Goal or a **Spec** heading) and cover every acceptance criterion. Do not read specs from `docs/plans/`.

## Core Principles

| Principle      | Rule                                                                              |
| -------------- | --------------------------------------------------------------------------------- |
| **Audience**   | Enthusiastic junior engineer, zero project context. Be explicit about everything. |
| **Task size**  | 2–5 minutes each. If longer, split it.                                            |
| **Verifiable** | Every task has a concrete verification step.                                      |
| **Sequential** | Each task builds on the previous. No forward references.                          |
| **Complete**   | Exact file paths, function signatures, code patterns. No ambiguity.               |

## Plan Output Location

Write the plan to `docs/plans/YYYY-MM-DD-<name>.md`.

## Plan Template

```markdown
# Implementation Plan: <Feature Name>

**Spec:** `docs/specs/YYYY-MM-DD-<name>.md` (omit this line only if there is no spec)

## Goal

<1-2 sentence summary of what we're building>

## Architecture Overview

<Brief description of how the pieces fit together>

### Files to Create

- `path/to/new/file.ts` — purpose

### Files to Modify

- `path/to/existing/file.ts` — what changes

---

## Tasks

### Task 1: <Short descriptive title>

**File:** `path/to/file.ts`

**What to do:**

1. Step-by-step instructions
2. Include exact code to write or change
3. Reference existing patterns in the codebase

**Verification:**

- [ ] Failing test written first (red)
- [ ] Test passes after the change (green)
- [ ] How else to verify this task is complete

---

### Task 2: <Short descriptive title>

...
```

## Task Writing Rules

### Be Explicit

- Include the exact file path relative to project root
- Show the code to write, not "add a function that does X"
- Reference existing patterns: "follow the pattern in `useGetCases.ts`"
- Specify imports needed

### Be Small — One Task = One of These

- Create a single file with a clear purpose
- Add a single function, hook, or component
- Modify one section of an existing file
- Write a failing test, then make it pass (TDD pair)

If a task touches multiple files, split into separate tasks.

### Be Verifiable — Every Task Needs a Check

Every task that changes behavior **must** include TDD verification: a failing test first, then a passing test. Add other checks as needed:

- "Failing test written first (red); test passes after the change (green)"
- "Run `yarn dev` — app compiles without errors"
- "Visit `http://localhost:3000/cases` — new component renders"
- "Run `yarn lint` — no lint errors"
- "Check GraphQL response — returns expected data"
- "Verify no console errors in browser dev tools"

## Task Types for This Project

**GraphQL / API layer** (`src/api/`, `src/features/*/api/`):

- GraphQL query/mutation documents
- Codegen run (`yarn generate`)
- Apollo hooks (queries, mutations)

**Feature module** (`src/features/*/`):

- Zod schemas (`.schema.ts`)
- Component logic hooks (`useComponentName.ts`)
- Components (`.tsx`)
- Feature-specific hooks (`hooks/`)
- Zustand store slices (`store/`)

**Shared UI** (`src/components/`):

- Form fields (`form/`)
- Input components (`inputs/`)
- UI primitives (`ui/`)

**Pages & routing** (`src/pages/`, `src/router/`):

- Page components
- Route definitions with lazy loading

## Task Ordering

For a typical full-stack feature in this project, order as:

1. **GraphQL documents** — queries, mutations, fragments
2. **Codegen** — run `yarn generate` to produce types/hooks
3. **API hooks** — custom wrappers in `features/*/api/`
4. **Zod schemas** — form validation schemas
5. **Zustand store** — if feature needs client state
6. **Shared components** — reusable UI pieces (if any)
7. **Feature components** — feature-specific UI + logic hooks
8. **Pages** — page-level integration
9. **Routes** — wire up in router with lazy loading
10. **Polish** — error handling, loading states, edge cases

## Anti-Patterns

| Don't                    | Do Instead                             |
| ------------------------ | -------------------------------------- |
| "Implement the feature"  | Break into specific, single-file tasks |
| Task with >5 steps       | Split into multiple tasks              |
| Missing file paths       | Always include exact paths             |
| No verification step     | Add a concrete check for every task    |
| Task 3 depends on Task 5 | Reorder so dependencies come first     |
| One task changes 3 files | One task = one file = one concept      |
| Guess at unknowns        | Note as **Open Question** in the plan  |

## Example Task

```markdown
### Task 3: Create useGetCaseContacts query hook

**File:** `src/features/cases/api/case-contacts/queries/useGetCaseContacts.ts`

**What to do:**

1. Create the file with this structure (follow `useGetCases.ts` pattern):

\`\`\`typescript
import { useQuery } from '@apollo/client';
import { graphql } from '@/api/graphql/generated';

const GET_CASE_CONTACTS = graphql(`  query GetCaseContacts($caseId: ID!) {
    caseContacts(caseId: $caseId) {
      id
      name
      email
      role
    }
  }`);

export const useGetCaseContacts = (caseId: string) => {
return useQuery(GET_CASE_CONTACTS, {
variables: { caseId },
fetchPolicy: 'cache-and-network',
});
};
\`\`\`

2. Re-export from `src/features/cases/api/case-contacts/index.ts`

**Verification:**

- [ ] Failing test written first (red)
- [ ] Test passes after the change (green)
- [ ] `yarn generate` runs without errors
- [ ] `yarn build` compiles without type errors
- [ ] Hook returns data when called with a valid caseId
```

## After the plan is written

Read `.agents/agents/plan-verifier.md` and run **coverage-only** mode (Pass 1: spec → plan) with the spec path under `docs/specs/` and the new plan path. **Stop.** Do not implement until coverage is COVERED or the user accepts OUT OF SCOPE items.

## Notes

- Plans are living documents — update them as implementation reveals issues
- A good plan makes implementation nearly mechanical
- If unsure about a detail, note it as an **Open Question** rather than guessing
- The plan should be complete enough that someone new to the project can follow it
