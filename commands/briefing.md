# Daily Briefing

Generate a morning summary of my GitHub activity. The entire output MUST fit on one terminal screen (roughly 40 lines max). Be terse. No filler, no commentary, no motivational fluff.

## Rules

- Each item is ONE line. No multi-line descriptions.
- Use counts in section headers.
- If a section has zero items, print "None" on one line and move on.
- Do NOT add summaries, advice, or wrap-up paragraphs.
- Do NOT explain what you are doing. Just print the briefing.
- Stale threshold: flag any PR open longer than 7 days.

## Instructions

Use the `gh` CLI to gather data. Run commands, parse output, print the briefing. Nothing else.

$ARGUMENTS can optionally contain:
- `--org <name>` to filter results to one GitHub org
- `--repo <name>` to filter results to one repo
- `--verbose` for one extra detail line per item

### 1. Notifications

Run: `gh api notifications --jq '.[] | {reason, subject: .subject.title, repo: .repository.full_name, updated: .updated_at}'`

Count unread notifications. Only surface `review_requested` and `mention` types. If filtered by org/repo, match accordingly.

### 2. PRs Needing My Review

Run: `gh search prs --review-requested=@me --state=open --json repository,title,url,updatedAt,createdAt`

If `--org` provided, add `--owner=<org>`. If `--repo` provided, add `--repo=<repo>`.

Calculate age from `createdAt`. Flag >7 days as STALE.

### 3. My Open PRs

Run: `gh search prs --author=@me --state=open --json repository,title,url,updatedAt,reviewDecision`

Mark any that are approved and mergeable.

### 4. Assigned Issues

Run: `gh search issues --assignee=@me --state=open --json repository,title,url,updatedAt,labels,createdAt`

Flag issues with labels containing "deadline", "due", "urgent", or "priority".

### 5. Recent Team Activity

For my 5 most recently pushed repos (via `gh api user/repos --jq '.[].full_name' -q 'sort_by(.pushed_at) | reverse | .[:5]'`), count PRs merged in the last 24h.

If filtered by org/repo, scope accordingly.

## Output Format

Print exactly this structure. No deviations.

```
DAILY BRIEFING - [YYYY-MM-DD]
================================

NOTIFICATIONS ([count] unread)
- [reason]: [title] ([repo])

REVIEW REQUESTS ([count])
- [repo]: [title] ([N]d old) [STALE if >7d]
  [url]

MY OPEN PRs ([count])
- [repo]: [title] [APPROVED / CHANGES_REQUESTED / REVIEW_PENDING]
  [url]

ASSIGNED ISSUES ([count])
- [repo]: [title] [URGENT if flagged]
  [url]

TEAM ACTIVITY (last 24h)
- [repo]: [count] PRs merged
```
