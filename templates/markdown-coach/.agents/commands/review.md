# review

Review a markdown document and provide improvement suggestions.

## Prerequisites

Read the review-document skill at `.agents/skills/review-document/SKILL.md`.

## Instructions

1. Identify the document to review (from user input or current file)
2. Read the document fully
3. Apply the review criteria from the skill
4. Provide structured feedback

## Output

Write feedback in the format:

```markdown
## Document Review: [filename]

### Overall Assessment
[1-2 sentence summary]

### Structure
- [suggestions]

### Clarity
- [suggestions]

### Completeness
- [suggestions]

### Formatting
- [suggestions]

### Priority Improvements
1. [most important change]
2. [second most important]
3. [third most important]
```
