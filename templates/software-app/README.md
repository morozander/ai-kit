# Software app template

A starter template for software projects.

## Quick start

1. Copy this folder to your new project location
2. Rename `AGENTS.md.stub` to `AGENTS.md`
3. Fill in the Runtime section with your stack's commands
4. Run `sh .agents/scripts/link.sh` to create IDE adapters
5. Install packs from ai-kit:
   ```bash
   sh /path/to/ai-kit/core/scripts/install-into.sh --target . --pack core --link
   sh /path/to/ai-kit/core/scripts/install-into.sh --target . --pack software-frontend --link  # if React
   ```

## What's included

- **Skill**: `project-setup` — initializes or verifies project configuration
- **Command**: `/setup` — triggers project setup check

## Recommended packs

- `core` — git workflow, debugging, TDD, code review
- `software-frontend` — React best practices, UI refactoring (if applicable)
- `workflow-lapa` — feature development loop with specs and plans
- `sdd` — spec-driven development for larger features

## Customization

Edit `AGENTS.md` to:
- Document your stack in the Runtime section
- Add architecture pointers and coding conventions
- Update the file map as you add skills

Add new skills under `.agents/skills/<name>/SKILL.md` and commands under `.agents/commands/<name>.md`, then update `link.sh` and run it again.
