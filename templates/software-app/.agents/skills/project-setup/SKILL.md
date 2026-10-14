---
name: project-setup
description: Initialize or verify project setup. Use when starting a new project or checking existing configuration.
---

# Project Setup

Guide for initializing or verifying a software project.

## Check existing setup

Before making changes, check what exists:

```bash
ls -la
cat package.json 2>/dev/null || echo "No package.json"
cat tsconfig.json 2>/dev/null || echo "No tsconfig.json"
```

## Standard files

Ensure these exist and are properly configured:

### package.json
- Has `name`, `version`, `scripts`
- Scripts include: `dev`, `build`, `test`, `lint`

### tsconfig.json (if TypeScript)
- `strict: true`
- Appropriate `target` and `module` settings

### .gitignore
- Ignores `node_modules/`, `dist/`, `.env`

### README.md
- Documents how to install, run, test

## Verification

After setup, verify with:

```bash
npm install
npm run build
npm test
```

## Do not

- Invent a stack not specified by the user
- Add unnecessary dependencies
- Change existing working configuration without asking
