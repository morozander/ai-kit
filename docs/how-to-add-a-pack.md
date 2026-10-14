# How to add a pack

1. Create `packs/<kebab-name>/` with `skills/`, `agents/`, `commands/` as needed (and optional extra dirs like `profile/`). Pack sources keep those folder names inside the pack.

2. Add `pack.yaml`:

```yaml
name: my-pack
version: 1.0.0
description: One line describing what this pack provides.
depends_on:        # optional - list packs that should be installed first
  - core
skills:
  - example-skill
agents:
  - example-agent
commands:
  - example-command
extra_dirs:        # optional - non-.agents directories to copy
  - profile
```

3. Skill folders need `SKILL.md` with YAML frontmatter:

```yaml
---
name: example-skill
description: Brief description of when to use this skill (under 200 characters recommended).
---
```

Put supporting files (examples, reference tables) in a `references/` subdirectory:
```
skills/example-skill/
  SKILL.md
  references/
    examples.md
    reference-tables.md
```

4. Agent and command files are `*.md` with thin bodies; skills hold the how-to.

5. In content bodies, use portable **installed** paths: `.agents/skills/<name>/SKILL.md` — never `.claude/skills/...`. Install copies pack `skills|agents|commands` into the target's `.agents/` tree; `profile/` and other extras stay at the project root.

6. Install: `sh core/scripts/install-into.sh --target <project> --pack <kebab-name>`.

7. Validate: `sh core/scripts/validate-pack.sh --pack <kebab-name>` to check consistency.

## Guidelines

### Skill descriptions

- Keep under 200 characters (validation warns if longer)
- Describe **when** to use the skill, not what it does in detail
- Include relevant trigger phrases or command names

### File organization

- Use `references/` subdirectory for supporting files (not flat alongside SKILL.md)
- Use `GLOSSARY.md` for domain vocabulary (not `CONTEXT.md`)
- Reference files with relative paths: `[examples](references/examples.md)`

### Dependencies

If your pack uses skills from another pack (like `core`), add `depends_on` to `pack.yaml`. The install script will remind users to install dependencies first.

### Versioning

Include a `version` field in pack.yaml following semver. Update CHANGELOG.md when releasing.

## Extending core

To add files to `core`, add them under `core/` and list them in `core/pack.yaml`. Run validation to ensure consistency.
