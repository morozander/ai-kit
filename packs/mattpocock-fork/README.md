# Matt Pocock fork

Editable copy of the idea-to-ship engineering skills and the productivity skills that sit beside them. Stack-neutral. `skills-main/` in this repo is reference only. It is not installed with the pack. There is no CLI.

Install this pack beside `core`. This pack supplies `tdd`, `grilling`, `grill-with-docs`, `domain-modeling`, and `codebase-design`. `core` supplies `/code-review`. There is no shared skill name, so you do not need `--force`.

`/feature-dev`, `/implement-and-review`, and `/grill-spec` (from `core`) need this pack for `tdd` and grilling. `/implement` and `/implement-spec` need `core` for `/code-review`.

`/feature-dev` still writes `docs/specs/` and `docs/plans/`. This pack writes `GLOSSARY.md`, `docs/adr/`, `docs/agents/`, and `.scratch/`.

This README stays in the kit. `install-into.sh` copies skills and commands only; it does not copy this file.

## Install

From the kit root:

```bash
sh core/scripts/install-into.sh --target /path/to/project --pack core
sh core/scripts/install-into.sh --target /path/to/project --pack mattpocock-fork --link
```

Skills land in `.agents/skills/`. Commands land in `.agents/commands/`. Run `/setup-matt-pocock-skills` once in the target project before the other engineering skills.

## Main flow

```text
/setup-matt-pocock-skills
/grill-with-docs
  → /to-spec → /to-tickets → /implement  (or /implement-spec)
  → /tdd + /code-review → /pr → /retro
On-ramps: /triage, /diagnosing-bugs, /wayfinder
Standalone: /grill-me, /handoff, /teach, /to-questionnaire, /wait-what
```

`/ask-matt` routes among these. Model-invoked skills (`grilling`, `tdd`, `domain-modeling`, `codebase-design`, `diagnosing-bugs`, `prototype`, `research`, `pr`, `writing-for-agents`) have no slash command. Other skills read `.agents/skills/<name>/SKILL.md`.

## Skills and commands

| Skill / command | Role | Main output |
|-----------------|------|-------------|
| `/setup-matt-pocock-skills` | Once per repo: tracker, triage labels, domain layout | `docs/agents/`, `## Agent skills` in `AGENTS.md` or `CLAUDE.md` |
| `/ask-matt` | Which skill or flow fits | — |
| `/grill-with-docs` | Interview plus glossary and ADRs | `GLOSSARY.md`, `docs/adr/` |
| `/to-spec` | Conversation → spec on the tracker | issue, or `.scratch/<feature>/spec.md` |
| `/to-tickets` | Spec → tracer-bullet tickets with blockers | tracker issues, or `.scratch/<feature>/issues/` |
| `/implement` | One ticket or same-window build | code, then `/code-review` |
| `/implement-spec` | Whole spec on one integration branch | code, then one `/code-review` |
| `/triage` | Incoming bugs and requests | triage labels, agent brief |
| `/wayfinder` | Multi-session decision map | `wayfinder:map` tickets, or `.scratch/<effort>/map.md` |
| `/improve-codebase-architecture` | Deepening survey, then grill | temp HTML report, glossary, optional ADR |
| `/retro` | Environment improvements after a session | checks, standards, steering notes |
| `/grill-me` | Interview with no local docs | — |
| `/handoff` | Continuation doc for another session | temp markdown |
| `/teach` | Multi-session teaching workspace | files in the current directory |
| `/to-questionnaire` | Questions for someone else | markdown questionnaire |
| `/wait-what` | Re-explain a message that did not land | — |
| `grilling` | Interview primitive | — |
| `domain-modeling` | Glossary and ADR discipline | `GLOSSARY.md`, `docs/adr/` |
| `codebase-design` | Deep-module vocabulary | — |
| `tdd` | Red-green loop at agreed seams | tests and code |
| `diagnosing-bugs` | Feedback loop for a hard bug | regression test |
| `prototype` | Throwaway answer to a design question | `prototype/<name>` branch |
| `research` | Cited notes from primary sources | markdown in the repo |
| `pr` | Pull request body shape | PR description |
| `writing-for-agents` | How to write docs agents consume | — |

`/code-review` is not in this pack. It stays in `core`.
