# Markdown coach template

A starter template for a markdown document review coach.

## Quick start

1. Copy this folder to your new project location
2. Rename `AGENTS.md.stub` to `AGENTS.md`
3. Run `sh .agents/scripts/link.sh` to create IDE adapters
4. Optionally install additional packs: `sh /path/to/ai-kit/core/scripts/install-into.sh --target . --pack core --link`

## What's included

- **Skill**: `review-document` — reviews markdown for clarity, structure, and completeness
- **Command**: `/review` — triggers a document review

## Customization

Edit `AGENTS.md` to:
- Change the coach's role and personality
- Add hard limits specific to your domain
- Update the file map as you add skills

Add new skills under `.agents/skills/<name>/SKILL.md` and commands under `.agents/commands/<name>.md`, then update `link.sh` and run it again.
