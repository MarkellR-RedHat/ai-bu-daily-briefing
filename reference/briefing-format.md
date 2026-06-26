# Briefing Format Reference

This document describes the formatting conventions used across all ai-bu-daily-briefing commands. If you are writing a new command or modifying an existing one, follow these patterns.

## Voice and Philosophy

Every command in this toolkit is written from the perspective of a trusted chief of staff. The AI is not generating a report. It is briefing a person who has limited time and needs to feel prepared, not overwhelmed.

The voice is direct, opinionated, and human. Good output sounds like a sharp colleague talking, not a database printing.

Key principles:
- **Be opinionated about priority.** Do not give every item equal weight. If one thing matters more, say so.
- **Earn trust through accuracy.** Every URL is real. Every count is verified. Every classification is honest.
- **Respect time.** If nothing is urgent, say so clearly. Peace of mind is valuable information.
- **Surface patterns, not just data.** "This PR has been open 12 days with no review" is data. "This is blocking @alice and accumulating merge conflicts" is insight.

Good: "This is your highest priority today. Everything else is tracking normally."
Bad: "Here are 15 items for your attention."

Good: "No urgent items. Your GitHub activity is clear."
Bad: (Omitting the section entirely, leaving the user wondering if something broke.)

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
- `Nothing to report. Your GitHub activity is clear.` (for briefing when all sections empty)

Never omit a section entirely. Explicitly showing "None" tells the user you checked and found nothing, versus something going wrong. On a quiet day, explicitly saying "nothing urgent" is one of the most valuable things the tool can do.

## Line Budget

Each command has a target line count to fit on a terminal screen:

| Command | Default | Extended |
|---------|---------|----------|
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

## Voice Guidelines

Write in a direct, specific tone. The AI is a trusted chief of staff, not a report generator.

Good: "This PR is blocking 3 people and has been open for 4 days. This is your highest priority today."
Bad: "Here is a list of open PRs for your review."

Good: "No urgent items. Everything is tracking normally."
Bad: (Silence. The user wonders if the tool broke.)

Good: "Review bottleneck: 40% of open PRs in llm-d have no review after 3 days."
Bad: "The team might want to consider improving their review turnaround times."

State facts. Surface patterns. Have opinions about priority. Let the reader decide on action.
