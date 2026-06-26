#!/usr/bin/env bash
# ai-bu-daily-briefing installer
# Copies Claude Code commands and optionally sets up shell aliases.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="$HOME/.claude/commands"
ALIASES_FILE="$SCRIPT_DIR/shell/briefing-aliases.sh"
SOURCE_LINE="source \"$SCRIPT_DIR/shell/briefing-aliases.sh\""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}ai-bu-daily-briefing${NC}"
echo ""

# ── Prerequisites ──────────────────────────────────────

missing=0

if command -v claude &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} claude"
else
  echo -e "  ${RED}✗${NC} claude ${DIM}(install Claude Code first)${NC}"
  missing=1
fi

if command -v gh &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} gh"
else
  echo -e "  ${RED}✗${NC} gh ${DIM}(install GitHub CLI first)${NC}"
  missing=1
fi

if command -v fzf &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} fzf"
else
  echo -e "  ${YELLOW}~${NC} fzf ${DIM}(optional, brew install fzf)${NC}"
fi

echo ""

if [ "$missing" -eq 1 ]; then
  echo -e "  ${RED}Missing required tools. Install them and re-run.${NC}"
  echo ""
  exit 1
fi

# ── Install commands ───────────────────────────────────

mkdir -p "$CLAUDE_CMD_DIR"

COMMANDS=(briefing standup weekly-digest team-pulse catch-me-up risk-radar week-ahead)
installed=0
updated=0
skipped=0

for cmd in "${COMMANDS[@]}"; do
  if [ -f "$CLAUDE_CMD_DIR/$cmd.md" ]; then
    if cmp -s "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"; then
      skipped=$((skipped + 1))
    else
      cp "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"
      updated=$((updated + 1))
    fi
  else
    cp "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"
    installed=$((installed + 1))
  fi
done

total=$((installed + updated))
if [ "$total" -gt 0 ]; then
  echo -e "  ${GREEN}✓${NC} ${total} commands installed"
fi
if [ "$skipped" -gt 0 ]; then
  echo -e "  ${DIM}  ${skipped} already up to date${NC}"
fi

echo ""

# ── Shell aliases ──────────────────────────────────────

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

read -p "  Add shell aliases? (y/n) " -n 1 -r
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
    echo -e "  ${DIM}Add this to your shell config:${NC}"
    echo "    source $ALIASES_FILE"
  fi
fi

echo ""
echo -e "  ${BOLD}Ready.${NC} Try ${GREEN}/briefing${NC} in Claude Code."
echo ""
