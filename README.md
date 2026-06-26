# ai-bu-daily-briefing

It is 8:47 AM. You have a standup in 13 minutes. What happened yesterday?

You could open GitHub. Scan 12 notifications. Cross-reference 4 repos. Check which PRs need your review, which ones you already reviewed, which issues moved. Tab back to Slack to see if anyone pinged you. Tab back to GitHub. Try to remember what you actually shipped versus what you just looked at.

Or you could type `/briefing` and get this:

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

One screen. Prioritized. Every link pulled live from the GitHub API. You walk into standup knowing exactly what matters.

## Your morning, before and after

**Before**: Open GitHub. 12 notifications. Scan each one. Open 4 tabs. Check PRs in two repos. Try to figure out which reviews are waiting on you versus which ones you already did. Forget about the issue that got labeled urgent while you were asleep. Show up to standup and say "uh, I worked on the autoscaler thing."

**After**: Type `/briefing`. Read one screen. See that you have an approved PR ready to merge, a stale review you forgot about, and an urgent issue. Type `/standup`. Get three clean sections you can paste into Slack. Walk into the meeting prepared.

Total time: 90 seconds.

## Seven commands for your entire week

### `/briefing` - Your morning chief of staff

Pulls notifications, review requests, open PRs, assigned issues, and team activity. Prioritizes by urgency. Fits on one terminal screen. If nothing is on fire, it says so. Knowing nothing is urgent is useful information on its own.

### `/standup` - Talk points, not a to-do list

Three sections: yesterday, today, blockers. Under 25 lines. Ordered by impact, not chronology. The "today" section puts the thing that unblocks the most people first. Paste it into Slack and go.

```
STANDUP - 2026-06-26 (Thursday)
========================================

YESTERDAY:
  Merged: Add graceful shutdown handler (RedHatAI/llm-d)
  Reviewed: Fix OOM on long-context inputs (RedHatAI/vllm)
  Updated: Prefill pod autoscaler (RedHatAI/llm-d) - addressed review comments

TODAY:
  Ship: Add graceful shutdown handler (RedHatAI/llm-d) - approved, ready to merge
  Review: Fix memory leak in scheduler (RedHatAI/llm-d) - requested 2d ago
  Continue: Prefill pod autoscaler (RedHatAI/llm-d)
  Pick up: Write runbook for scaling prefill pods (RedHatAI/llm-d) [urgent]

BLOCKERS:
  Prefill pod autoscaler (RedHatAI/llm-d) - waiting 4d for review
```

### `/weekly-digest` - Your week, summarized honestly

End-of-week summary for your manager, your team, or yourself. Leads with a one-line summary ("4 shipped, 6 reviewed, 3 issues closed, 2 carrying over") so anyone skimming gets the picture in 3 seconds.

### `/team-pulse` - Built for leads

Shows which repos are active, which PRs are aging, and where review bottlenecks are forming. Surfaces patterns, not judgments. Finds the PR that has been open for 12 days with no review so you can ask "does someone need to pick this up?" instead of discovering it during a production incident.

```
TEAM PULSE - RedHatAI - Jun 20 to Jun 27
==================================================

HEALTH SIGNALS
  Review bottleneck: 40% of open PRs in llm-d have no review after 3d.
  Concentration risk: 70% of vllm commits from single contributor.

AGING PRs (4 needing attention)
  RedHatAI/llm-d: KV cache eviction policy (12d old) by @aconrad - no review
    https://github.com/RedHatAI/llm-d/pull/119
  RedHatAI/vllm: Async tokenizer pipeline (11d old) by @yli - changes requested
    https://github.com/RedHatAI/vllm/pull/79
```

### `/catch-me-up` - You were out. Here is what you missed.

Back from PTO? Out sick? Three days of back-to-back meetings? Tell it how long you were gone. It collapses everything into three sections: what needs your action, what changed direction, and what shipped. Stop reading after section one if you are in a hurry.

```
CATCH-UP BRIEFING - Jun 23 to Jun 26 (3 days)
============================================================

ACT ON THIS (4 items waiting on you)
  Review requested: Fix memory leak in scheduler (RedHatAI/llm-d) - opened 2d ago
    https://github.com/RedHatAI/llm-d/pull/142
  Changes requested on your PR: Prefill pod autoscaler (RedHatAI/llm-d)
    https://github.com/RedHatAI/llm-d/pull/145
```

### `/risk-radar` - Early warning signs

Scans for the things busy people miss: PRs rotting without review, CI failures on main, dependency vulnerabilities, unsustainable commit patterns. Assigns severity (HIGH/MEDIUM/LOW). Presents findings as observations, not judgments.

```
RISK RADAR - 2026-06-26 - RedHatAI
===============================================
Summary: 2 HIGH, 3 MEDIUM, 4 LOW

HIGH SEVERITY
  [PROCESS] RedHatAI/llm-d: PR "KV cache eviction policy" open 12d with no review
  [SECURITY] RedHatAI/vllm: 2 critical dependency alerts (torch: arbitrary code execution)
```

### `/week-ahead` - Plan your week with data

Forward-looking only. Starts with quick wins (approved PRs you can merge right now), lays out the week's work, then warns about time bombs (the PR about to go stale, the milestone coming due). Replaces Monday morning dread with a clear sequence.

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

Run these from any terminal, no Claude Code session needed.

| Alias | Runs |
|-------|------|
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

## Install

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-daily-briefing.git
cd ai-bu-daily-briefing
bash install.sh
```

The installer copies all seven commands to `~/.claude/commands/` and optionally adds shell aliases to your `.zshrc` or `.bashrc`. Checks prerequisites, detects existing commands, and updates changed ones.

### Manual install

```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Add to your shell rc file:
source /path/to/ai-bu-daily-briefing/shell/briefing-aliases.sh
```

## Customization

### Filtering by org or repo

All commands accept `--org` to limit results to one GitHub organization or `--repo` to focus on a single repository.

### Stale thresholds

- PRs open > 7 days are flagged as STALE
- Issues open > 14 days are flagged as OLD
- These thresholds are defined in each command file and can be edited to match your team's norms

### Adding new commands

Command files are plain Markdown with structured prompts for Claude. See `reference/briefing-format.md` for formatting conventions. Add a new `.md` file to `commands/`, update the `COMMANDS` array in `install.sh`, and re-run the installer.

## How it works

Each command is a Markdown file with a structured prompt that tells Claude to:
1. Run `gh` CLI commands to pull live data from the GitHub API
2. Cross-reference and prioritize by urgency, not recency
3. Format into a consistent, scannable briefing

Nothing stored locally. Everything fetched live on each run. No API keys beyond what `gh` and `claude` already have.

## License

MIT
