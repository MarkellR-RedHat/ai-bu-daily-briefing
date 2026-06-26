#!/usr/bin/env bash
#
# ai-bu-daily-briefing installer
#
# Copies Claude Code slash commands to ~/.claude/commands/
# and optionally sets up shell aliases.
#
# Usage: bash install.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="$HOME/.claude/commands"
ALIASES_FILE="$SCRIPT_DIR/shell/briefing-aliases.sh"
SOURCE_LINE="source \"$SCRIPT_DIR/shell/briefing-aliases.sh\""

# ── Colors ────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}ai-bu-daily-briefing installer${NC}"
echo ""

# ── Check prerequisites ──────────────────────────────

echo -e "${BOLD}Checking prerequisites...${NC}"
echo ""

missing=0

if command -v claude &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} claude CLI found"
else
  echo -e "  ${RED}✗${NC} claude CLI not found"
  echo -e "    ${DIM}Install: https://docs.anthropic.com/en/docs/claude-code${NC}"
  missing=1
fi

if command -v gh &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} gh CLI found"
else
  echo -e "  ${RED}✗${NC} gh CLI not found"
  echo -e "    ${DIM}Install: https://cli.github.com/${NC}"
  missing=1
fi

if command -v fzf &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} fzf found"
else
  echo -e "  ${YELLOW}~${NC} fzf not found ${DIM}(optional, enables greview interactive picker)${NC}"
  echo -e "    ${DIM}Install: brew install fzf${NC}"
fi

echo ""

if [ "$missing" -eq 1 ]; then
  echo -e "${RED}Missing required tools. Install them and re-run.${NC}"
  echo ""
  exit 1
fi

# ── Install commands ──────────────────────────────────

echo -e "${BOLD}Installing commands...${NC}"
echo ""

mkdir -p "$CLAUDE_CMD_DIR"

COMMANDS=(briefing standup weekly-digest team-pulse catch-me-up risk-radar week-ahead)
installed=0
updated=0
skipped=0

for cmd in "${COMMANDS[@]}"; do
  src="$SCRIPT_DIR/commands/$cmd.md"

  if [ ! -f "$src" ]; then
    echo -e "  ${RED}✗${NC} $cmd.md ${DIM}(source file missing, skipping)${NC}"
    continue
  fi

  if [ -f "$CLAUDE_CMD_DIR/$cmd.md" ]; then
    if cmp -s "$src" "$CLAUDE_CMD_DIR/$cmd.md"; then
      echo -e "  ${DIM}-${NC} ${DIM}/$cmd (already up to date)${NC}"
      skipped=$((skipped + 1))
    else
      cp "$src" "$CLAUDE_CMD_DIR/$cmd.md"
      echo -e "  ${GREEN}✓${NC} /$cmd ${DIM}(updated)${NC}"
      updated=$((updated + 1))
    fi
  else
    cp "$src" "$CLAUDE_CMD_DIR/$cmd.md"
    echo -e "  ${GREEN}✓${NC} /$cmd ${DIM}(installed)${NC}"
    installed=$((installed + 1))
  fi
done

echo ""
total=$((installed + updated + skipped))
echo -e "  ${total} commands processed: ${installed} new, ${updated} updated, ${skipped} unchanged"
echo ""

# ── Shell aliases ─────────────────────────────────────

install_aliases() {
  local rc_file="$1"
  local rc_name
  rc_name=$(basename "$rc_file")

  if grep -qF "briefing-aliases.sh" "$rc_file" 2>/dev/null; then
    echo -e "  ${DIM}Aliases already in ${rc_name}${NC}"
    return 0
  fi

  echo "" >> "$rc_file"
  echo "# ai-bu-daily-briefing aliases" >> "$rc_file"
  echo "$SOURCE_LINE" >> "$rc_file"
  echo -e "  ${GREEN}✓${NC} Added aliases to ${rc_name}"
}

read -p "Add shell aliases to your rc file? (y/n) " -n 1 -r
echo ""
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  alias_installed=false

  if [ -f "$HOME/.zshrc" ]; then
    install_aliases "$HOME/.zshrc"
    alias_installed=true
  fi

  if [ -f "$HOME/.bashrc" ]; then
    install_aliases "$HOME/.bashrc"
    alias_installed=true
  fi

  if [ "$alias_installed" = false ]; then
    echo -e "  ${YELLOW}No .zshrc or .bashrc found.${NC}"
    echo -e "  Add this line to your shell config manually:"
    echo ""
    echo "    source $ALIASES_FILE"
  fi

  echo ""
fi

# ── Done ──────────────────────────────────────────────

echo -e "${BOLD}Ready.${NC}"
echo ""
echo -e "  Open Claude Code and try:  ${GREEN}/briefing${NC}"
echo ""
