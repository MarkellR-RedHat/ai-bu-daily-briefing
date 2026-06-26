# Catch Me Up

You are briefing an engineer who has been out for multiple days and needs to get up to speed fast. They do not want to read through hundreds of notifications. They want the 2-minute version: what decisions were made, what broke, what shipped, and what they need to act on now that they are back.

## Philosophy

Returning from time off is disorienting. The goal here is to collapse N days of activity into a single prioritized document that answers:
1. What do I need to act on TODAY? (things assigned to me, reviews piling up)
2. What changed direction while I was out? (PRs that were reworked, issues reprioritized)
3. What shipped that I should know about? (big merges, new repos, releases)
4. What can I safely ignore? (routine merges, bot updates, minor fixes)

Structure the output so the reader can stop reading after section 1 if they are in a hurry.

## Arguments

$ARGUMENTS should contain a number (days away) or a date range. Examples:
- `/catch-me-up 3` - I was out for 3 days
- `/catch-me-up 5` - I was out for 5 days (a full work week)
- `/catch-me-up 2025-06-20..2025-06-25` - specific date range
- `/catch-me-up monday` - since last Monday

Additional optional flags:
- `--org <name>` to filter to one GitHub org
- `--repo <name>` to filter to one repo

If no duration/range is provided, print exactly this and stop:
```
Usage: /catch-me-up <days> [--org <name>] [--repo <name>]
Examples:
  /catch-me-up 3
  /catch-me-up 5 --org RedHatAI
  /catch-me-up 2025-06-20..2025-06-25
```

## Chain of Thought

### Step 1: Parse the time range

Determine the lookback window from $ARGUMENTS:
- If a plain number, go back that many days from today
- If a date range (YYYY-MM-DD..YYYY-MM-DD), use those exact bounds
- If a day name (e.g., "monday"), calculate the most recent occurrence
- Compute the cutoff date/time in ISO format for `gh` queries

### Step 2: Gather what needs your action (Section 1 - ACT ON THIS)

These are items that are waiting on YOU specifically:

1. **Unread notifications (review requests and mentions only)**: `gh api notifications --jq '[.[] | select(.reason == "review_requested" or .reason == "mention") | {reason, title: .subject.title, repo: .repository.full_name, updated: .updated_at}]'`
2. **PRs requesting your review that arrived during your absence**: `gh search prs --review-requested=@me --state=open --json repository,title,url,createdAt` - filter to those created or updated during the absence window
3. **Issues assigned to you that were created or updated during absence**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt,updatedAt` - filter to those with activity during absence
4. **Your own PRs that received reviews while you were out**: `gh search prs --author=@me --state=open --json repository,title,url,reviewDecision,updatedAt` - filter to those updated during absence, especially those with CHANGES_REQUESTED

Sort by urgency: changes-requested PRs first (you are blocking the merge), then review requests (you are blocking teammates), then new assignments.

### Step 3: Gather what changed direction (Section 2 - BE AWARE)

1. **PRs in repos you contribute to that had significant discussion**: For your top repos, find PRs with 5+ comments that were active during your absence. Use: `gh pr list --repo <repo> --state all --json title,url,comments,updatedAt,state,author` - filter to those with high comment counts and activity during absence.
2. **Issues with label changes**: Look for issues in your repos that were relabeled to/from "priority", "urgent", "blocked" during the absence window.
3. **Large PRs that merged**: In your active repos, find merged PRs with significant changes: `gh pr list --repo <repo> --state merged --json title,url,mergedAt,additions,deletions,author` - filter to the absence window and sort by (additions + deletions) descending. Flag any with 500+ lines changed.

### Step 4: Gather what shipped (Section 3 - FYI)

1. **All PRs merged in your active repos during the window**: For each of your top 5 recently pushed repos, `gh pr list --repo <repo> --state merged --json title,url,mergedAt,author` - filter to absence window
2. **New releases or tags**: `gh api repos/<repo>/releases --jq '[.[] | select(.published_at > "CUTOFF_DATE") | {tag: .tag_name, name: .name, url: .html_url}]'`
3. **New repos created in the org**: If `--org` is provided, check for repos created during absence: `gh api orgs/<org>/repos?sort=created&per_page=5 --jq '[.[] | select(.created_at > "CUTOFF_DATE") | {name: .full_name, description: .description}]'`

Consolidate routine items. If 10 PRs merged in one repo, group them: "[repo]: 10 PRs merged (highlight: [biggest PR title])". Only individually list PRs with 200+ lines changed or notable titles.

### Step 5: Classify and cut

Review all gathered items and enforce these rules:
- If a merged PR was authored by dependabot/renovate, group all of them into one line: "[N] dependency updates merged across [repos]."
- If an issue was created AND closed during the absence window, skip it unless it is labeled urgent. The user does not need to know about fully resolved incidents unless they were severe.
- If the total "FYI" section would exceed 15 items, consolidate by repo: "[repo]: [N] PRs merged, [summary of biggest change]."

### Step 6: Self-critique

Before printing:
- Is Section 1 (ACT ON THIS) complete? Missing a review request here means the user does not know they are blocking someone.
- Is Section 2 (BE AWARE) genuinely important? Do not pad it with routine merges. If nothing truly changed direction, say "Nothing notable changed direction during your absence."
- Is Section 3 (FYI) a useful summary and not a full changelog? Consolidate.
- Total output should be under 60 lines for a 3-day absence, up to 80 lines for a full week.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Anti-Patterns (DO NOT do these)

- DO NOT dump every notification. Only review requests and mentions matter.
- DO NOT list every merged PR individually when there are more than 5 per repo. Summarize.
- DO NOT include closed-then-reopened issues unless they are still open.
- DO NOT say "while you were away, the team was busy." Just show what happened.
- DO NOT add "welcome back" or similar pleasantries.
- DO NOT include items from before the absence window started.

## Output Format

```
CATCH-UP BRIEFING - [start date] to [end date] ([N] days)
============================================================

ACT ON THIS ([count] items waiting on you)
  Review requested: [title] ([repo]) - opened [N]d ago
    [url]
  Changes requested on your PR: [title] ([repo])
    [url]
  New assignment: [title] ([repo]) [label if relevant]
    [url]

BE AWARE ([count] notable changes)
  [repo]: [title] - [what changed: merged with 800 lines, reprioritized, etc.]
    [url]
  [repo]: [title] - heavy discussion ([N] comments)
    [url]

FYI - WHAT SHIPPED
  [repo]: [N] PRs merged
    Highlight: [title of biggest/most notable PR]
  [repo]: [N] PRs merged
  [N] dependency updates merged across [N] repos
  New release: [repo] [tag]

  Nothing notable changed direction during your absence.
```
