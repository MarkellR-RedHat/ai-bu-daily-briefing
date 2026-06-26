# ai-bu-daily-briefing

A daily briefing tool that gives you a standup-ready summary of your GitHub activity in one terminal screen. Pulls together open PRs, review requests, assigned issues, team activity, and stale item alerts. Saves you ~10 minutes every morning by replacing the tab-switching ritual of checking GitHub notifications, PR queues, and issue boards.

Works as Claude Code slash commands and standalone shell aliases.

## What It Looks Like

```
DAILY BRIEFING - 2026-06-26
================================

NOTIFICATIONS (3 unread)
- review_requested: Add batch inference endpoint (RedHatAI/llm-d)
- mention: Tracking issue for v0.5 release (RedHatAI/llm-d)

REVIEW REQUESTS (2)
- RedHatAI/llm-d: Fix memory leak in scheduler (2d old)
  https://github.com/RedHatAI/llm-d/pull/142
- RedHatAI/vllm: Update tokenizer config (12d old) STALE
  https://github.com/RedHatAI/vllm/pull/87

MY OPEN PRs (1)
- RedHatAI/llm-d: Add graceful shutdown handler APPROVED
  https://github.com/RedHatAI/llm-d/pull/138

ASSIGNED ISSUES (2)
- RedHatAI/llm-d: Benchmark throughput on A100 cluster
  https://github.com/RedHatAI/llm-d/issues/95
- RedHatAI/llm-d: Write runbook for scaling prefill pods URGENT
  https://github.com/RedHatAI/llm-d/issues/101

TEAM ACTIVITY (last 24h)
- RedHatAI/llm-d: 4 PRs merged
- RedHatAI/vllm: 1 PR merged
```

## What You Get

### Claude Code Commands

- **`/briefing`** - Full daily briefing: notifications, review requests, your open PRs, assigned issues, team activity.
- **`/standup`** - Quick standup prep: yesterday, today, blockers. Three sections, bullets only.
- **`/weekly-digest`** - Week-in-review: what you shipped, what you reviewed, what is still open.
- **`/team-pulse`** - Org-wide activity check: active repos, contributor stats, aging PRs. Built for leads.

### Shell Aliases

- **`morning`** - Full briefing via Claude Code.
- **`standup`** - Standup prep via Claude Code.
- **`weekly`** - Weekly digest via Claude Code.
- **`pulse`** - Team pulse via Claude Code.
- **`prs`** - Quick list of PRs needing your review (uses `gh` directly).
- **`greview`** - Interactive PR review picker with fzf (uses `gh` + `fzf`).
- **`prs-stale`** - PRs open longer than 7 days requesting your review (uses `gh` directly).
- **`myissues`** - Your assigned issues across repos (uses `gh` directly).

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
2. Copy all Claude Code commands to `~/.claude/commands/`.
3. Detect existing aliases to avoid duplicates.
4. Optionally add shell aliases to your `.zshrc` or `.bashrc`.

### Manual Installation

```bash
# Copy commands
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Source aliases (add to your shell rc file)
source /path/to/ai-bu-daily-briefing/shell/briefing-aliases.sh
```

## Usage

### Claude Code Commands

Start Claude Code and run:

```
/briefing
/briefing --org RedHatAI
/briefing --repo my-project

/standup
/standup --org RedHatAI

/weekly-digest
/weekly-digest --org RedHatAI

/team-pulse --org RedHatAI
/team-pulse --org RedHatAI --days 14
```

### Shell Aliases

```bash
morning                  # Full briefing
morning --org RedHatAI   # Scoped to an org

standup                  # Standup prep

weekly                   # Week-in-review
weekly --org RedHatAI    # Scoped to an org

pulse --org RedHatAI     # Team activity check

prs                      # PRs needing your review
prs RedHatAI             # Scoped to an org

greview                  # Interactive PR picker (opens in browser)
greview RedHatAI         # Scoped to an org

prs-stale                # PRs open >7 days
prs-stale RedHatAI       # Scoped to an org

myissues                 # Your assigned issues
myissues RedHatAI        # Scoped to an org
```

## Customization

### Filtering by Org or Repo

All commands accept `--org` to limit results to one GitHub organization or `--repo` to focus on a single repository.

### Stale PR Threshold

The briefing flags PRs open for more than 7 days. To change this, edit `commands/briefing.md` and update the day count.

### Adding New Sections

Command files are plain Markdown with instructions for Claude. Add sections by describing the `gh` command to run, what to extract, and how to format the output.

## How It Works

Claude Code commands use `gh` CLI calls to pull data from the GitHub API. Claude processes the raw output and formats it into a readable briefing. Shell aliases are thin wrappers that invoke Claude Code or `gh` directly.

No data is stored locally. Everything is fetched live from GitHub.

## License

MIT
