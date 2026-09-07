---
name: meta-task-observer
description: >
  Monitors task execution for skill improvement opportunities. Use during ANY
  multi-step task, agentic workflow, or substantive work session. Captures
  patterns, user corrections, workflow insights, and methodology worth
  preserving as reusable skills. Also triggers during post-task feedback,
  when the user mentions skill observations or improvements, or asks the
  agent to watch for skill opportunities.
---

# Meta Task Observer — Continuous Skill Improvement

A persistent behavioral layer that identifies skill creation and improvement
opportunities during task-oriented work. It watches what happens during
sessions and produces structured observations that feed into skill updates.

## Why This Skill Exists

Skills are living documents. The best improvements come from noticing
friction, inefficiency, or missed opportunities during real work — not from
sitting down to "improve a skill" in isolation. A user correction might
reveal a missing rule. A repeated multi-step workflow might be a skill
waiting to be born. This skill formalizes that noticing process so insights
don't get lost between sessions.

---

## Conventions

`[project root]` refers to the repository root — the workspace directory
in both Cursor and Claude Code. All observation artifacts live under
`.meta-observations/` at the project root.

| Artifact                 | Path                                                                  |
| ------------------------ | --------------------------------------------------------------------- |
| Observation log          | `.meta-observations/log.md`                                           |
| Cross-cutting principles | `.meta-observations/cross-cutting-principles.md`                      |
| Staged skill updates     | `.meta-observations/skill-updates/[YYYY-MM-DD]/[skill-name]/SKILL.md` |
| Archive                  | `.meta-observations/archive/log-[YYYY-MM-DD].md`                      |
| Last review date         | `.meta-observations/last-review-date.txt`                             |

---

## Activation

For reliable session-start activation, CLAUDE.md should contain an
instruction to load this skill at the start of every task-oriented session.
If the skill was activated only via description matching (no CLAUDE.md
instruction found), mention this once and suggest adding the instruction.

### Session Start Protocol

Run these steps at the start of each task-oriented session:

1. **Check files exist.** If `.meta-observations/log.md` or
   `cross-cutting-principles.md` don't exist, create them from templates
   (see Observation Log Management).
2. **Scan for context.** Read any OPEN observations and active principles.
   Don't surface them unprompted unless directly relevant to the current
   task.
3. **Check the review trigger.** Read `last-review-date.txt`. If missing
   or older than 7 days, trigger a Comprehensive Review before proceeding
   with the user's task.

---

## Observation Protocol

### When to Observe

Observation is active throughout the **entire task session**:

1. **Active task execution** — creating, analyzing, building, refactoring.
2. **Post-task feedback** — user reviews output, provides corrections,
   discusses methodology.
3. **Meta-discussion** — conversation about how skills should be structured
   or how the work was done.
4. **Strategic/reflective conversations** — planning, post-work reflection.

Observation is **not active** during casual conversation, quick factual
questions, or non-task interactions.

### What to Watch For

**Signals for a NEW skill:**

- A multi-step workflow that could be reused across projects
- A methodology the user explains that isn't captured in any existing skill
- A task type that keeps coming up with similar structure
- The user describing a refined process ("I always do it this way")
- A structured approach emerging naturally that could be formalized

**Signals for IMPROVING an existing skill:**

- The agent doesn't follow a skill's rules despite them being documented
  (needs stronger enforcement, not just better rules)
- The user corrects output in a way that reveals a missing rule or edge case
- A skill's workflow turns out less efficient than what emerged naturally
- A technique works well and deserves promotion from incidental to explicit
- A new use case the skill handles but doesn't document
- The user suggests a naming, framing, or structural change

**Signals for SIMPLIFYING an existing skill:**

- A section or rule that has never been relevant across multiple sessions
- A rule added from a single observation that hasn't recurred
- An elaborate workflow users consistently shortcut or skip
- Rules that contradict each other or create unnecessary complexity
- A rule the agent consistently fails to follow — convert to structural
  enforcement (checklist, verification step) or remove it

**Do NOT log:**

- One-off corrections that don't generalize
- User preferences already captured in an existing skill
- Tool bugs or temporary issues unrelated to skill methodology

### How to Log

Append observations to the log **silently** during the session. The user
should not be interrupted by the logging process.

**Write immediately** — when a correction, insight, or skill-relevant event
occurs, write it to the log within the same turn or the next. Do not
accumulate observations in memory for batch-writing later.

**Mandatory checkpoint every ~3 TodoWrite completions:** Pause and ask
yourself "Have any unlogged observations accumulated?" This prevents the
common failure mode where the skill is loaded but no observations are
written until the user explicitly asks.

**Numbering:** Before assigning an observation number, read the log file
and find the highest existing number:

```bash
grep -o '### Observation [0-9]*' .meta-observations/log.md | grep -o '[0-9]*' | sort -n | tail -1
```

Increment from there. Always re-read; never rely on session memory for the
next number.

**Observation format:**

```markdown
### Observation [N]: [Short descriptive title]

**Date:** [YYYY-MM-DD]
**Session context:** [brief description of the task being worked on]
**Skill:** [existing skill name, or "New skill candidate: [working name]"]
**Status:** OPEN

**Issue:** [What happened. Be specific — include what the agent did, what
the user corrected, or what pattern emerged. Include enough detail that
someone reading this weeks later can understand without the original
conversation.]

**Suggested improvement:** [Concrete suggestion. For existing skills,
reference the specific section or rule. For new skills, describe scope
and key components.]

**Principle:** [The generalizable takeaway — why this matters beyond this
specific instance.]
```

---

## Surfacing Protocol

### Default: End of Session

Surface all observations at the end of the session. Present them grouped:
observations for existing skills grouped by skill name, new skill
candidates listed separately.

### Surface Earlier When

- An observation requires user input to be complete
- An observation reveals a skill is actively producing wrong output
- Multiple observations cluster around the same skill

### How to Surface

- Title, skill, and a one-sentence summary for each
- Indicate whether it's a new skill candidate or an improvement
- Ask the user which (if any) they want to act on

---

## Acting on Observations

Observations are acted on in three contexts only:

1. **Comprehensive review** — scheduled or 7-day fallback
2. **Explicit user request** — "update X skill", "act on observation #N"
3. **In-session correction** — skill producing wrong output right now

Outside these contexts, the default is **log, don't act**.

### Small Changes (Apply Directly)

Clearly additive, low-risk changes that don't need testing:

- Adding a new rule or anti-pattern to an existing list
- Clarifying wording that proved ambiguous
- Adding a note or edge case to an existing section
- Fixing a factual error

### Substantial Changes

Changes that could affect skill behavior in ways that need verification:

- Restructuring phases or workflows
- Adding new capabilities or sections
- Changing core methodology or decision frameworks

Flag these to the user as substantial changes needing manual review.

### Creating New Skills

Provide the observations as context — they contain intent, scope, and
initial design thinking. Write the skill directly using the project's
existing skill format (YAML frontmatter + lean operational body).

---

## Principle Propagation

Some observations reveal principles that apply across all skills.
These are tracked in a persistent file:

```
.meta-observations/cross-cutting-principles.md
```

### How It Works

1. An observation reveals a principle that applies broadly
2. Log it with `Skill: All skills` and surface to the user
3. If approved, add it to the cross-cutting principles file
4. From then on, every skill creation or update includes a compliance check

### Principles File Structure

```markdown
# Cross-Cutting Principles

Principles that apply to all skills. Read as a mandatory checklist
during any skill creation or update.

---

## Active Principles

### 1. [Principle title]

**Added:** [YYYY-MM-DD]
**Applies to:** [all skills | all skills with rules | etc.]
**Requirement:** [what the principle requires]
**Status:** active
```

---

## Comprehensive Review

Triggered manually or when `last-review-date.txt` is older than 7 days.

### Steps

**Step 1 — Load observations and principles.** Read the log, extract all
OPEN observations. Read cross-cutting principles.

If there are no OPEN observations and all principles are propagated, skip
the review, update the timestamp, and inform the user briefly.

**Step 2 — Inventory all skills.** Use the skill listing from the system
prompt or scan `skills/*/SKILL.md`. Only update custom skills.

**Step 3 — Cross-check.** For each OPEN observation, evaluate relevance
to each skill. Don't rely solely on the observation's "Skill" field —
principles may apply more broadly. Build a mapping of
skill -> [relevant observations].

Present ALL observations grouped by skill. Flag ambiguous or risky ones
as "Needs your input."

**Step 4 — Check cross-cutting principles.** For each active principle,
check whether each skill complies. Flag non-compliant skills.

**Step 5 — Apply updates.** Wait for user confirmation (blanket
"apply all" or selective). For each approved update:

- Integrate insights into the appropriate section of the skill
- Preserve existing structure and voice
- Make improvements feel native, not bolted on
- Save updated files to
  `.meta-observations/skill-updates/[YYYY-MM-DD]/[skill-name]/SKILL.md`
  for user review

**Step 6 — Mark observations as ACTIONED.** Update status in `log.md`:

`ACTIONED — Applied to [skill-name] (review [YYYY-MM-DD])`

Entries marked ACTIONED in the current session stay in the active log.
They are archived on the next log write.

**Step 7 — Update timestamp.** Write today's date to
`last-review-date.txt`.

**Step 8 — Present summary.**

```
## Skill Review Complete — [YYYY-MM-DD]

### Updated Skills

**[skill-name]**
- Changes: [1-sentence summary]
- Observations applied: #N, #N

### Observations Actioned
[list of numbers and titles]

### Skipped (needs manual review)
[any observations that couldn't be applied, with reasons]
```

For each updated skill, mention the staged file path so the user can
review the diff and copy it into place.

---

## Observation Log Management

### Location

Create on first use if it doesn't exist:

```
.meta-observations/log.md
```

### Log Template

```markdown
# Skill Observation Log

Observations captured during task-oriented work. Each entry identifies a
potential skill improvement or new skill opportunity.

**Status key:** OPEN = not yet actioned | ACTIONED = skill updated/created |
DECLINED = user decided not to pursue

---
```

### Archival

Event-driven, runs on every log write:

- Before appending new observations, move entries already marked ACTIONED
  or DECLINED **from a previous session** to
  `.meta-observations/archive/log-[YYYY-MM-DD].md`
- Entries marked ACTIONED/DECLINED in the **current session** stay in the
  active log until the next session's write
- The active log retains only OPEN entries plus recently-resolved ones

### Keep-Two Rule

For any given skill in `skill-updates/`, keep only the two most recent
date directories. Delete older copies to prevent accumulation.

---

## Self-Enforcement Checklist

Before surfacing observations at end of session, verify:

1. Were observations logged throughout the full session — including
   post-task feedback and discussion, not just active tool use?
2. Were observations logged silently without interrupting the user?
3. Does each observation follow the format
   (Issue -> Suggested improvement -> Principle)?
4. For observations about existing skills, does the suggestion reference
   the specific section or rule?

If any observation fails these checks, fix it before surfacing.
