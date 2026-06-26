# Weekly Digest

Generate a week-in-review summary of my GitHub activity. Covers what I shipped, what I reviewed, and what is still open. Good for async status updates and end-of-week summaries.

## Rules

- Keep total output under 40 lines.
- One line per item. No multi-line descriptions.
- Group items by repo where possible.
- Do NOT add commentary, advice, or wrap-up paragraphs.
- Do NOT explain what you are doing. Just print the digest.

## Instructions

$ARGUMENTS can optionally contain `--org <name>` or `--repo <name>` to filter scope.

### 1. Shipped (Merged PRs)

Run: `gh search prs --author=@me --merged --json repository,title,url,mergedAt`

Filter to PRs merged in the last 7 days. Count them.

### 2. Reviews I Completed

Run: `gh api search/issues?q=reviewed-by:@me+is:pr+is:merged+created:>$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '7 days ago' +%Y-%m-%d) --jq '.items[] | {repo: .repository_url, title: .title, url: .html_url}'`

If the above is unreliable, fall back to: `gh search prs --reviewed-by=@me --merged --json repository,title,url,updatedAt` and filter to last 7 days.

### 3. Still Open

Run: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision`

List all my open PRs with their current review status and age.

### 4. Issues Closed

Run: `gh search issues --assignee=@me --state=closed --json repository,title,url,updatedAt`

Filter to issues closed in the last 7 days.

### 5. Issues Still Open

Run: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt`

List with age. Flag anything older than 14 days.

## Output Format

```
WEEKLY DIGEST - [start date] to [end date]
============================================

SHIPPED ([count] PRs merged)
- [repo]: [title]
  [url]

REVIEWS COMPLETED ([count])
- [repo]: [title]

STILL OPEN ([count] PRs)
- [repo]: [title] - [review status] ([N]d old)
  [url]

ISSUES CLOSED ([count])
- [repo]: [title]

ISSUES OPEN ([count])
- [repo]: [title] ([N]d old) [OLD if >14d]
  [url]
```
