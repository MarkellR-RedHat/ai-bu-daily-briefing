# ai-bu-daily-briefing

Claude Code slash commands that turn your GitHub activity into briefings you actually want to read. No more tab-switching between notifications, PR queues, and issue boards. Run one command, get the full picture.

Seven commands cover your entire workflow: morning briefings, standup prep, weekly digests, team health checks, return-from-absence catch-ups, risk scanning, and week-ahead planning.

Works as Claude Code slash commands and standalone shell aliases.

## What It Looks Like

### `/briefing` - Morning briefing

Your daily command. Prioritized, classified, one screen.

```
DAILY BRIEFING - 2026-06-26
================================

NOTIFICATIONS (3 unread)
  review_requested: Add batch inference endpoint (RedHatAI/llm-d)
  mention: Tracking issue for v0.5 release (RedHatAI/llm-d)
  review_requested: Fix OOM on long-context inputs (RedHatAI/vllm)

REVIEW REQUESTS (2)
  RedHatAI/llm-d: Fix memory leak in scheduler (2d old)
    https://github.com/RedHatAI/llm-d/pull/142
  RedHatAI/vllm: Update tokenizer config (12d old) STALE
    https://github.com/RedHatAI/vllm/pull/87

MY OPEN PRs (2)
  RedHatAI/llm-d: Add graceful shutdown handler APPROVED
    https://github.com/RedHatAI/llm-d/pull/138
    Ready to merge.
  RedHatAI/llm-d: Prefill pod autoscaler WAITING FOR REVIEW
    https://github.com/RedHatAI/llm-d/pull/145
    No review activity in 4d.

ASSIGNED ISSUES (2)
  RedHatAI/llm-d: Benchmark throughput on A100 cluster
    https://github.com/RedHatAI/llm-d/issues/95
  RedHatAI/llm-d: Write runbook for scaling prefill pods URGENT
    https://github.com/RedHatAI/llm-d/issues/101

TEAM ACTIVITY (last 24h)
  RedHatAI/llm-d: 4 PRs merged
  RedHatAI/vllm: 1 PR merged
```

### `/standup` - Standup prep

Three sections, bullets only, under 25 lines. Paste into Slack and go.

```
STANDUP - 2026-06-26 (Thursday)
========================================

YESTERDAY:
  Merged: Add graceful shutdown handler (RedHatAI/llm-d)
  Reviewed: Fix OOM on long-context inputs (RedHatAI/vllm)
  Updated: Prefill pod autoscaler (RedHatAI/llm-d) - addressed review comments
  Pushed 3 commits to RedHatAI/llm-d

TODAY:
  Ship: Add graceful shutdown handler (RedHatAI/llm-d) - approved, ready to merge
  Review: Fix memory leak in scheduler (RedHatAI/llm-d) - requested 2d ago
  Continue: Prefill pod autoscaler (RedHatAI/llm-d)
  Pick up: Write runbook for scaling prefill pods (RedHatAI/llm-d) [urgent]

BLOCKERS:
  Prefill pod autoscaler (RedHatAI/llm-d) - waiting 4d for review
```

### `/weekly-digest` - Week in review

End-of-week summary for your manager, your team, or your own records.

```
WEEKLY DIGEST - Jun 23 to Jun 27, 2026
=============================================
Summary: 4 shipped, 6 reviewed, 3 issues closed, 2 carrying over

SHIPPED (4 PRs merged)
  RedHatAI/llm-d:
    Add graceful shutdown handler (merged Thu)
      https://github.com/RedHatAI/llm-d/pull/138
    Implement request batching for decode phase (merged Tue)
      https://github.com/RedHatAI/llm-d/pull/131
    Fix metric label mismatch in Prometheus exporter (merged Mon)
      https://github.com/RedHatAI/llm-d/pull/128
  RedHatAI/vllm:
    Backport scheduler fix to v0.4.x (merged Wed)
      https://github.com/RedHatAI/vllm/pull/82

REVIEWS COMPLETED (6)
  RedHatAI/llm-d: Add KV cache compression support
  RedHatAI/llm-d: Refactor gateway routing logic
  RedHatAI/llm-d: Update CI to run on ARM64
  RedHatAI/vllm: Fix OOM on long-context inputs
  RedHatAI/vllm: Add structured output support
  RedHatAI/instructlab: Update taxonomy validation script

OPEN PRs (2)
  RedHatAI/llm-d: Prefill pod autoscaler - WAITING 4d
    https://github.com/RedHatAI/llm-d/pull/145
  RedHatAI/llm-d: Add distributed tracing - IN PROGRESS
    https://github.com/RedHatAI/llm-d/pull/149

ISSUES CLOSED (3)
  RedHatAI/llm-d: Benchmark throughput on A100 cluster
  RedHatAI/llm-d: Document gateway configuration options
  RedHatAI/vllm: Investigate scheduler deadlock under load

ISSUES OPEN (2)
  RedHatAI/llm-d: Write runbook for scaling prefill pods (8d old) [urgent]
    https://github.com/RedHatAI/llm-d/issues/101
  RedHatAI/llm-d: Evaluate LoRA adapter hot-swapping (18d old) STALE
    https://github.com/RedHatAI/llm-d/issues/78
```

### `/team-pulse` - Team health check

Built for leads. Shows who is active, which repos are hot, and which PRs are rotting.

```
TEAM PULSE - RedHatAI - Jun 20 to Jun 27
==================================================

HEALTH SIGNALS
  Review bottleneck: 40% of open PRs in llm-d have no review after 3d.
  Concentration risk: 70% of vllm commits from single contributor.

ACTIVE REPOS (last 7d, showing top 5)
  RedHatAI/llm-d: last push today, 12 open issues, 8 PRs merged / 6 open
  RedHatAI/vllm: last push yesterday, 5 open issues, 3 PRs merged / 4 open
  RedHatAI/instructlab: last push Mon, 2 open issues, 2 PRs merged / 1 open
  RedHatAI/llm-d-docs: last push Tue, 0 open issues, 1 PR merged / 0 open

PR FLOW
  RedHatAI/llm-d: 8 merged, 6 open, 3 aging (>7d), 1 ready to ship
  RedHatAI/vllm: 3 merged, 4 open, 2 aging (>7d), 0 ready to ship
  RedHatAI/instructlab: 2 merged, 1 open, 0 aging, 0 ready to ship

CONTRIBUTORS (last 7d, showing top 8)
  mrawls: 4 opened, 4 merged
  aconrad: 3 opened, 2 merged
  jdoe: 2 opened, 2 merged
  ksmith: 2 opened, 1 merged
  yli: 1 opened, 1 merged
  +3 more with activity

AGING PRs (4 needing attention)
  RedHatAI/llm-d: KV cache eviction policy (12d old) by @aconrad - no review
    https://github.com/RedHatAI/llm-d/pull/119
  RedHatAI/llm-d: Disaggregated serving protocol (9d old) by @ksmith - no review
    https://github.com/RedHatAI/llm-d/pull/125
  RedHatAI/vllm: Async tokenizer pipeline (11d old) by @yli - changes requested, no re-review
    https://github.com/RedHatAI/vllm/pull/79
  RedHatAI/vllm: Beam search optimization (8d old) by @jdoe - no review
    https://github.com/RedHatAI/vllm/pull/83
```

### `/catch-me-up` - Return from absence

You were out. Here is what you missed, ranked by what you need to do about it.

```
CATCH-UP BRIEFING - Jun 23 to Jun 26 (3 days)
============================================================

ACT ON THIS (4 items waiting on you)
  Review requested: Fix memory leak in scheduler (RedHatAI/llm-d) - opened 2d ago
    https://github.com/RedHatAI/llm-d/pull/142
  Review requested: Add structured output support (RedHatAI/vllm) - opened 3d ago
    https://github.com/RedHatAI/vllm/pull/85
  Changes requested on your PR: Prefill pod autoscaler (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/145
  New assignment: Write runbook for scaling prefill pods (RedHatAI/llm-d) [urgent]
    https://github.com/RedHatAI/llm-d/issues/101

BE AWARE (2 notable changes)
  RedHatAI/llm-d: KV cache compression approach changed - merged with 1200 lines
    after extensive discussion (14 comments)
    https://github.com/RedHatAI/llm-d/pull/136
  RedHatAI/vllm: Scheduler deadlock fix - high-priority issue resolved
    https://github.com/RedHatAI/vllm/issues/71

FYI - WHAT SHIPPED
  RedHatAI/llm-d: 6 PRs merged
    Highlight: Implement request batching for decode phase
  RedHatAI/vllm: 3 PRs merged
    Highlight: Backport scheduler fix to v0.4.x
  RedHatAI/instructlab: 2 PRs merged
  4 dependency updates merged across 2 repos
```

### `/risk-radar` - Risk and warning scan

Surfaces process failures, quality gaps, security issues, and sustainability concerns.

```
RISK RADAR - 2026-06-26 - RedHatAI
===============================================
Scanning 8 repos over last 14 days
Summary: 2 HIGH, 3 MEDIUM, 4 LOW

HIGH SEVERITY
  [PROCESS] RedHatAI/llm-d: PR "KV cache eviction policy" open 12d with no review
    https://github.com/RedHatAI/llm-d/pull/119
  [SECURITY] RedHatAI/vllm: 2 critical dependency alerts (torch: arbitrary code execution)
    https://github.com/RedHatAI/vllm/security/dependabot

MEDIUM SEVERITY
  [PROCESS] RedHatAI/vllm: PR "Async tokenizer" has changes requested, no update in 8d
    https://github.com/RedHatAI/vllm/pull/79
  [TEAM] RedHatAI/vllm: 70% of commits from single contributor
  [QUALITY] RedHatAI/llm-d: Test file deleted in recent merge (Refactor gateway routing)
    https://github.com/RedHatAI/llm-d/pull/133

LOW SEVERITY (4 items)
  [PROCESS] 3 PRs across 2 repos open 3-7d without review
  [TEAM] RedHatAI/llm-d: 5 after-hours commits this period
  [SECURITY] Dependabot alerts not enabled for RedHatAI/llm-d-docs
  [TECHNICAL] 2 open PRs have merge conflicts
```

### `/week-ahead` - Plan your week

Forward-looking. What is on your plate, what is coming, and what might surprise you.

```
WEEK AHEAD - Week of Jun 30, 2026
======================================
You have 2 open PRs, 3 pending reviews, 4 assigned issues

QUICK WINS (clear these first)
  Merge: Add graceful shutdown handler (RedHatAI/llm-d) - approved, ready to go
    https://github.com/RedHatAI/llm-d/pull/138

THIS WEEK'S WORK
  Fix: Prefill pod autoscaler (RedHatAI/llm-d) - changes requested
    https://github.com/RedHatAI/llm-d/pull/145
  Review: Fix memory leak in scheduler (RedHatAI/llm-d) - @aconrad waiting 2d
    https://github.com/RedHatAI/llm-d/pull/142
  Review: Add structured output support (RedHatAI/vllm) - @jdoe waiting 3d
    https://github.com/RedHatAI/vllm/pull/85
  Review: Update CI to run on ARM64 (RedHatAI/llm-d) - @ksmith waiting 1d
    https://github.com/RedHatAI/llm-d/pull/148
  Continue: Add distributed tracing (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/149
  Pick up: Write runbook for scaling prefill pods (RedHatAI/llm-d) [urgent]
    https://github.com/RedHatAI/llm-d/issues/101

WATCH OUT FOR
  Prefill pod autoscaler (RedHatAI/llm-d) hits 7d without review on Wed.
    Ping reviewers before then.
  Milestone "v0.5.0" due Jul 7: 4/9 issues still open.
  CI passing on main in all active repos. No blockers there.

YOU MIGHT WANT TO
  Check on your review of KV cache compression (RedHatAI/llm-d) from 5d
    ago - PR still open.
  Rebase distributed tracing PR (RedHatAI/llm-d) - last updated 6d ago,
    conflict risk.
  2 assigned issues untouched for 14+ days. Keep or reassign?
```

## Commands Reference

| Command | Purpose | Key flags |
|---------|---------|-----------|
| `/briefing` | Morning briefing with prioritized notifications, PRs, issues | `--org` `--repo` `--verbose` |
| `/standup` | Standup prep: yesterday, today, blockers | `--org` `--repo` `--days N` |
| `/weekly-digest` | Week-in-review summary for status updates | `--org` `--repo` `--weeks N` |
| `/team-pulse` | Org/team health check for leads | `--org` (required) `--team` `--days N` |
| `/catch-me-up` | Return-from-absence briefing | `<days>` (required) `--org` `--repo` |
| `/risk-radar` | Risk and warning scanner | `--org` `--repo` `--days N` `--severity` |
| `/week-ahead` | Forward-looking week planner | `--org` `--repo` `--include-team` |

## Shell Aliases

| Alias | Command |
|-------|---------|
| `morning` | `/briefing` |
| `standup` | `/standup` |
| `weekly` | `/weekly-digest` |
| `pulse` | `/team-pulse` |
| `catchmeup` | `/catch-me-up` |
| `riskradar` | `/risk-radar` |
| `weekahead` | `/week-ahead` |
| `prs` | List PRs needing your review (gh directly) |
| `greview` | Interactive PR review picker with fzf |
| `prs-stale` | PRs open >7 days requesting your review |
| `myissues` | Your assigned issues across repos |

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated
- [fzf](https://github.com/junegunn/fzf) (optional, enables `greview` interactive picker)

## Installation

Clone the repo and run the installer:

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-daily-briefing.git
cd ai-bu-daily-briefing
bash install.sh
```

The installer will:
1. Check for `claude`, `gh`, and `fzf` on your PATH.
2. Copy all seven Claude Code commands to `~/.claude/commands/`.
3. Detect existing commands and skip or update as needed.
4. Optionally add shell aliases to your `.zshrc` or `.bashrc`.

### Manual Installation

```bash
# Copy commands
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Source aliases (add to your shell rc file)
source /path/to/ai-bu-daily-briefing/shell/briefing-aliases.sh
```

## Customization

### Filtering by Org or Repo

All commands accept `--org` to limit results to one GitHub organization or `--repo` to focus on a single repository.

### Stale Thresholds

- PRs open > 7 days are flagged as STALE
- Issues open > 14 days are flagged as OLD
- These thresholds are defined in each command's `.md` file and can be edited

### Adding New Commands

Command files are plain Markdown with instructions for Claude. See `reference/briefing-format.md` for the formatting conventions. Add a new `.md` file to `commands/`, update the `COMMANDS` array in `install.sh`, and re-run the installer.

## How It Works

Each command file contains a structured prompt that tells Claude how to:
1. Run `gh` CLI commands to pull data from the GitHub API
2. Analyze and cross-reference the results
3. Prioritize and classify items by urgency
4. Format the output into a consistent, scannable briefing

No data is stored locally. Everything is fetched live from GitHub on each run.

## License

MIT
