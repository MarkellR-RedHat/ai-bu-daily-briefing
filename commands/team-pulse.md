# Team Pulse

Check activity across a GitHub org or team. Shows who is active, which repos are hot, and which PRs are aging. Built for leads and managers who need a quick read on team health.

## Rules

- Keep total output under 50 lines.
- One line per item. No multi-line descriptions.
- Sort by activity level (most active first).
- Do NOT add commentary, coaching advice, or wrap-up paragraphs.
- Do NOT explain what you are doing. Just print the pulse.

## Instructions

$ARGUMENTS must contain `--org <name>` to specify the GitHub org. Optionally include `--team <name>` or `--days <N>` (default 7).

If no `--org` is provided, print: "Usage: /team-pulse --org <org-name>" and stop.

### 1. Active Repos

Run: `gh api orgs/<org>/repos --jq '[.[] | select(.pushed_at > "<cutoff-date>") | {name: .full_name, pushed: .pushed_at, open_issues: .open_issues_count}] | sort_by(.pushed_at) | reverse | .[:10]'`

Use the `--days` value (default 7) to calculate the cutoff date. List the top 10 repos with recent pushes.

### 2. Open PR Summary

For each active repo (top 5), run: `gh pr list --repo <repo> --state open --json title,author,createdAt,url,reviewDecision`

Count total open PRs. Flag any older than 7 days as aging.

### 3. Contributor Activity

Run: `gh api orgs/<org>/members --jq '.[].login'` to get the member list.

For each member (or top 20), check recent PR activity: `gh search prs --author=<user> --owner=<org> --json repository,title,createdAt,state`

Filter to the last N days. Count PRs opened and merged per person.

### 4. Aging PRs

Across all repos checked, list PRs open longer than 7 days with no review decision.

## Output Format

```
TEAM PULSE - [org] - [date range]
===================================

ACTIVE REPOS (last [N]d)
- [repo]: pushed [date], [N] open issues

OPEN PRs ([total count])
- [repo]: [count] open, [count] aging (>7d)

CONTRIBUTORS (last [N]d)
- [username]: [N] PRs opened, [N] merged

AGING PRs ([count] with no review)
- [repo]: [title] ([N]d old) by @[author]
  [url]
```
