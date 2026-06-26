# Daily Briefing

Generate a morning standup-ready summary of my GitHub activity. Keep the output concise and fit it on one screen.

## Instructions

Use the `gh` CLI to gather the following information and present it as a single briefing.

$ARGUMENTS can optionally contain:
- An org name to filter results (e.g., `--org RedHatAI`)
- A repo name to filter results (e.g., `--repo my-project`)
- `--verbose` for additional detail on each item

### 1. Notifications

Run `gh api notifications --jq '.[] | {reason, subject: .subject.title, repo: .repository.full_name, updated: .updated_at}'` to check unread notifications. Summarize the count and highlight anything marked as `review_requested` or `mention`.

If $ARGUMENTS contains an org or repo filter, filter notifications to match.

### 2. PRs Needing My Review

Run `gh search prs --review-requested=@me --state=open --json repository,title,url,updatedAt,createdAt` to find PRs where my review is requested.

If $ARGUMENTS contains an org filter, add `--owner=<org>`. If it contains a repo filter, add `--repo=<repo>`.

Flag any PR that has been open for more than 7 days as stale.

### 3. My Open PRs

Run `gh search prs --author=@me --state=open --json repository,title,url,updatedAt,reviewDecision` to list my own open PRs and their review status.

Note any that are approved and ready to merge.

### 4. Assigned Issues

Run `gh search issues --assignee=@me --state=open --json repository,title,url,updatedAt,labels,createdAt` to find issues assigned to me.

If any issue has a label containing "deadline", "due", "urgent", or "priority", call it out.

### 5. Recent Team Activity

For repos I have contributed to recently (check `gh api user/repos --jq '.[].full_name' -q 'sort_by(.pushed_at) | reverse | .[:5]'`), summarize any PRs merged in the last 24 hours.

If $ARGUMENTS contains an org or repo filter, limit this to the filtered scope.

### Output Format

Present the briefing with clear section headers:

```
DAILY BRIEFING - [today's date]
================================

NOTIFICATIONS ([count] unread)
- [summary of key notifications]

PRs NEEDING MY REVIEW ([count])
- [repo] [title] ([age]) [url]
  * STALE if > 7 days

MY OPEN PRs ([count])
- [repo] [title] - [review status] [url]

ASSIGNED ISSUES ([count])
- [repo] [title] [labels] [url]
  * URGENT/DEADLINE flags if applicable

RECENT TEAM ACTIVITY
- [repo]: [count] PRs merged in last 24h
```

If any section returns no results, show "None" and move on. Do not pad the output.
