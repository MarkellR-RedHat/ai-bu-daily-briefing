#!/usr/bin/env bash
# ai-bu-daily-briefing installer
# Copies Claude Code commands and optionally sets up shell aliases.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="$HOME/.claude/commands"
ALIASES_FILE="$SCRIPT_DIR/shell/briefing-aliases.sh"
SOURCE_LINE="source \"$SCRIPT_DIR/shell/briefing-aliases.sh\""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
  echo ""
  echo -e "${BOLD}${BLUE}ai-bu-daily-briefing installer${NC}"
  echo -e "${BLUE}==============================${NC}"
  echo ""
}

print_ok() {
  echo -e "  ${GREEN}[ok]${NC} $1"
}

print_skip() {
  echo -e "  ${YELLOW}[skip]${NC} $1"
}

print_err() {
  echo -e "  ${RED}[error]${NC} $1"
}

print_header

# Check prerequisites
echo -e "${BOLD}Checking prerequisites...${NC}"

if command -v claude &> /dev/null; then
  print_ok "claude CLI found"
else
  print_err "claude CLI not found - install Claude Code first"
fi

if command -v gh &> /dev/null; then
  print_ok "gh CLI found"
else
  print_err "gh CLI not found - install GitHub CLI first"
fi

if command -v fzf &> /dev/null; then
  print_ok "fzf found (enables interactive PR picker)"
else
  print_skip "fzf not found - greview command will not work (install: brew install fzf)"
fi
echo ""

# Step 1: Install Claude Code commands
echo -e "${BOLD}Installing Claude Code commands...${NC}"
mkdir -p "$CLAUDE_CMD_DIR"

COMMANDS=(briefing standup weekly-digest team-pulse catch-me-up risk-radar week-ahead)

for cmd in "${COMMANDS[@]}"; do
  if [ -f "$CLAUDE_CMD_DIR/$cmd.md" ]; then
    # Check if it is the same file
    if cmp -s "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"; then
      print_skip "/$cmd already installed (identical)"
    else
      cp "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"
      print_ok "/$cmd updated"
    fi
  else
    cp "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"
    print_ok "/$cmd installed"
  fi
done
echo ""

# Step 2: Shell aliases
echo -e "${BOLD}Shell aliases available:${NC}"
echo "  morning     - full daily briefing via Claude Code"
echo "  standup     - quick standup prep via Claude Code"
echo "  weekly      - week-in-review digest via Claude Code"
echo "  pulse       - team activity check via Claude Code"
echo "  catchmeup   - return-from-absence briefing via Claude Code"
echo "  riskradar   - risk and warning scan via Claude Code"
echo "  weekahead   - plan your upcoming week via Claude Code"
echo "  prs         - list PRs needing your review"
echo "  greview     - interactive PR review picker (fzf)"
echo "  prs-stale   - list PRs open longer than 7 days"
echo "  myissues    - list your assigned issues"
echo ""

install_aliases() {
  local rc_file="$1"
  local rc_name
  rc_name=$(basename "$rc_file")

  if grep -qF "briefing-aliases.sh" "$rc_file" 2>/dev/null; then
    print_skip "Aliases already configured in $rc_name"
    return 0
  fi

  echo "" >> "$rc_file"
  echo "# ai-bu-daily-briefing aliases" >> "$rc_file"
  echo "$SOURCE_LINE" >> "$rc_file"
  print_ok "Added aliases to $rc_name"
}

read -p "Install shell aliases? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  local_installed=false

  if [ -f "$HOME/.zshrc" ]; then
    install_aliases "$HOME/.zshrc"
    local_installed=true
  fi

  if [ -f "$HOME/.bashrc" ]; then
    install_aliases "$HOME/.bashrc"
    local_installed=true
  fi

  if [ "$local_installed" = false ]; then
    print_err "No .zshrc or .bashrc found. Source aliases manually:"
    echo "         source $ALIASES_FILE"
  fi
fi

echo ""
echo -e "${GREEN}${BOLD}Done.${NC} To get started:"
echo ""
echo "  Claude Code commands:"
echo "    /briefing        /standup         /weekly-digest"
echo "    /team-pulse      /catch-me-up     /risk-radar      /week-ahead"
echo ""
echo "  Shell aliases:"
echo "    morning  standup  weekly  pulse  catchmeup  riskradar  weekahead"
echo "    prs  greview  prs-stale  myissues"
echo ""
echo "  If you installed shell aliases, restart your shell or run:"
echo "    source $ALIASES_FILE"
