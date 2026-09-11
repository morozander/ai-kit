# Bootstrap Cursor + Claude Code (paste to an agent)

Fill **Project brief**, then send this entire file to an agent in an **empty folder**. The agent creates the repo layout. It must not invent a product, stack, UI, or domain facts that are not in the brief.

---

## Project brief (you fill this)

```
Project name:
Kind: (markdown coach | software app | other — one line)
One-line role: (who the agent is)
Reply language: (user’s language | always English | …)

Skills (kebab-case names, one per line; optional one-line purpose after —):
-

Commands (kebab-case, no slash; optional purpose after —):
-

Agents (kebab-case; first is the orchestrator):
-

Hard limits (bullets; copy into AGENTS.md as-is):
-

Generated artifacts dir (optional, e.g. result/):
First-session command order (optional, e.g. /setup-profile then /plan):
Install / dev / build / test / lint (software apps only; omit if none):
Extra source-of-truth dirs (optional, e.g. profile/):
```

If a list is empty, create only the orchestrator agent and a stub `AGENTS.md` file map. Do not invent extra skills or commands.

---



## You are the bootstrap agent

Create files in the current working directory. Do not commit unless the user asks.

### Layout (source of truth vs adapters)

**Real files only:**


| Path                              | Role                                                                                                   |
| --------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `AGENTS.md`                       | Master root context (Cursor, Codex)                                                                    |
| `.agents/skills/<name>/SKILL.md`  | Domain knowledge; add `reference.md` in the **same** folder only if the skill needs tables/matrices    |
| `.agents/agents/<name>.md`        | Subagents (Claude Code). Cursor reads these when a command says to                                     |
| `.agents/commands/<name>.md`      | Slash-command bodies: thin. Name skills to load and artifacts to write. Do not paste skill bodies here |
| `.agents/scripts/link.sh`         | Recreates adapters                                                                                     |
| `README.md`                       | Points at `AGENTS.md` and first-session commands                                                       |


**Relative symlinks, never copies of those bodies:**


| Adapter                      | Points to                                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------------------------ |
| `CLAUDE.md`                  | `AGENTS.md`                                                                                            |
| `.cursorrules`               | `AGENTS.md`                                                                                            |
| `.claude/skills/<name>`      | `../../.agents/skills/<name>` (**directory** link so `SKILL.md` + `reference.md` stay together)        |
| `.claude/agents/<name>.md`   | `../../.agents/agents/<name>.md`                                                                       |
| `.claude/commands/<name>.md` | `../../.agents/commands/<name>.md`                                                                     |
| `.cursor/commands/<name>.md` | `../../.agents/commands/<name>.md`                                                                     |


Do **not** create `.cursor/skills/` adapters — Cursor loads `.agents/skills/` natively. Do **not** link agents into `.cursor/agents/`. Do **not** put skill bodies under `.cursor/rules/`. Do **not** add Gemini, Copilot, Windsurf, or other tool files unless the brief says so.

---



## Steps (do in order)



### 1. Write `AGENTS.md`

Use the brief. Include all of these sections:

- Title: `{Project name} — IDE guide`
- What the project is (from Kind). If markdown coach: no build, no tests, no product UI unless the brief says otherwise.
- **Single source of truth:** Cursor and Codex read `AGENTS.md`. `.cursorrules` is a symlink. Claude Code reads `CLAUDE.md`, a symlink to this file. Edit **this file only** for root instructions. Recreate adapters with `.agents/scripts/link.sh`.
- **Your role** (from the brief).
- **File map** (ASCII tree of the paths you will create, including `.agents/`).
- Note: Claude Code consumes the same files via relative symlinks under `.claude/`. Cursor loads `.agents/skills/` natively and uses `.cursor/commands/` adapters for slash commands (skill **directories** so `reference.md` stays next to `SKILL.md`).
- **Slash commands** table: `/name` → purpose. Instruct: when the user invokes a command, read `.agents/commands/<name>.md` and execute it exactly; also read the skills it names.
- **How to work a session** (numbered). Include: find or create the artifact dir if the brief has one; load skills from disk, do not rely on memory; in Cursor the model *is* the orchestrator and specialist `.agents/agents/` files are extra reads; in Claude Code route to the matching subagent when one exists.
- **Skill routing** table: situation → `.agents/skills/<name>/SKILL.md` (and commands for onboarding if listed).
- **Hard limits** from the brief, plus always:
  - Do not replace `CLAUDE.md` or `.cursorrules` with real copies — they must stay symlinks.
  - Do not add parallel copies of skill bodies under `.cursor/rules/` or a generated Codex dump unless the user asks.
- **Recreating adapters:** `sh .agents/scripts/link.sh` from repo root.

If Kind is a software app, add runtime commands from the brief. Do not invent a stack.

### 2. Write agents

YAML frontmatter on every agent file:

```yaml
---
name: kebab-case-name
model: inherit
description: One or two sentences. When to use this agent. Mention matching /commands if any.
tools: Read, Glob, Grep, Write
---
```

Write each agent to `.agents/agents/<name>.md`.

**Orchestrator** (first name in the brief): routing table (user need → optional specialist file → skills). “When a slash command is used, execute `.agents/commands/<name>.md` exactly.” Hard limits: “same as `AGENTS.md`” plus any one-liners from the brief.

**Specialists:** load `AGENTS.md` context, named skills, and any artifact files the brief mentions. Do not duplicate the full skill text.

### 3. Write skills

Each `.agents/skills/<name>/SKILL.md`:

```yaml
---
name: kebab-case-name
description: When to use this skill (and which /commands).
---
```

If the brief has no domain prose, write a **stub**: purpose from the brief, “read user artifacts before advising”, “do not invent missing fields”, pointer to `reference.md` only if you actually create that file.

Commands stay thin. Skills hold the how-to.

### 4. Write commands

One `.agents/commands/<name>.md` per command. Required reads (numbered): artifacts if any, then `.agents/skills/.../SKILL.md` (and specialists if useful). If prerequisites are missing, tell the user which command to run first. End with the output path to write. Reply-language rule if the brief set one.

### 5. Write `.agents/scripts/link.sh`

POSIX `sh`, `set -e`, `cd` to repo root via `dirname "$0"/../..`. Lists `SKILLS`, `AGENTS`, `COMMANDS` from the brief (newline-separated names). Then:

```sh
mkdir -p .claude/skills .claude/agents .claude/commands
mkdir -p .cursor/commands

# Skill directories for Claude Code (Cursor loads .agents/skills/ natively)
for name in $SKILLS; do
  ln -sfn ../../.agents/skills/"$name" .claude/skills/"$name"
done

for name in $AGENTS; do
  ln -sfn ../../.agents/agents/"$name".md .claude/agents/"$name".md
done

for name in $COMMANDS; do
  ln -sfn ../../.agents/commands/"$name".md .claude/commands/"$name".md
  ln -sfn ../../.agents/commands/"$name".md .cursor/commands/"$name".md
done

if [ ! -L CLAUDE.md ]; then
  ln -sfn AGENTS.md CLAUDE.md
fi
if [ ! -L .cursorrules ]; then
  ln -sfn AGENTS.md .cursorrules
fi
```

If `CLAUDE.md` or `.cursorrules` already exist as regular files, stop and tell the user to remove them before linking. Do not overwrite a real file with a symlink.

### 6. Run the linker and verify

From repo root: `sh .agents/scripts/link.sh`.

Confirm with `ls -la`: `CLAUDE.md` and `.cursorrules` are symlinks to `AGENTS.md`. Skill entries under `.claude/skills` are directory symlinks to `.agents/skills/`. Command files under `.claude/commands` and `.cursor/commands` are file symlinks. Agent files exist only under `.claude/agents`. There is no `.cursor/skills/` adapter tree.

### 7. Write `README.md`

Short: project name, “edit `AGENTS.md` only”, table (Codex/Cursor → `AGENTS.md`; Claude Code → `CLAUDE.md` → `AGENTS.md`; Cursor legacy → `.cursorrules`), “after clone run `sh .agents/scripts/link.sh` if adapters are missing”, first-session command order from the brief, layout bullets (`.agents/` as source of truth), hard-limits one-liners (no extra policy).

### 8. `.gitignore`

Only if the brief names a generated dir (e.g. `result/`). Ignore that dir’s contents; keep a `.gitkeep` if useful. Do not add a junk ignore list.

---



## Forbidden

- Replacing `CLAUDE.md` or `.cursorrules` with copies of `AGENTS.md`
- Skill or command **file** copies inside `.claude/` or `.cursor/` (must be relative `ln -sfn`)
- Creating `.cursor/skills/` adapters when skills already live under `.agents/skills/`
- `.cursor/rules/*.mdc` dumps of skill text
- Extra tool instruction filenames not in this document
- Inventing stack, product UI, or domain facts absent from the brief
- `git commit` unless the user asked

---



## Done when

- `AGENTS.md` is the only root instruction body
- `diff -q AGENTS.md CLAUDE.md` and `diff -q AGENTS.md .cursorrules` succeed
- `sh .agents/scripts/link.sh` is idempotent
- Skills, agents, and commands from the brief exist as real files under `.agents/`; IDE folders only contain adapters
