# Week Ahead

You are helping an engineer plan their week by looking at what is already on their plate, what is coming, and what might surprise them. This is a forward-looking command. It does not report what happened. It tells you what is about to happen and what you should do about it.

## Philosophy

Most engineers start Monday with a vague sense of "I have a lot to do" but no clear sequence. This command fixes that by answering:
1. What can I ship today with zero effort? (approved PRs, ready-to-close issues)
2. What will need my attention this week? (pending reviews, upcoming milestones)
3. What might go sideways? (aging PRs about to go stale, CI issues, dependencies)
4. What should I proactively do to make the week go smoother?

This is a planning tool, not a reporting tool.

## Arguments

$ARGUMENTS can optionally contain:
- `--org <name>` to filter to one GitHub org
- `--repo <name>` to filter to one repo
- `--include-team` to also show team-wide upcoming items (requires org)

If no flags are given, focus on the user's personal work across all repos.

## Chain of Thought

### Step 1: Take stock of current commitments

Gather everything currently on the user's plate:

1. **My open PRs and their status**: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision,labels,updatedAt`
   - Classify each: APPROVED (ship it), CHANGES_REQUESTED (fix it), NO_REVIEW (follow up), DRAFT (continue working)
   
2. **My assigned issues**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt,updatedAt`
   - Note any with deadline/milestone labels
   - Note any that have gone cold (no update in 7+ days)

3. **Reviews requested from me**: `gh search prs --review-requested=@me --state=open --json repository,title,url,createdAt,author`
   - Sort by age (oldest first, since those people have been waiting longest)

### Step 2: Identify quick wins

Items you can close out in minutes:
- PRs that are APPROVED: just merge them
- Issues that are actually done but not closed
- Reviews requested that are small (if you can estimate from title/context)

List these as "QUICK WINS" at the top. Starting the week by closing things out builds momentum and unblocks teammates.

### Step 3: Project the week's work

Based on current state, estimate the week's shape:
- **Monday-Tuesday**: Clear the quick wins, address changes-requested PRs, do pending reviews
- **Wednesday-Thursday**: Focus blocks for in-progress work, new PRs
- **Friday**: Wrap up, avoid starting new large PRs that will sit over the weekend

This is a rough shape, not a rigid schedule. Present it as guidance.

### Step 4: Scan for upcoming milestones and deadlines

Check for milestone-related items:
`gh api search/issues?q=assignee:@me+is:open+milestone:* --jq '.items[] | {title: .title, milestone: .milestone.title, due: .milestone.due_on, url: .html_url}'`

For org-scoped queries, also check:
`gh api repos/<repo>/milestones?state=open --jq '[.[] | select(.due_on != null) | {title: .title, due: .due_on, open: .open_issues, closed: .closed_issues}]'`

Flag any milestones due within the next 14 days. Calculate progress (closed / total issues).

### Step 5: Generate "watch out for" warnings

Based on the current state, generate specific warnings:

- **Stale PR warning**: If any of your PRs will cross the 7-day mark this week, warn about it. "PR [title] hits 7 days on [day] with no review. Consider pinging reviewers."
- **Review queue warning**: If you have 3+ pending review requests, warn about review debt.
- **Merge conflict risk**: If any of your PRs have not been rebased in 5+ days, flag potential conflicts.
- **End-of-sprint items**: If milestones are due this week, flag remaining open issues.
- **CI health**: Check if any recent CI runs on default branch are failing: `gh run list --repo <repo> --branch main --limit 3 --json conclusion,name` - a failing main branch will block all your PRs.

### Step 6: Generate "you might want to" suggestions

Proactive actions that are not urgent but would be smart:

- If you reviewed a PR 5+ days ago and it is still open, check if the author addressed your comments.
- If you have PRs approved but not merged, merge them before they go stale or get conflicts.
- If you have issues assigned but untouched for 14+ days, consider whether to keep them or reassign.
- If a repo you contribute to has failing CI on main, fixing it unblocks everyone.

Only include suggestions that are grounded in actual data. Do not generate generic advice.

### Step 7: Team view (if --include-team)

If `--include-team` is passed and `--org` is provided:
- Show PRs from team members that have been waiting for review > 3 days
- Show upcoming milestones for the org
- Show any repos with CI failures on default branch

### Step 8: Self-critique

Before printing:
- Is the "quick wins" section actually quick? Merging an approved PR with merge conflicts is not a quick win.
- Are warnings based on real data or speculation? Do not warn about merge conflicts you have not checked for.
- Are suggestions actionable and specific? "You might want to review some PRs" is useless. "Review @alice's auth-token-rotation PR (requested 4 days ago)" is useful.
- Is the weekly shape realistic? Do not suggest doing 20 things on Monday.
- Total output under 50 lines without `--include-team`, up to 70 with it.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Anti-Patterns (DO NOT do these)

- DO NOT turn this into a standup or a briefing. This is FORWARD-looking only. Do not report what happened yesterday.
- DO NOT include generic productivity advice ("remember to take breaks"). Only data-driven suggestions.
- DO NOT schedule specific times. Engineers know their own calendars. Suggest sequencing, not scheduling.
- DO NOT include items that are not the user's responsibility (unless --include-team is passed).
- DO NOT suggest creating new issues or PRs unless there is a clear reason from the data.

## Output Format

```
WEEK AHEAD - Week of [Mon DD, YYYY]
======================================
You have [N] open PRs, [N] pending reviews, [N] assigned issues

QUICK WINS (clear these first)
  Merge: [title] ([repo]) - approved, ready to go
    [url]
  Merge: [title] ([repo]) - approved
    [url]
  Close: [title] ([repo]) - looks resolved
    [url]

THIS WEEK'S WORK
  Fix: [title] ([repo]) - changes requested
    [url]
  Review: [title] ([repo]) - @[author] waiting [N]d
    [url]
  Continue: [title] ([repo]) - [status/context]
    [url]

WATCH OUT FOR
  [title] ([repo]) hits 7d without review on [day]. Ping reviewers.
  CI failing on main in [repo]. Your PRs will be blocked.
  Milestone "[name]" due [date]: [N]/[M] issues still open.

YOU MIGHT WANT TO
  Check on your review of [title] ([repo]) from [N]d ago - still open.
  Rebase [title] ([repo]) - last updated [N]d ago, conflict risk.
  [N] assigned issues untouched for 14+ days. Keep or reassign?
```
