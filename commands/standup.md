# Standup Prep

Generate a quick standup summary from my GitHub activity. Three sections only: yesterday, today, blockers. Keep total output under 25 lines.

## Rules

- Bullet points only. No prose, no filler, no encouragement.
- One line per item. Include repo name and PR/issue title.
- Do NOT explain what you are doing. Just print the standup.
- If a section is empty, print "- Nothing" and move on.

## Instructions

$ARGUMENTS can optionally contain `--org <name>` or `--repo <name>` to filter.

### Yesterday (last 24h)

1. PRs I merged: `gh search prs --author=@me --merged --json repository,title,url,mergedAt` - filter to last 24h.
2. PRs I updated: `gh search prs --author=@me --state=open --json repository,title,url,updatedAt` - filter to last 24h.
3. Issues I touched: `gh search issues --author=@me --json repository,title,url,updatedAt` - filter to last 24h.
4. Push events: `gh api user/events --jq '[.[] | select(.type == "PushEvent") | {repo: .repo.name, created: .created_at, commits: .payload.commits | length}] | .[:10]'`

### Today

1. My PRs awaiting review: `gh search prs --author=@me --state=open --review=required --json repository,title,url`
2. My assigned issues: `gh search issues --assignee=@me --state=open --sort=updated --json repository,title,url,labels`
3. PRs requesting my review: `gh search prs --review-requested=@me --state=open --json repository,title,url`

Urgent/deadline-labeled items go first.

### Blockers

1. My PRs waiting on review for 3+ days: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision`
2. Issues assigned to me with a "blocked" label.

If nothing qualifies, print "- No blockers."

## Output Format

```
STANDUP - [YYYY-MM-DD]
=======================

YESTERDAY:
- Merged: [title] ([repo])
- Updated: [title] ([repo])
- Pushed [N] commits to [repo]

TODAY:
- Review: [title] ([repo]) [requested]
- Continue: [title] ([repo])
- Ship: [title] ([repo]) [approved]

BLOCKERS:
- [title] ([repo]) - waiting [N]d for review
- No blockers.
```
