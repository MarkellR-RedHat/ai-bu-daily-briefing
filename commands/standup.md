# Standup Prep

You are helping someone prepare for a standup that starts in a few minutes. They need to sound sharp, specific, and honest. They do not have time to dig through GitHub. You have already done the digging.

Your output will be read aloud or pasted into Slack verbatim. It needs to be tight enough that the person can scan it in 30 seconds and walk into the meeting confident. Nobody wants to hear "I worked on stuff." They want to hear what shipped, what is next, and what is stuck.

Think of yourself as the person's chief of staff, handing them a note card right before they walk on stage. Every bullet should make them sound like someone who knows exactly what is going on.

## What makes a standup actually useful

A standup has three jobs:
1. Tell the team what you finished (so they stop waiting on it).
2. Tell the team what you are doing next (so they can coordinate).
3. Surface blockers early (so someone can help before it gets worse).

If your standup does not do all three, it wasted everyone's time.

But here is the thing most people get wrong: the "today" section is not a wish list. It should be ordered by impact. The thing that unblocks the most people goes first. The thing only you care about goes last.

A great "today" section reads like a decision: "I am doing THIS first because it matters most, then THAT."

## Arguments

$ARGUMENTS can optionally contain:
- `--org <name>` to filter results to one GitHub org
- `--repo <name>` to filter results to one repo
- `--days <N>` to look back N days instead of the default 1 day (useful for Monday standups covering the weekend)
- If no flags are given, cover all repos the user has access to
- If it is Monday (or the first workday after a gap), automatically look back 3 days unless `--days` overrides this

## Chain of Thought

### Step 1: Determine the lookback window

Check what day of the week it is. If Monday, set lookback to 3 days (covering Fri/Sat/Sun). Otherwise, set lookback to 1 day. If `--days <N>` is provided, use that instead.

### Step 2: Gather "yesterday" data

Run these commands and filter to the lookback window:

1. **PRs I merged**: `gh search prs --author=@me --merged --json repository,title,url,mergedAt` - filter to lookback window
2. **PRs I reviewed**: `gh api search/issues?q=reviewed-by:@me+is:pr+updated:>CUTOFF_DATE --jq '.items[] | {title: .title, repo: .repository_url, url: .html_url}'` - if this fails, use `gh search prs --reviewed-by=@me --state=merged --json repository,title,url,updatedAt` as fallback
3. **PRs I updated (pushed commits)**: `gh search prs --author=@me --state=open --json repository,title,url,updatedAt` - filter to lookback window
4. **Issues I commented on or closed**: `gh search issues --commenter=@me --updated=">CUTOFF_DATE" --json repository,title,url,state`
5. **Push events**: `gh api user/events --jq '[.[] | select(.type == "PushEvent") | select(.created_at > "CUTOFF_DATE") | {repo: .repo.name, commits: (.payload.commits | length)}]'`

Apply `--org` / `--repo` filters as appropriate.

### Step 3: Gather "today" data

1. **My PRs awaiting review**: `gh search prs --author=@me --state=open --review=required --json repository,title,url,createdAt`
2. **PRs requesting my review**: `gh search prs --review-requested=@me --state=open --json repository,title,url,createdAt`
3. **My PRs approved and ready to merge**: `gh search prs --author=@me --state=open --json repository,title,url,reviewDecision` - filter to APPROVED
4. **High-priority assigned issues**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels` - prioritize items labeled urgent/blocker/critical/deadline

### Step 4: Identify blockers (be honest, be precise)

A blocker is not "I have a lot to do." A blocker is something where you CANNOT make progress without someone else acting. Be precise about what is blocked and who holds the key.

1. My PRs waiting on review for 3+ days with no review decision: `gh search prs --author=@me --state=open --json repository,title,url,createdAt,reviewDecision` - filter to those where reviewDecision is empty/null and createdAt > 3 days ago
2. Issues assigned to me with a "blocked" or "waiting" label
3. PRs where changes were requested but the reviewer has not re-reviewed after I pushed updates

If nothing qualifies as a genuine blocker, say "No blockers" and mean it. Do not invent blockers to fill space. "No blockers" is good news.

### Step 5: Prioritize the "today" section with courage

Order items by impact, not recency:
1. PRs approved and ready to merge (free wins, ship them immediately and unblock downstream work)
2. Review requests from others (you are blocking real people, unblock them first)
3. PRs you need to continue working on
4. Issues to pick up

If one item is clearly more important than the others, put it first and make that obvious. Do not be afraid to have opinions about what matters most.

### Step 6: Self-critique

Before printing:
- Is every bullet specific enough that a teammate knows what you are talking about? "Updated the PR" is useless. "Addressed review comments on auth token rotation PR" is useful.
- Are there more than 8 bullets in any section? If so, consolidate. "Reviewed 4 PRs in llm-d" is better than listing all four individually.
- Is the total output under 25 lines? If not, cut the least important items. Brevity is respect for the team's time.
- Did you avoid all filler phrases? No "I plan to," no "I will be," no "I hope to." Just state what is next.
- Does the "today" section read like a plan with a clear first move? If everything seems equal priority, you have not thought hard enough.
- No em dashes anywhere.

## Anti-Patterns (DO NOT do these)

- DO NOT start bullets with "I" - use the action: "Merged," "Reviewed," "Pushed," not "I merged," "I reviewed."
- DO NOT include items where the only activity was an automated bot comment.
- DO NOT list the same PR in both "yesterday" and "today" unless the context is different (e.g., "Updated" yesterday, "Ready to merge" today).
- DO NOT pad empty sections. "Nothing" on one line. Move on.
- DO NOT add a greeting, sign-off, or motivational note.
- DO NOT make the person sound busy. Make them sound effective. There is a difference.

## Output Format

```
STANDUP - [YYYY-MM-DD] ([day of week])
========================================

YESTERDAY:
  Merged: [title] ([repo])
  Reviewed: [title] ([repo])
  Updated: [title] ([repo]) - [what changed, 5 words max]
  Pushed [N] commits to [repo]

TODAY:
  Ship: [title] ([repo]) - approved, ready to merge
  Review: [title] ([repo]) - requested [N]d ago
  Continue: [title] ([repo])
  Pick up: [title] ([repo]) [label if relevant]

BLOCKERS:
  [title] ([repo]) - waiting [N]d for review from [reviewer if known]
  No blockers.
```
