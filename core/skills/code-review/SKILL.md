---
name: code-review
description: Review uncommitted working-tree and staged changes for correctness, maintainability, and project conventions. Use after implementation is claimed done, or when the user asks for a code review.
---

# Code Review

Review uncommitted code changes in the current working tree and staging area.

## 1. Identify Changes

Run the following in parallel to understand the full scope of changes:

- `git status` — list all modified, staged, and untracked files.
- `git diff` — show unstaged working-tree changes.
- `git diff --staged` — show staged changes.
- `git log --oneline -5` — recent commits for context on the current branch direction.

If both staged and unstaged changes exist, review them together as a single logical changeset.

## 2. Understand Intent

Before analyzing code quality, determine **what** the changes are trying to accomplish:

- Infer the purpose from file names, function signatures, variable names, and diff context.
- If commit messages or branch names provide context, use them.
- Identify whether the changeset is a new feature, bug fix, refactor, or configuration change.

## 3. In-Depth Analysis

Evaluate every changed file against these pillars:

### Correctness

- Does the code achieve its stated purpose without bugs or logical errors?
- Are conditional branches and loops correct? Are off-by-one errors possible?
- Are nullable/undefined values handled before use?
- Do GraphQL queries/mutations match the expected schema and variable types?

### Maintainability

- Is the code clean, well-structured, and modular?
- Does it follow the project's established patterns (feature-based modules, hook extraction, component file conventions)?
- Are there any violations of single responsibility — components doing too much, hooks with mixed concerns?
- Could any logic be extracted into a reusable hook or utility?

### Readability

- Are names (variables, functions, components, files) descriptive and consistent with the codebase?
- Is complex logic self-explanatory, or does it need clarifying comments?
- Does the code follow the project's formatting and style conventions?

### Efficiency

- Are there unnecessary re-renders (missing `useMemo`, `useCallback`, or improper dependency arrays)?
- Are API calls made efficiently (avoiding N+1 queries, redundant fetches, missing cache policies)?
- Are large lists or datasets handled with pagination or virtualization where appropriate?

### Security

- Is user input validated and sanitized before use?
- Are there any hardcoded secrets, tokens, or credentials?
- Are sensitive data (passwords, PII) accidentally logged or exposed in the UI?
- Are GraphQL error responses handled without leaking internal details?

### Edge Cases and Error Handling

- Does the code handle empty states, null responses, network failures, and unexpected data shapes?
- Are loading and error states properly surfaced to the user?
- Are form validations comprehensive (Zod schemas covering all constraints)?

### Testability

- Is the new or modified code structured in a way that can be tested?
- Are there missing test cases that would improve coverage or catch regressions?
- Suggest specific test scenarios if gaps are found.

## 4. Provide Feedback

Structure the review output as follows:

### Summary

A concise high-level overview: what the changeset does and the overall impression.

### Findings

Group findings by severity:

- **Critical** — Bugs, security vulnerabilities, data loss risks, or breaking changes that **must** be fixed.
- **Improvements** — Suggestions that meaningfully improve quality, performance, or maintainability. Explain **why** the change matters.
- **Nitpicks** _(optional)_ — Minor style or formatting issues. Only include if they violate project conventions.

For each finding:

1. Reference the file and relevant line range.
2. Explain the problem clearly.
3. Provide a concrete fix or code suggestion.

### Verdict

End with a clear recommendation:

- **Approved** — Changes are solid. Acknowledge specific strengths of the contribution.
- **Approved with suggestions** — No blockers, but improvements are recommended.
- **Request changes** — Critical issues must be resolved before merging. List them explicitly.

### Tone Guidelines

- Be constructive, specific, and respectful.
- Always explain **why** a change is needed, not just what to change.
- Praise good patterns and thoughtful decisions when you see them.
- Distinguish between personal preference and project convention.
