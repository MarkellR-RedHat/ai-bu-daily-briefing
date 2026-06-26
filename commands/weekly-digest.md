# Weekly Digest

You are writing an end-of-week engineering summary suitable for pasting into a team Slack channel, a status email, or a 1:1 doc with your manager. This is your highlight reel for the week, but honest: it shows what shipped, what is stuck, and where you spent your time.

## Philosophy

A weekly digest has two audiences:
1. **Your manager** wants to know: what did you deliver, what is blocking you, are you on track for your commitments?
2. **Your teammates** want to know: what merged that affects them, what reviews are still pending, what issues closed?

Write for both. Be concise but complete.

## Arguments

$ARGUMENTS can optionally contain:
- `--org <name>` to filter results to one GitHub org
- `--repo <name>` to filter results to one repo
- `--weeks <N>` to look back N weeks instead of the default 1 (useful for bi-weekly summaries)
- If no flags are given, cover all repos the user has access to

## Chain of Thought

### Step 1: Determine the date range

Default: last 7 days (Monday to Friday of the current or most recent work week). If `--weeks <N>` is provided, look back N*7 days. Calculate the exact start and end dates for display.

### Step 2: Gather shipped work

1. **PRs I merged**: `gh search prs --author=@me --merged --json repository,title,url,mergedAt,labels` - filter to date range
2. **PRs I authored that someone else merged**: Same query, different merge patterns. Some repos use squash-merge by maintainers.

Group merged PRs by repository. Within each repo group, sort by merge date (oldest first, so it reads as a narrative of the week).

### Step 3: Gather review contributions

1. **PRs I reviewed**: `gh search prs --reviewed-by=@me --merged --json repository,title,url,updatedAt` - filter to date range
2. If the above returns unreliable data, fall back to: `gh api search/issues?q=reviewed-by:@me+is:pr+updated:>CUTOFF_DATE --jq '.items[] | {title: .title, url: .html_url}'`

Count total reviews. This matters for showing breadth of contribution beyond just your own PRs.

### Step 4: Assess open work (carryover)

1. **My open PRs**: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision,labels`
2. Calculate age for each. Classify:
   - APPROVED but not merged: flag as "ready to ship"
   - CHANGES REQUESTED: flag as "needs rework"
   - No review decision and older than 3 days: flag as "stuck in review"
   - Recently opened (< 3 days): mark as "in progress"

### Step 5: Gather issue activity

1. **Issues I closed**: `gh search issues --assignee=@me --state=closed --json repository,title,url,updatedAt` - filter to date range
2. **Issues still open**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt`
3. Flag any open issue older than 14 days as STALE. Flag any with "blocked" label.

### Step 6: Compute the summary line

Before the detailed sections, write a one-line summary:
- "[N] PRs shipped, [N] reviews completed, [N] issues closed, [N] items carrying over"
- This is the TL;DR that your manager reads when they are skimming.

### Step 7: Self-critique

Before printing:
- Does the "shipped" section accurately reflect real deliverables? Dependabot PRs and typo fixes should be consolidated or omitted unless they were significant.
- Is every open PR classified with its current state? Listing an open PR without saying whether it is stuck or in progress is useless.
- Are issues grouped sensibly? If you closed 5 issues in one repo, group them.
- Is the total output under 50 lines? If you shipped a lot, consolidate smaller items: "Plus 3 minor fixes in [repo]" instead of listing each one.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Anti-Patterns (DO NOT do these)

- DO NOT report Dependabot/Renovate PRs as "shipped work" unless the user explicitly authored them. Consolidate automated PRs into one line: "[N] dependency updates merged."
- DO NOT list a PR in both "shipped" and "reviews" (if you authored it, it goes in shipped, not reviews).
- DO NOT use "various" or "miscellaneous" as descriptions. Be specific or consolidate with a count.
- DO NOT add reflection paragraphs ("This was a productive week..."). The numbers speak for themselves.
- DO NOT include a "goals for next week" section. That belongs in /week-ahead.

## Output Format

```
WEEKLY DIGEST - [Mon DD] to [Fri DD, YYYY]
=============================================
Summary: [N] shipped, [N] reviewed, [N] issues closed, [N] carrying over

SHIPPED ([count] PRs merged)
  [repo]:
    [title] (merged [day])
      [url]
    [title] (merged [day])
      [url]
  [repo]:
    [title] (merged [day])
      [url]

REVIEWS COMPLETED ([count])
  [repo]: [title]
  [repo]: [title]

OPEN PRs ([count])
  [repo]: [title] - [APPROVED / CHANGES REQUESTED / WAITING [N]d / IN PROGRESS]
    [url]

ISSUES CLOSED ([count])
  [repo]: [title]

ISSUES OPEN ([count])
  [repo]: [title] ([N]d old) [STALE if >14d] [BLOCKED if labeled]
    [url]
```
