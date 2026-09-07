# How to add a pack

1. Create `packs/<kebab-name>/` with `skills/`, `agents/`, `commands/` as needed (and optional extra dirs like `profile/`).
2. Add `pack.yaml`:

```yaml
name: my-pack
description: One line.
skills:
  - example-skill
agents:
  - example-agent
commands:
  - example-command
extra_dirs:
  - profile
```

3. Skill folders need `SKILL.md` (optional `reference.md` / `examples.md` beside it).
4. Agent and command files are `*.md` with thin bodies; skills hold the how-to.
5. Use portable paths: `skills/<name>/SKILL.md` — never `.claude/skills/...`.
6. Install: `sh core/scripts/install-into.sh --target <project> --pack <kebab-name>`.

To extend `core`, add files under `core/` and list them in `core/pack.yaml`.
