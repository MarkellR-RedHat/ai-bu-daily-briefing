# Briefing Format Reference

This document describes the formatting conventions used across all ai-bu-daily-briefing commands. If you are writing a new command or modifying an existing one, follow these patterns.

## Header Format

Every command output starts with a header block:

```
COMMAND NAME - [date or date range]
======================================
```

- Command name is UPPERCASE
- Date format: YYYY-MM-DD for single dates, "Mon DD to Fri DD, YYYY" for ranges
- The underline is `=` characters matching the header length (approximately)
- One blank line after the header before the first section

## Section Headers

```
SECTION NAME ([count] [noun])
```

- Section names are UPPERCASE
- Always include a count in parentheses when the section lists items
- Use descriptive nouns: "items waiting on you", "PRs merged", "needing attention"
- One blank line between sections

## Item Format

```
  [action/status]: [title] ([repo]) [flags]
    [url]
    [optional detail line]
```

- Items are indented 2 spaces from the left margin
- URLs are indented 4 spaces (2 more than the item line)
- Optional detail lines are also indented 4 spaces
- One item per line. Never wrap an item title across multiple lines.

### Action Prefixes

Use these prefixes consistently across commands:

| Prefix | Meaning |
|--------|---------|
| `Merge:` | PR is approved and ready to merge |
| `Review:` | Someone is waiting for your review |
| `Fix:` | Changes were requested on your PR |
| `Continue:` | Work in progress, no specific action needed now |
| `Ship:` | Same as Merge, used in standup context |
| `Pick up:` | Issue or task to start working on |
| `Close:` | Item appears resolved, just needs to be closed |
| `Merged:` | Past tense, for reporting what was done |
| `Reviewed:` | Past tense |
| `Updated:` | Past tense |
| `Pushed` | Past tense, for commit counts |

### Status Flags

Append these flags at the end of an item line:

| Flag | When to use |
|------|-------------|
| `STALE` | PR open > 7 days without review |
| `URGENT` | Issue labeled urgent/blocker/critical/deadline |
| `APPROVED` | PR has been approved |
| `CHANGES REQUESTED` | Reviewer requested changes |
| `WAITING FOR REVIEW` | PR has no review decision |
| `BLOCKED` | Issue has a blocked/waiting label |
| `OLD` | Issue open > 14 days |
| `DRAFT` | PR is in draft state |

### Severity Tags (Risk Radar only)

Used as prefixes in brackets:

| Tag | Meaning |
|-----|---------|
| `[PROCESS]` | Review bottleneck or workflow issue |
| `[QUALITY]` | CI, testing, or code quality concern |
| `[SECURITY]` | Dependency vulnerability or security alert |
| `[TEAM]` | Sustainability or workload pattern |
| `[TECHNICAL]` | Branch divergence, merge conflict risk |

## Repo Names

Always use the full `owner/repo` format (e.g., `RedHatAI/llm-d`), not just the repo name. This avoids ambiguity when scanning multiple orgs.

## Date Display

- Ages: "[N]d old" (e.g., "3d old", "12d old")
- Merge dates: "merged [day]" (e.g., "merged Tue") for weekly context, "merged [YYYY-MM-DD]" when spanning longer periods
- Timestamps: Use relative time for < 7 days ("3d ago"), absolute dates for longer periods

## Empty Sections

When a section has no items, print one of:
- `None.` (for data sections)
- `No blockers.` (for blocker sections specifically)
- `No issues detected.` (for health/risk sections)
- `Nothing notable changed direction during your absence.` (for catch-me-up awareness section)

Never omit a section entirely. Explicitly showing "None" tells the user you checked and found nothing, versus something going wrong.

## Line Budget

Each command has a target line count to fit on a terminal screen:

| Command | Default | Verbose / Extended |
|---------|---------|-------------------|
| `/briefing` | 40 lines | 60 lines with --verbose |
| `/standup` | 25 lines | n/a |
| `/weekly-digest` | 50 lines | n/a |
| `/team-pulse` | 60 lines | n/a |
| `/catch-me-up` | 60 lines (3d) | 80 lines (full week) |
| `/risk-radar` | 60 lines | n/a |
| `/week-ahead` | 50 lines | 70 lines with --include-team |

If a section would exceed the budget, consolidate smaller items:
- "Plus [N] minor fixes in [repo]"
- "[N] dependency updates merged across [N] repos"
- "[+M more contributors with activity]"

## Consolidation Rules

When there are too many items of the same type:

1. **Automated PRs** (Dependabot, Renovate): Always consolidate into one line with a count.
2. **Multiple PRs in one repo**: If > 5, summarize: "[repo]: [N] PRs merged (highlight: [biggest change])"
3. **Multiple issues in one repo**: Group: "[repo]: [N] issues ([list of notable titles])"
4. **Contributors**: If > 10, show top 10 and note "[+M more with activity]"

## Things to Never Include

- Emoji or decorative characters
- Em dashes (use "- " for lists, commas or parentheses for asides)
- ASCII art beyond `=` section dividers
- Motivational messages, greetings, or sign-offs
- Explanations of methodology ("I ran the following commands...")
- Generic advice ("Remember to review PRs promptly")
- Fabricated URLs or placeholder data
- Bot accounts in contributor lists (dependabot, renovate, github-actions)

## Voice

Write in a direct, factual tone. Red Hat engineering voice: professional, no-nonsense, technically precise. State facts and surface patterns. Let the reader draw conclusions and decide on actions.

Good: "PR open 12d with no review. Merge conflict risk increasing."
Bad: "This PR has been languishing and you should probably look into why nobody has reviewed it yet."

Good: "3 after-hours commits this period."
Bad: "The team might be experiencing burnout based on late-night commit patterns."
