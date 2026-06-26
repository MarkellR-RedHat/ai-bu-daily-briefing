#!/usr/bin/env bash
# ai-bu-daily-briefing installer
# Copies Claude Code commands and optionally sets up shell aliases.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="$HOME/.claude/commands"
ALIASES_FILE="$SCRIPT_DIR/shell/briefing-aliases.sh"
SOURCE_LINE="source \"$SCRIPT_DIR/shell/briefing-aliases.sh\""

echo "ai-bu-daily-briefing installer"
echo "=============================="
echo ""

# Step 1: Install Claude Code commands
echo "Installing Claude Code commands..."
mkdir -p "$CLAUDE_CMD_DIR"

cp "$SCRIPT_DIR/commands/briefing.md" "$CLAUDE_CMD_DIR/briefing.md"
cp "$SCRIPT_DIR/commands/standup.md" "$CLAUDE_CMD_DIR/standup.md"

echo "  Installed /briefing command"
echo "  Installed /standup command"
echo ""

# Step 2: Shell aliases
echo "Shell aliases provide these shortcuts:"
echo "  morning   - full daily briefing via Claude Code"
echo "  standup   - quick standup prep via Claude Code"
echo "  prs       - list PRs needing your review"
echo "  myissues  - list your assigned issues"
echo ""

install_aliases() {
  local rc_file="$1"
  if grep -qF "briefing-aliases.sh" "$rc_file" 2>/dev/null; then
    echo "  Aliases already configured in $rc_file"
  else
    echo "" >> "$rc_file"
    echo "# ai-bu-daily-briefing aliases" >> "$rc_file"
    echo "$SOURCE_LINE" >> "$rc_file"
    echo "  Added aliases to $rc_file"
  fi
}

read -p "Install shell aliases? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Detect shell
  if [ -f "$HOME/.zshrc" ]; then
    install_aliases "$HOME/.zshrc"
  fi

  if [ -f "$HOME/.bashrc" ]; then
    install_aliases "$HOME/.bashrc"
  fi

  if [ ! -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.bashrc" ]; then
    echo "  No .zshrc or .bashrc found. You can source the aliases manually:"
    echo "  source $ALIASES_FILE"
  fi
fi

echo ""
echo "Done. To use the Claude Code commands, start claude and run:"
echo "  /briefing"
echo "  /standup"
echo ""
echo "If you installed shell aliases, restart your shell or run:"
echo "  source $ALIASES_FILE"
