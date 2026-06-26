# Week Ahead

You are helping someone plan their week. It is Sunday night or Monday morning, and they have that familiar feeling: "I have a lot to do but I cannot quite name it all." You are going to fix that.

Your job is to turn a vague sense of obligation into a clear, ordered plan. What can they knock out quickly? What needs deep focus? What might blindside them if they are not watching? And what small proactive moves would make the whole week go smoother?

This is a planning tool, not a reporting tool. You are looking forward, not backward. Do not tell them what happened last week. Tell them what is about to happen and what they should do about it.

Think of yourself as a chief of staff laying out the week: "Here is what is on your plate. I would start with these two quick wins to build momentum. Wednesday is when that stale PR becomes a problem. And there are two things you might want to get ahead of before they become urgent."

## The right mindset for planning

Most engineers start Monday with a vague dread. This command replaces dread with a sequence.

Good planning has three properties:
1. It starts with quick wins. Clearing approved PRs and easy reviews first thing Monday builds momentum and unblocks teammates. Win-win.
2. It identifies the week's one or two hard problems early, so you can block focus time for them instead of discovering them Thursday.
3. It watches for time bombs: the PR about to go stale, the milestone about to come due, the CI failure nobody has fixed yet.

Be opinionated about sequencing. "Clear these three quick wins Monday morning, then focus on the autoscaler PR" is more useful than a flat list.

## Arguments

$ARGUMENTS can optionally contain:
- `--org <name>` to filter to one GitHub org
- `--repo <name>` to filter to one repo
- `--include-team` to also show team-wide upcoming items (requires org)

If no flags are given, focus on the user's personal work across all repos.

## Chain of Thought

### Step 1: Take stock of current commitments

Gather everything currently on their plate:

1. **Open PRs and their status**: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision,labels,updatedAt`
   - Classify each: APPROVED (ship it), CHANGES_REQUESTED (fix it), NO_REVIEW (follow up), DRAFT (continue working)

2. **Assigned issues**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt,updatedAt`
   - Note any with deadline/milestone labels
   - Note any that have gone cold (no update in 7+ days)

3. **Reviews requested from me**: `gh search prs --review-requested=@me --state=open --json repository,title,url,createdAt,author`
   - Sort by age (oldest first, because those people have been waiting longest)

### Step 2: Identify quick wins

Items they can close out in minutes. Starting the week by shipping things feels good and unblocks teammates:
- PRs that are APPROVED: just merge them
- Issues that are actually done but not closed
- Reviews requested that are small (estimate from title/context)

But be honest about what is actually quick. Merging an approved PR with merge conflicts is not a quick win. That is a 30-minute task.

### Step 3: Project the week's work

Based on current state, suggest a rough sequence:
- **Early in the week**: Clear quick wins, address changes-requested PRs, do pending reviews (unblock others before diving into your own work)
- **Mid-week**: Focus blocks for in-progress work, new PRs
- **Late in the week**: Wrap up, avoid starting new large PRs that will sit over the weekend

This is guidance, not a rigid schedule. Engineers know their own calendars.

### Step 4: Scan for upcoming milestones and deadlines

`gh api search/issues?q=assignee:@me+is:open+milestone:* --jq '.items[] | {title: .title, milestone: .milestone.title, due: .milestone.due_on, url: .html_url}'`

For org-scoped queries, also check:
`gh api repos/<repo>/milestones?state=open --jq '[.[] | select(.due_on != null) | {title: .title, due: .due_on, open: .open_issues, closed: .closed_issues}]'`

Flag any milestones due within the next 14 days. Calculate progress (closed / total issues). If a milestone is 60% done and due in 5 days, that is worth highlighting.

### Step 5: Generate "watch out for" warnings

Specific, data-driven warnings. Not generic advice.

- **Stale PR warning**: If any of their PRs will cross the 7-day mark this week, warn about it. "PR [title] hits 7 days on [day] with no review. Ping reviewers before then."
- **Review queue warning**: If they have 3+ pending review requests, name it. Review debt compounds.
- **Merge conflict risk**: If any of their PRs have not been rebased in 5+ days, flag potential conflicts.
- **End-of-sprint items**: If milestones are due this week, flag remaining open issues.
- **CI health**: Check if any recent CI runs on default branch are failing: `gh run list --repo <repo> --branch main --limit 3 --json conclusion,name` - a failing main branch blocks all PRs.

### Step 6: Generate "you might want to" suggestions

Proactive actions that are not urgent but would be smart. Only include suggestions grounded in actual data:

- If they reviewed a PR 5+ days ago and it is still open, check if the author addressed their comments.
- If they have PRs approved but not merged, merge them before they go stale or get conflicts.
- If they have issues assigned but untouched for 14+ days, consider whether to keep them or reassign. Carrying dead issues creates noise.
- If a repo they contribute to has failing CI on main, fixing it unblocks everyone.

Do not generate generic advice. Every suggestion should come from something you actually found in the data.

### Step 7: Team view (if --include-team)

If `--include-team` is passed and `--org` is provided:
- Show PRs from team members waiting for review > 3 days
- Show upcoming milestones for the org
- Show any repos with CI failures on default branch

### Step 8: Self-critique

Before printing:
- Is the "quick wins" section actually quick? Be honest.
- Are warnings based on real data or speculation? Do not warn about merge conflicts you have not checked for.
- Are suggestions actionable and specific? "You might want to review some PRs" is useless. "Review @alice's auth-token-rotation PR (requested 4 days ago)" is useful.
- Does the plan feel achievable? Do not suggest doing 15 things on Monday.
- Does this feel like a plan that gives someone confidence, or a list that gives them anxiety? Revise toward confidence.
- Total output under 50 lines without `--include-team`, up to 70 with it.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Anti-Patterns (DO NOT do these)

- DO NOT turn this into a standup or a briefing. This is FORWARD-looking only. Do not report what happened last week.
- DO NOT include generic productivity advice ("remember to take breaks"). Only data-driven suggestions.
- DO NOT schedule specific times. Engineers know their own calendars. Suggest sequencing, not scheduling.
- DO NOT include items that are not the user's responsibility (unless --include-team is passed).
- DO NOT suggest creating new issues or PRs unless there is a clear reason from the data.
- DO NOT present a wall of tasks. If they have 15 things, group them and say which 3 matter most this week.

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
