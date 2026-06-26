# ai-bu-daily-briefing

A daily briefing tool that gives you a morning standup-ready summary of your GitHub activity. It pulls together open PRs needing review, your assigned issues, recent team activity, and stale item alerts into a single, scannable output.

Works as both Claude Code slash commands and standalone shell aliases.

## What You Get

- **`/briefing`** - Full daily briefing: notifications, PRs to review, your open PRs, assigned issues, and recent team activity. Fits on one screen.
- **`/standup`** - Quick standup prep: what you did yesterday, what you're doing today, and blockers. Three sections, bullet points only.
- **`morning`** - Shell alias that runs the full briefing via Claude Code CLI.
- **`standup`** - Shell alias that runs standup prep via Claude Code CLI.
- **`prs`** - Quick list of PRs needing your review (no Claude needed, uses `gh` directly).
- **`myissues`** - Your assigned issues across repos (no Claude needed, uses `gh` directly).

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated
- A GitHub account with repos and activity to summarize

## Installation

Clone the repo and run the installer:

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-daily-briefing.git
cd ai-bu-daily-briefing
bash install.sh
```

The installer will:
1. Copy the Claude Code commands (`/briefing` and `/standup`) to `~/.claude/commands/`.
2. Optionally add shell aliases to your `.zshrc` or `.bashrc`.

### Manual Installation

If you prefer to install manually:

```bash
# Copy commands
mkdir -p ~/.claude/commands
cp commands/briefing.md ~/.claude/commands/
cp commands/standup.md ~/.claude/commands/

# Source aliases (add this line to your shell rc file)
source /path/to/ai-bu-daily-briefing/shell/briefing-aliases.sh
```

## Usage

### Claude Code Commands

Start Claude Code and run the slash commands:

```
/briefing
/briefing --org RedHatAI
/briefing --repo my-project
/briefing --verbose

/standup
/standup --org RedHatAI
```

### Shell Aliases

After installation, use these directly from your terminal:

```bash
# Full briefing
morning

# Briefing filtered to a specific org
morning --org RedHatAI

# Standup prep
standup

# Quick PR list
prs
prs RedHatAI

# Your assigned issues
myissues
myissues RedHatAI
```

## Customization

### Filtering by Org or Repo

Both commands accept optional filters via arguments. Pass `--org` to limit results to a specific GitHub organization, or `--repo` to focus on a single repository.

### Stale PR Threshold

The briefing command flags PRs open for more than 7 days as stale. To change this threshold, edit `commands/briefing.md` and update the day count in the "PRs Needing My Review" section.

### Adding New Sections

The command files are plain Markdown with instructions for Claude. You can add new sections by following the existing pattern: describe the `gh` CLI command to run, what to extract, and how to format the output.

## How It Works

The Claude Code commands use `gh` CLI calls to pull data from the GitHub API. Claude processes the raw output and formats it into a readable briefing. The shell aliases are thin wrappers that invoke Claude Code or `gh` directly for quick lookups.

No data is stored locally. Everything is fetched live from GitHub each time you run a command.

## License

MIT
