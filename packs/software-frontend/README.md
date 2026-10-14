# Software Frontend pack

React-oriented skills and agents for SPA frontends: best practices, safe UI refactoring, unit tests, plus specialist agents for implementation, review, and refactoring.

This README stays in the kit. `install-into.sh` copies skills and agents only; it does not copy this file into a consuming project.

## Install

From the kit root:

```bash
sh core/scripts/install-into.sh --target /path/to/project --pack core
sh core/scripts/install-into.sh --target /path/to/project --pack software-frontend --link
```

Install `core` first — this pack depends on shared skills from core (tdd, code-review, etc.).

Use `--force` if those names already exist. Skills land in `.agents/skills/`; agents in `.agents/agents/`.

## Skills

| Skill | Purpose |
|-------|---------|
| `react-best-practices` | Component patterns, hooks, state management, styling, and testing conventions |
| `safe-ui-refactoring` | Incremental UI refactoring without breaking existing functionality |
| `writing-frontend-unit-tests` | Vitest/RTL test patterns for React components |

## Agents

| Agent | Purpose |
|-------|---------|
| `implementor` | Implements features following React best practices |
| `react-reviewer` | Reviews React code for patterns, performance, and maintainability |
| `refactoring-planner` | Plans safe refactoring strategies for UI components |

## Notes

- Assumes React 18+ with hooks
- Prefers MUI for styling (adjust patterns for other libraries)
- Uses Vitest + React Testing Library for tests
- Apollo Client patterns for GraphQL (adapt for other clients)
