# Catch Me Up

You are briefing someone who just got back. Maybe they were on PTO. Maybe they were out sick. Maybe they just had three days of back-to-back meetings and never looked at GitHub. Whatever the reason, they feel behind. They are staring at a wall of notifications and they do not know where to start.

Your job is to make that feeling go away in two minutes.

You are not going to hand them a changelog. You are going to hand them a prioritized action plan: what needs their hands on it today, what changed direction while they were gone, and what shipped that they should know about. Structure it so they can stop reading after section 1 if they are in a hurry and still have everything they need to not look lost in their next meeting.

Think of yourself as a trusted colleague who says: "Okay, here is what you missed. Three things need you. Two things changed. Everything else is moving fine."

## The psychology of returning

Returning from time off is disorienting. The natural instinct is to read every notification chronologically, which takes hours and creates anxiety without clarity. Your job is to collapse N days of activity into a single document that replaces that instinct.

The structure matters:
1. **ACT ON THIS** answers "What do I need to do TODAY?" If this section is empty, say so clearly. That alone is worth the price of admission.
2. **BE AWARE** answers "What changed direction while I was out?" Only include things that would genuinely surprise them or that they will hear about in meetings.
3. **FYI** answers "What shipped?" This is context, not action. Keep it tight.

If the period was quiet, say so. "It was a quiet week. Nothing needs your immediate attention." That is a perfectly good briefing.

## Arguments

$ARGUMENTS should contain a number (days away) or a date range. Examples:
- `/catch-me-up 3` - I was out for 3 days
- `/catch-me-up 5` - I was out for 5 days (a full work week)
- `/catch-me-up 2025-06-20..2025-06-25` - specific date range
- `/catch-me-up monday` - since last Monday

Additional optional flags:
- `--org <name>` to filter to one GitHub org
- `--repo <name>` to filter to one repo

If no duration/range is provided, print exactly this and stop:
```
Usage: /catch-me-up <days> [--org <name>] [--repo <name>]
Examples:
  /catch-me-up 3
  /catch-me-up 5 --org RedHatAI
  /catch-me-up 2025-06-20..2025-06-25
```

## Chain of Thought

### Step 1: Parse the time range

Determine the lookback window from $ARGUMENTS:
- If a plain number, go back that many days from today
- If a date range (YYYY-MM-DD..YYYY-MM-DD), use those exact bounds
- If a day name (e.g., "monday"), calculate the most recent occurrence
- Compute the cutoff date/time in ISO format for `gh` queries

### Step 2: Gather what needs their action (Section 1: ACT ON THIS)

This is the most important section. Get it wrong and they miss something that is blocking a teammate. These are items waiting on THEM specifically:

1. **Unread notifications (review requests and mentions only)**: `gh api notifications --jq '[.[] | select(.reason == "review_requested" or .reason == "mention") | {reason, title: .subject.title, repo: .repository.full_name, updated: .updated_at}]'`
2. **PRs requesting their review that arrived during absence**: `gh search prs --review-requested=@me --state=open --json repository,title,url,createdAt` - filter to those created or updated during the absence window
3. **Issues assigned to them that were created or updated during absence**: `gh search issues --assignee=@me --state=open --json repository,title,url,labels,createdAt,updatedAt` - filter to those with activity during absence
4. **Their own PRs that received reviews while they were out**: `gh search prs --author=@me --state=open --json repository,title,url,reviewDecision,updatedAt` - filter to those updated during absence, especially those with CHANGES_REQUESTED

Sort by urgency: changes-requested PRs first (they are blocking the merge), then review requests (they are blocking teammates), then new assignments.

For each item, include enough context that they know WHY it matters, not just WHAT it is. "Review requested: Fix memory leak in scheduler (4 days ago, blocking @alice from shipping)" is better than "Review requested: Fix memory leak in scheduler."

### Step 3: Gather what changed direction (Section 2: BE AWARE)

Only include things that would genuinely change how they think about current work:

1. **PRs with significant discussion**: For their top repos, find PRs with 5+ comments that were active during absence. Use: `gh pr list --repo <repo> --state all --json title,url,comments,updatedAt,state,author` - filter to those with high comment counts and activity during absence.
2. **Issues with label changes**: Look for issues in their repos that were relabeled to/from "priority", "urgent", "blocked" during the absence window.
3. **Large PRs that merged**: Find merged PRs with significant changes: `gh pr list --repo <repo> --state merged --json title,url,mergedAt,additions,deletions,author` - filter to the absence window and sort by (additions + deletions) descending. Flag any with 500+ lines changed.

If nothing truly changed direction, say so. "Nothing notable changed direction during your absence." That is reassuring, not empty.

### Step 4: Gather what shipped (Section 3: FYI)

1. **All PRs merged in active repos during the window**: For each of the top 5 recently pushed repos, `gh pr list --repo <repo> --state merged --json title,url,mergedAt,author` - filter to absence window
2. **New releases or tags**: `gh api repos/<repo>/releases --jq '[.[] | select(.published_at > "CUTOFF_DATE") | {tag: .tag_name, name: .name, url: .html_url}]'`
3. **New repos created in the org**: If `--org` is provided, check for repos created during absence: `gh api orgs/<org>/repos?sort=created&per_page=5 --jq '[.[] | select(.created_at > "CUTOFF_DATE") | {name: .full_name, description: .description}]'`

Consolidate aggressively. If 10 PRs merged in one repo, do not list them all. Say "[repo]: 10 PRs merged (highlight: [biggest PR title])". Only individually list PRs with 200+ lines changed or notable titles.

### Step 5: Classify and cut

- Dependabot/renovate PRs: one line total. "[N] dependency updates merged across [repos]."
- Issues created AND closed during absence: skip unless labeled urgent. Fully resolved incidents do not need airtime unless they were severe.
- If the "FYI" section would exceed 15 items, consolidate by repo.

### Step 6: Self-critique

Before printing:
- Is Section 1 (ACT ON THIS) complete? Missing a review request here means they unknowingly block someone all day. Get this right.
- Is Section 2 (BE AWARE) genuinely important? Do not pad it with routine merges. Only things that would surprise them or come up in conversation.
- Is Section 3 (FYI) a useful summary and not a full changelog?
- Does the overall briefing feel like it respects their time? If they were out for 3 days, they should not need 5 minutes to read this.
- Total output should be under 60 lines for a 3-day absence, up to 80 lines for a full week.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Calibration Examples

### BAD: ACT ON THIS section (no urgency context)
```
ACT ON THIS (3 items waiting on you)
  Review requested: Fix memory leak in scheduler (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/142
  Your PR needs changes: Prefill pod autoscaler (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/145
  New issue assigned: Write scaling runbook (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/issues/101
```
Why it is bad: No age, no blocking context, no indication of who is waiting. The reader still does not know what to do first.

### GOOD: ACT ON THIS section (blocking context, sorted by urgency)
```
ACT ON THIS (3 items waiting on you)
  Changes requested on your PR: Prefill pod autoscaler (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/145
    @reviewer left 2 comments on error handling 3d ago. Blocking merge.
  Review requested: Fix memory leak in scheduler (RedHatAI/llm-d) - opened 4d ago
    https://github.com/RedHatAI/llm-d/pull/142
    @alice is blocked on this. Scheduler OOMs in production under load.
  New assignment: Write scaling runbook (RedHatAI/llm-d) [urgent]
    https://github.com/RedHatAI/llm-d/issues/101
    Tagged urgent while you were out. No deadline specified.
```
Why it is good: Changes-requested PR is first because it blocks YOUR merge. Review is next because it blocks a teammate. Each entry says WHY it matters, not just WHAT it is.

### BAD: FYI section (changelog dump)
```
FYI - WHAT SHIPPED
  RedHatAI/llm-d: Fix typo in README
  RedHatAI/llm-d: Update CI config
  RedHatAI/llm-d: Add batch inference endpoint
  RedHatAI/llm-d: Bump vLLM to 0.4.2
  RedHatAI/llm-d: Fix linter warnings
  RedHatAI/llm-d: Update CODEOWNERS
  RedHatAI/llm-d: Add P99 latency metric
  RedHatAI/vllm: Fix tokenizer race condition
  RedHatAI/vllm: Update docs
```
Why it is bad: Nine items listed individually, no hierarchy. Typo fixes and CODEOWNERS changes have the same visual weight as a new inference endpoint. This is a git log, not a briefing.

### GOOD: FYI section (consolidated, highlights only)
```
FYI - WHAT SHIPPED
  RedHatAI/llm-d: 7 PRs merged
    Highlight: Add batch inference endpoint, Add P99 latency metric, Bump vLLM to 0.4.2
  RedHatAI/vllm: 2 PRs merged
    Highlight: Fix tokenizer race condition
  3 dependency updates merged across 2 repos
```
Why it is good: Consolidated by repo, only notable PRs called out individually. The reader gets the picture in 4 lines instead of 9.

## Anti-Patterns (DO NOT do these)

- DO NOT dump every notification. Only review requests and mentions matter.
- DO NOT list every merged PR individually when there are more than 5 per repo. Summarize.
- DO NOT include closed-then-reopened issues unless they are still open.
- DO NOT say "while you were away, the team was busy." Just show what happened.
- DO NOT add "welcome back" or similar pleasantries. They do not need warmth from a command. They need information.
- DO NOT include items from before the absence window started.
- DO NOT say "several important changes were made." Name the changes or summarize with a count.

## Output Format

```
CATCH-UP BRIEFING - [start date] to [end date] ([N] days)
============================================================

ACT ON THIS ([count] items waiting on you)
  Review requested: [title] ([repo]) - opened [N]d ago
    [url]
  Changes requested on your PR: [title] ([repo])
    [url]
  New assignment: [title] ([repo]) [label if relevant]
    [url]

BE AWARE ([count] notable changes)
  [repo]: [title] - [what changed: merged with 800 lines, reprioritized, etc.]
    [url]
  [repo]: [title] - heavy discussion ([N] comments)
    [url]

FYI - WHAT SHIPPED
  [repo]: [N] PRs merged
    Highlight: [title of biggest/most notable PR]
  [repo]: [N] PRs merged
  [N] dependency updates merged across [N] repos
  New release: [repo] [tag]

  Nothing notable changed direction during your absence.
```
