# Git Workflow Examples

Complete examples for commits, PRs, and branches.

## Commit Messages

### Single feature

```
feat(TICKET-1598): add user team management form
```

### Bug fix

```
fix(TICKET-1234): clear error message on modal close
```

### Refactor with context

```
refactor(TICKET-1500): extract filtering logic to useFilteredCases hook
```

### Multiple files changed, single concern

```
feat(TICKET-1600): add empty state for case list
```

Not:

```
feat(TICKET-1600): add empty state component, update styles, add api call
```

### Test addition

```
test: add unit tests for case validation helpers
```

### Chore / dependencies

```
chore: upgrade @mui/material to v7.4
```

### What NOT to do

```
# BAD: multi-line with bullet points
feat(TICKET-1598): add team management

- Added TeamForm component
- Updated TeamPage component
- Added new constants

# BAD: past tense
feat(TICKET-1598): added team management

# BAD: trailing period
feat(TICKET-1598): add team management.

# BAD: too vague
fix(TICKET-1234): fix bug
```

---

## Pull Request Descriptions

### Feature PR (simple)

**Title:** `feat(TICKET-1598): add user team management form`

```markdown
## What was done

- Added `AddNewUserForm` component with role and permission fields in `features/team/components/`
- Updated `TeamPage.tsx` to integrate user creation flow
- Added user validation schema in `AddNewUserForm.schema.ts`
- Created `useAddNewUser` mutation hook in `features/team/api/`

**Logic:** +127 −12

## Ticket

TICKET-1598
```

### Feature PR with tests

**Title:** `feat(TICKET-1600): add empty state for case list`

```markdown
## What was done

- Added `EmptyScreen` component with illustration and CTA button
- Updated `Cases.tsx` to render `EmptyScreen` when no cases match filter
- Added empty state styling

**Logic:** +135 −8 | **Tests:** +68 −0

## Tests

`EmptyScreen.test.tsx` (4 tests):

- Renders empty message and CTA button
- Navigates to create page on CTA click

`Cases.test.tsx` (2 tests):

- Shows empty state when cases array is empty
- Shows empty state when filter matches no cases

## Ticket

TICKET-1600
```

### Feature PR with design rationale

**Title:** `feat(TICKET-1500): add AI evidence analysis for cases`

```markdown
## What was done

- Added `AnalyzeButton` component in `features/cases/components/AnalyzeButton/`
- Created `useAnalyzeEvidence` mutation hook for GraphQL endpoint
- Updated `CaseDetailsEvidenceItemsPage` to include analysis UI
- Added analysis result display component

**Logic:** +189 −14

**Why GraphQL mutation over REST endpoint:**

- **REST endpoint** — would bypass Apollo cache and require manual cache updates
- **Serverless function** — adds deployment complexity for a simple operation
- **GraphQL mutation** — integrates with existing Apollo cache, reuses auth middleware, consistent with project patterns

## Ticket

TICKET-1500
```

### Bug fix PR

**Title:** `fix(TICKET-1234): clear error message on modal close`

```markdown
## What was done

- Fixed error state not resetting when form dialog closes in `CreateCasePage.tsx`
- Removed redundant useEffect causing re-renders in `CaseDetailsPage.tsx`

**Logic:** +6 −11

## Ticket

TICKET-1234
```

### Refactor PR

**Title:** `refactor: simplify cases API layer`

```markdown
## What was done

- Extracted shared query config to `api/graphql/client/client.ts`
- Simplified error handling in `errorLink.ts`
- Removed unused helper functions from `utils/misc.ts`

**Logic:** +45 −89
```

### What NOT to do in PR descriptions

```markdown
# BAD: too vague

## What was done

- Updated components
- Fixed some bugs

# BAD: obvious/filler bullets

## What was done

- Updated imports
- Fixed linting errors
- Ran prettier

# BAD: more than 7 bullets

## What was done

- Changed line 42 in CaseCard.tsx
- Changed line 55 in CaseCard.tsx
- Changed line 12 in ContactItem.tsx
- ...etc

# BAD: including alternatives without asking the user

## What was done

- Added caching layer
  **Why Redis over in-memory cache:**
- ...
  (should have asked the user if they want this section)
```

---

## Branch Names

### Feature with ticket

```
feature/TICKET-1598/user-team-management
feat/TICKET-1600/empty-state
```

### Bug fix with ticket

```
fix/TICKET-1234/modal-error-clear
```

### Without ticket

```
docs/update-readme
chore/upgrade-dependencies
test/add-hook-tests
refactor/simplify-api-layer
```

---

## Complete Workflow Example

Branch: `feature/TICKET-1598/user-team-management`

**Commits on the branch:**

```
feat(TICKET-1598): add AddNewUserForm component
feat(TICKET-1598): integrate form with team page
feat(TICKET-1598): add user role validation schema
```

**PR:**

Title: `feat(TICKET-1598): add user team management form`

```markdown
## What was done

- Added `AddNewUserForm` component with role and permission fields
- Updated `TeamPage.tsx` to integrate user creation flow
- Added Zod validation schema in `AddNewUserForm.schema.ts`
- Created `useAddNewUser` mutation hook

**Logic:** +127 −12

## Ticket

TICKET-1598
```
