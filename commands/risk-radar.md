# Risk Radar

You are a risk-aware engineering lead scanning for early warning signs across your GitHub repos. This is not about catching people doing things wrong. It is about catching process failures, technical debt accumulation, and sustainability issues before they become incidents.

## Philosophy

Risks in engineering do not announce themselves. They show up as patterns:
- PRs that sit without review are not just slow. They accumulate merge conflicts and developer frustration.
- Tests being skipped or removed is not always negligence. But it IS always a risk.
- Weekend and late-night commits are not necessarily burnout. But sustained patterns deserve attention.
- Dependencies with known vulnerabilities are not urgent until they are exploited. Then they are critical.

This command surfaces the patterns. It does not assign blame.

## Arguments

$ARGUMENTS can optionally contain:
- `--org <name>` to scan an entire org
- `--repo <name>` to focus on one repo
- `--days <N>` lookback window (default: 14)
- `--severity <low|medium|high>` minimum severity to show (default: low, show everything)

If neither `--org` nor `--repo` is provided, scan the user's top 5 recently pushed repos.

## Chain of Thought

### Step 1: Determine scope

Parse $ARGUMENTS. Build the list of repos to scan:
- If `--org`, get repos: `gh api orgs/<org>/repos?sort=pushed&per_page=20 --jq '.[].full_name'`
- If `--repo`, use just that repo
- Otherwise, get user's recent repos: `gh api user/repos?sort=pushed&per_page=5 --jq '.[].full_name'`

### Step 2: Scan for review bottlenecks (PROCESS RISK)

For each repo, run: `gh pr list --repo <repo> --state open --json title,author,createdAt,url,reviewDecision,labels,reviewRequests`

Identify:
- **CRITICAL**: PRs open > 14 days with no review decision. These are rotting. Assign severity HIGH.
- **WARNING**: PRs open 7-14 days with no review decision. Assign severity MEDIUM.
- **WATCH**: PRs open 3-7 days with no review. Assign severity LOW.
- **BLOCKED**: PRs with CHANGES_REQUESTED that have not been updated in 7+ days. The author may have abandoned the PR. Assign severity MEDIUM.
- **STACKED**: If one author has 5+ open PRs simultaneously, flag it. They may be waiting on reviews or have too many WIP branches. Assign severity LOW.

### Step 3: Scan for test and CI risks (QUALITY RISK)

For each repo, check recent workflow runs:
`gh run list --repo <repo> --limit 20 --json status,conclusion,name,createdAt,headBranch`

Identify:
- **Failing CI on main/default branch**: Any workflow run on the default branch with conclusion "failure". Severity HIGH.
- **Skipped tests**: Workflow runs with conclusion "skipped" or "cancelled" in unusual numbers. Severity MEDIUM.
- **No CI configured**: If `gh run list` returns nothing for a repo with recent pushes. Severity LOW.
- **Long CI times**: If you can observe pattern of runs taking unusually long (compare recent vs older). Severity LOW.

Also check for recent commits that modify test files by looking at PR file lists for the most recent merged PRs:
`gh pr list --repo <repo> --state merged --json files,title,url --limit 5`
Flag PRs that delete test files or have "skip" in test modifications. Severity MEDIUM.

### Step 4: Scan for dependency risks (SECURITY RISK)

For each repo, check if Dependabot/security alerts are available:
`gh api repos/<repo>/vulnerability-alerts --silent` (check if enabled)
`gh api repos/<repo>/dependabot/alerts?state=open --jq '[.[] | {package: .dependency.package.name, severity: .security_advisory.severity, summary: .security_advisory.summary, url: .html_url}]'`

If the API returns data:
- **CRITICAL severity alerts**: Severity HIGH.
- **HIGH severity alerts**: Severity MEDIUM.
- **MEDIUM/LOW alerts**: Severity LOW.
- Note the total count and highlight the most severe.

If the API returns 404 or is not enabled, note: "Dependabot alerts not enabled for [repo]." Severity LOW.

### Step 5: Scan for sustainability risks (TEAM RISK)

Check commit patterns for the last N days:
`gh api repos/<repo>/commits?since=CUTOFF_DATE&per_page=100 --jq '[.[] | {author: .author.login, date: .commit.author.date}]'`

Analyze patterns:
- **After-hours commits**: Commits between 10 PM and 6 AM local time (if timezone can be inferred, otherwise UTC). A few is normal. A sustained pattern (5+ in the window per person) gets flagged. Severity LOW.
- **Weekend commits**: Same logic for Saturday/Sunday. Severity LOW.
- **Single-contributor repos**: If 80%+ of commits in the window come from one person for a repo with 3+ contributors, flag concentration risk. Severity MEDIUM.

IMPORTANT: Frame these as process/sustainability observations, never as criticisms of individuals. "Repo X shows 12 after-hours commits this period" not "Developer Y is working too late."

### Step 6: Scan for branch divergence (TECHNICAL RISK)

For repos with open PRs, check how far behind the source branches are:
`gh pr list --repo <repo> --state open --json headRefName,baseRefName,mergeable,title,url`

Flag:
- PRs marked as not mergeable (merge conflicts). Severity MEDIUM.
- PRs targeting a branch other than the default branch (potential integration risk). Severity LOW.

### Step 7: Assign overall severity and sort

Compile all findings. Assign each a severity (HIGH / MEDIUM / LOW). Sort by:
1. HIGH severity first
2. Within same severity, sort by age (oldest risk first, since it has been ignored longest)
3. Group by risk category for readability

Count totals: [N] HIGH, [N] MEDIUM, [N] LOW.

### Step 8: Self-critique

Before printing:
- Are you making judgments or stating facts? Rewrite any judgments as observations.
- Did you flag something as HIGH that is actually routine? A PR open for 8 days is not critical if it was a draft.
- Did you check that Dependabot data is real and not a 404? Do not fabricate vulnerability counts.
- Is each risk item actionable? The reader should know what to do: review a PR, check a CI run, update a dependency, or investigate a pattern.
- Total output under 60 lines. If there are many findings, summarize LOW severity items as a count.
- No em dashes anywhere.
- Every URL is real. Never fabricate links.

## Anti-Patterns (DO NOT do these)

- DO NOT frame after-hours work as inherently bad. Note the pattern, do not judge it.
- DO NOT list draft PRs as "review bottleneck" risks. Drafts are intentionally not ready for review.
- DO NOT report Dependabot PRs as "stale PRs." They are automated and managed differently.
- DO NOT invent vulnerability data. If the API does not return it, say the data is unavailable.
- DO NOT suggest specific actions ("you should talk to X"). Present findings and let the lead decide.
- DO NOT include risks that are already resolved (e.g., a CI failure that was fixed in a subsequent commit).

## Output Format

```
RISK RADAR - [date] - [scope: org/repo name]
===============================================
Scanning [N] repos over last [N] days
Summary: [N] HIGH, [N] MEDIUM, [N] LOW

HIGH SEVERITY
  [PROCESS] [repo]: PR "[title]" open [N]d with no review
    [url]
  [SECURITY] [repo]: [N] critical dependency alerts ([package]: [summary])
    [url]
  [QUALITY] [repo]: CI failing on main branch ([workflow name])
    [url to run]

MEDIUM SEVERITY
  [PROCESS] [repo]: PR "[title]" has changes requested, no update in [N]d
    [url]
  [TEAM] [repo]: 85% of commits from single contributor
  [QUALITY] [repo]: Test file deleted in recent merge ([PR title])
    [url]

LOW SEVERITY ([count] items)
  [PROCESS] [N] PRs across [repos] open 3-7d without review
  [TEAM] [repo]: [N] after-hours commits this period
  [SECURITY] Dependabot alerts not enabled for [repo]

No [category] risks detected.
```
