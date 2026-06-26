# Standup Prep

Generate a quick standup summary based on my recent GitHub activity. Output three sections: what I did yesterday, what I'm doing today, and blockers.

## Instructions

$ARGUMENTS can optionally contain an org or repo filter.

### What I Did Yesterday

1. Run `gh search prs --author=@me --merged --json repository,title,url,mergedAt` and filter to PRs merged in the last 24 hours.
2. Run `gh search prs --author=@me --state=open --json repository,title,url,updatedAt` and filter to PRs updated in the last 24 hours.
3. Run `gh search issues --author=@me --json repository,title,url,updatedAt` and filter to issues updated in the last 24 hours.
4. Check recent commits by running `gh api user/events --jq '[.[] | select(.type == "PushEvent") | {repo: .repo.name, created: .created_at, commits: .payload.commits | length}] | .[:10]'`.

Summarize all activity into bullet points.

### What I'm Doing Today

1. List my open PRs that still need review: `gh search prs --author=@me --state=open --review=required --json repository,title,url`.
2. List my assigned issues sorted by most recently updated: `gh search issues --assignee=@me --state=open --sort=updated --json repository,title,url,labels`.
3. List PRs requesting my review: `gh search prs --review-requested=@me --state=open --json repository,title,url`.

Prioritize items with urgent/deadline labels and pending review requests.

### Blockers

1. Check for PRs where I am the author and reviews are pending for more than 3 days: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision`.
2. Check for any issues assigned to me with a "blocked" label.

If no blockers are found, say "No blockers."

### Output Format

```
STANDUP PREP - [today's date]
=============================

YESTERDAY:
- Merged PR: [title] in [repo]
- Updated PR: [title] in [repo]
- Worked on issue: [title] in [repo]

TODAY:
- Review PR: [title] in [repo] (requested)
- Continue: [issue title] in [repo]
- Follow up on: [PR title] (awaiting review)

BLOCKERS:
- [PR title] in [repo] waiting on review for [N] days
- No blockers.
```

Keep this tight. Three sections, bullet points only.
