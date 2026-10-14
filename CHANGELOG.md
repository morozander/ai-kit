# Changelog

All notable changes to this kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - 2026-10-14

### Added

- Initial versioned release of all packs
- `core` pack (v1.0.0): git-workflow, systematic-debugging, meta-task-observer, resolving-merge-conflicts, plus newly consolidated skills: grilling, grill-with-docs, tdd, domain-modeling, codebase-design, code-review
- `workflow-lapa` pack (v1.0.0): brainstorming, writing-plans, writing-specs, grill-spec, feature-dev, implement-and-review
- `mattpocock-fork` pack (v1.0.0): setup-matt-pocock-skills, ask-matt, to-spec, to-tickets, implement, implement-spec, triage, wayfinder, and more
- `sdd` pack (v1.0.0): spec-driven development loop
- `software-frontend` pack (v1.0.0): React-oriented skills and agents
- `hiking-tutor` pack (v1.0.0): hiking coach domain pack
- Validation script (`core/scripts/validate-pack.sh`) for pack consistency
- GitHub Actions CI workflow for automated validation
- `.gitattributes` for line ending consistency
- `depends_on` field in pack.yaml for declaring pack dependencies

### Changed

- Standardized on `GLOSSARY.md` naming (previously inconsistent with `CONTEXT.md`)
- Standardized on `references/` subdirectory for skill reference files
- Consolidated duplicated skills (grilling, tdd, domain-modeling, codebase-design, grill-with-docs, code-review) into `core`
- `workflow-lapa` and `mattpocock-fork` now depend on `core` for shared skills
- Improved `install-into.sh` with validation before copy

### Fixed

- Hardcoded personal path in README.md
- Missing `code-review` command in mattpocock-fork pack.yaml
- Inconsistent reference file paths in skills
