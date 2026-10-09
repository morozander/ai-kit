---
name: sdd-shared
description: Shared SDD feature-folder resolution, current.md pointer, and the analyze gate used by implement and loop. Read this first in every SDD skill. Not a user-facing command.
---

# SDD — Shared

Read this file first in every SDD skill. Do not invent a second way to pick the feature folder.

## Constitution

Project principles live at `docs/constitution.md`. That file is not `AGENTS.md`. Stages after constitution **stop** if it is missing.

## Active feature — `docs/sdd/current.md`

One path, no other metadata:

```markdown
# Current SDD feature

`docs/sdd/001-slug/`
```

The backtick line is the feature folder (trailing slash optional).

## Resolve the feature folder

1. If the user argument names a folder (`docs/sdd/<nnn>-<slug>` or `<nnn>-<slug>`), use it (create only when the current skill is Specify). Then **write** `docs/sdd/current.md` to that path.
2. Else if `docs/sdd/current.md` exists, parse the path. If that directory is missing, **stop** and ask.
3. Else **stop** and ask which folder. Do **not** pick the highest-numbered `docs/sdd/` directory.

`/sdd-constitution` does not resolve a feature folder unless the user named one.

## Specify — allocate a new folder

When Specify has no named folder:

1. List `docs/sdd/` directories matching `NNN-slug` (three-digit prefix). Ignore `current.md`.
2. Next id = highest `NNN` plus one, zero-padded (`001` if none).
3. Slug from the feature name: lowercase, hyphens, no spaces, 2–4 words.
4. Create `docs/sdd/<nnn>-<slug>/` and write `docs/sdd/current.md`.

## Overwrite rule

A stage overwrites **only its own artifacts**. If later artifacts exist in the folder, **warn**; do not delete them.

| Stage | Own artifacts |
|-------|----------------|
| Specify | `spec.md`, `checklists/requirements.md` |
| Clarify | `spec.md` (in-place edits), retick `checklists/requirements.md` |
| Checklist | `checklists/<domain>.md` (append-only) |
| Plan | `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, `contracts/` |
| Tasks | `tasks.md` |
| Analyze | `analyze.md` |
| Implement | application code named by the current phase; tick boxes in `tasks.md` |
| Converge | `converge.md`; may **append** a Convergence phase to `tasks.md` |
| Loop | none of its own; runs Implement and Converge |

## Analyze gate (Implement and Loop only)

Before any application code:

1. Resolve the feature folder.
2. Require `analyze.md` in that folder. If missing → **stop**, name `/sdd-analyze`.
3. **Stale:** if `spec.md`, `plan.md`, or `tasks.md` has a newer mtime than `analyze.md` → **stop**, name `/sdd-analyze`.
4. Read **Critical Issues Count** (or equivalent) in `analyze.md`. If missing or not `0` → **stop**, name `/sdd-analyze` or the stage that file named.
5. Custom files under `checklists/` (except the gate above) are **not** a code gate.

## Do not use

`docs/specs/` and `docs/plans/` belong to `/feature-dev`. SDD artifacts stay under `docs/sdd/` plus `docs/constitution.md`.
