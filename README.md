# ai-bu-daily-briefing

**Stop tab-juggling GitHub every morning. Get your whole day on one screen.**

You have a standup in 13 minutes. What happened yesterday?

You open GitHub. Twelve notifications. You scan each one, open four tabs, cross-reference PRs across two repos, try to remember what you shipped versus what you just looked at. You tab over to Slack to see if anyone pinged you. Tab back. Forget about the issue that got labeled urgent while you were asleep. Show up to standup and say "uh, I worked on the autoscaler thing."

There is a better way.

## Quick start

```bash
# Install (30 seconds)
git clone https://github.com/MarkellR-RedHat/ai-bu-daily-briefing.git
cd ai-bu-daily-briefing
bash install.sh

# Your first command (inside Claude Code)
/briefing
```

That is it. Seven slash commands get installed to `~/.claude/commands/`. Run them inside any Claude Code session.

## Before and after

| | Before | After |
|---|---|---|
| **Morning prep** | Open GitHub, scan 12 notifications, open 4 tabs, cross-reference 2 repos, forget the urgent issue | Type `/briefing`, read one screen, see everything prioritized |
| **Standup** | Scramble to reconstruct yesterday from memory | Type `/standup`, paste 3 clean sections into Slack |
| **After PTO** | Spend an hour reading through days of notifications | Type `/catch-me-up 3`, get action items first |
| **Total time** | 15-20 minutes | 90 seconds |

## What you get

Type `/briefing` and see this:

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

## Commands

| Command | What it does | Key flags |
|---|---|---|
| `/briefing` | Morning briefing: notifications, PRs, issues, team activity | `--org` `--repo` `--verbose` |
| `/standup` | Standup prep: yesterday, today, blockers (under 25 lines) | `--org` `--repo` `--days N` |
| `/weekly-digest` | End-of-week summary for status updates or your manager | `--org` `--repo` `--weeks N` |
| `/team-pulse` | Org health check: review bottlenecks, aging PRs, concentration risk | `--org` (required) `--team` `--days N` |
| `/catch-me-up` | Return-from-absence briefing: action items first, then context | `<days>` (required) `--org` `--repo` |
| `/risk-radar` | Early warning scanner: stale PRs, CI failures, dependency alerts | `--org` `--repo` `--days N` `--severity` |
| `/week-ahead` | Monday planner: quick wins first, then time bombs | `--org` `--repo` `--include-team` |

### `/standup` output

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

### `/team-pulse` output

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

### `/risk-radar` output

```
RISK RADAR - 2026-06-26 - RedHatAI
===============================================
Summary: 2 HIGH, 3 MEDIUM, 4 LOW

HIGH SEVERITY
  [PROCESS] RedHatAI/llm-d: PR "KV cache eviction policy" open 12d with no review
  [SECURITY] RedHatAI/vllm: 2 critical dependency alerts (torch: arbitrary code execution)
```

## Shell aliases

The installer can add these aliases to your `.zshrc` or `.bashrc`. They run from any terminal, no active Claude Code session needed.

| Alias | Runs | Notes |
|---|---|---|
| `morning` | `/briefing` | Full morning briefing |
| `standup` | `/standup` | Standup prep |
| `weekly` | `/weekly-digest` | End-of-week summary |
| `pulse` | `/team-pulse` | Team health check |
| `catchmeup` | `/catch-me-up` | Return-from-absence briefing |
| `riskradar` | `/risk-radar` | Risk and warning scanner |
| `weekahead` | `/week-ahead` | Forward-looking planner |
| `prs` | `gh search prs` | PRs needing your review |
| `greview` | `gh` + `fzf` | Interactive PR picker (requires fzf) |
| `prs-stale` | `gh search prs` | PRs open >7 days |
| `myissues` | `gh search issues` | Your assigned issues |

## Prerequisites

- **Claude Code CLI** - [install guide](https://docs.anthropic.com/en/docs/claude-code) (must be authenticated)
- **GitHub CLI (`gh`)** - [install guide](https://cli.github.com/) (must be authenticated)
- **fzf** - [install guide](https://github.com/junegunn/fzf) (optional, enables `greview` interactive picker)

## Install

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-daily-briefing.git
cd ai-bu-daily-briefing
bash install.sh
```

The installer checks prerequisites, copies all seven commands to `~/.claude/commands/`, and optionally adds shell aliases to your `.zshrc` or `.bashrc`. It detects existing commands and only updates changed ones.

### Manual install

```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Add to your shell rc file:
source /path/to/ai-bu-daily-briefing/shell/briefing-aliases.sh
```

## Customization

**Filtering by org or repo.** All commands accept `--org` to limit results to one GitHub organization or `--repo` to focus on a single repository.

**Stale thresholds.** PRs open >7 days are flagged as STALE. Issues open >14 days are flagged as OLD. These thresholds are defined in each command file and can be edited to match your team's norms.

**Adding new commands.** Command files are plain Markdown with structured prompts for Claude. See `reference/briefing-format.md` for formatting conventions. Add a new `.md` file to `commands/`, update the `COMMANDS` array in `install.sh`, and re-run the installer.

## How it works

Each command is a Markdown file with a structured prompt that tells Claude to:
1. Run `gh` CLI commands to pull live data from the GitHub API
2. Cross-reference and prioritize by urgency, not recency
3. Format into a consistent, scannable briefing

Nothing stored locally. Everything fetched live on each run. No API keys beyond what `gh` and `claude` already have.

## License

MIT
