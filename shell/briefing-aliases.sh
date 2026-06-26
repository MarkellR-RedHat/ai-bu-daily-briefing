#!/usr/bin/env bash
# ai-bu-daily-briefing shell aliases and functions
# Source this file from your .zshrc or .bashrc

# Full morning briefing via Claude Code
# Usage: morning [--org OrgName] [--repo repo-name]
morning() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/briefing $*"
}

# Quick standup prep via Claude Code
# Usage: standup [--org OrgName] [--repo repo-name]
standup() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/standup $*"
}

# Weekly digest via Claude Code
# Usage: weekly [--org OrgName] [--repo repo-name]
weekly() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/weekly-digest $*"
}

# Team pulse via Claude Code
# Usage: pulse --org OrgName [--days 7]
pulse() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/team-pulse $*"
}

# Catch-me-up briefing via Claude Code
# Usage: catchmeup <days> [--org OrgName]
catchmeup() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/catch-me-up $*"
}

# Risk radar scan via Claude Code
# Usage: riskradar [--org OrgName] [--repo repo-name] [--days 14]
riskradar() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/risk-radar $*"
}

# Week ahead planning via Claude Code
# Usage: weekahead [--org OrgName] [--repo repo-name]
weekahead() {
  if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found. Install Claude Code first."
    return 1
  fi
  claude "/week-ahead $*"
}

# Quick list of PRs needing your review
# Usage: prs [org-name]
prs() {
  if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI not found. Install GitHub CLI first."
    return 1
  fi

  local owner_flag=""
  if [ -n "$1" ]; then
    owner_flag="--owner=$1"
  fi

  echo "PRs requesting your review:"
  echo "============================"
  gh search prs --review-requested=@me --state=open $owner_flag \
    --json repository,title,url,updatedAt \
    --template '{{range .}}{{.repository.nameWithOwner}} | {{.title}}
  {{.url}}
{{end}}'

  if [ $? -ne 0 ]; then
    echo "Failed to fetch PRs. Check your gh auth status."
    return 1
  fi
}

# Interactive PR review picker (requires fzf)
# Usage: greview [org-name]
greview() {
  if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI not found. Install GitHub CLI first."
    return 1
  fi
  if ! command -v fzf &> /dev/null; then
    echo "Error: fzf not found. Install fzf first: brew install fzf"
    return 1
  fi

  local owner_flag=""
  if [ -n "$1" ]; then
    owner_flag="--owner=$1"
  fi

  local selected
  selected=$(gh search prs --review-requested=@me --state=open $owner_flag \
    --json repository,title,url,number \
    --jq '.[] | "\(.repository.nameWithOwner) #\(.number) \(.title)\t\(.url)"' \
    | fzf --delimiter='\t' --with-nth=1 --preview-window=hidden \
           --header="Select a PR to review (enter to open)")

  if [ -n "$selected" ]; then
    local url
    url=$(echo "$selected" | awk -F'\t' '{print $2}')
    echo "Opening: $url"
    open "$url" 2>/dev/null || xdg-open "$url" 2>/dev/null || echo "$url"
  fi
}

# Show PRs older than 7 days
# Usage: prs-stale [org-name]
prs-stale() {
  if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI not found. Install GitHub CLI first."
    return 1
  fi

  local owner_flag=""
  if [ -n "$1" ]; then
    owner_flag="--owner=$1"
  fi

  local cutoff
  cutoff=$(date -v-7d +%Y-%m-%dT00:00:00Z 2>/dev/null || date -d '7 days ago' +%Y-%m-%dT00:00:00Z)

  echo "Stale PRs (open >7 days, requesting your review):"
  echo "==================================================="
  gh search prs --review-requested=@me --state=open $owner_flag \
    --created="<$cutoff" \
    --json repository,title,url,createdAt \
    --template '{{range .}}{{.repository.nameWithOwner}} | {{.title}} (created {{.createdAt}})
  {{.url}}
{{end}}'
}

# List your assigned issues across repos
# Usage: myissues [org-name]
myissues() {
  if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI not found. Install GitHub CLI first."
    return 1
  fi

  local owner_flag=""
  if [ -n "$1" ]; then
    owner_flag="--owner=$1"
  fi

  echo "Issues assigned to you:"
  echo "========================"
  gh search issues --assignee=@me --state=open $owner_flag \
    --json repository,title,url,labels,updatedAt \
    --template '{{range .}}{{.repository.nameWithOwner}} | {{.title}}{{range .labels}} [{{.name}}]{{end}}
  {{.url}}
{{end}}'

  if [ $? -ne 0 ]; then
    echo "Failed to fetch issues. Check your gh auth status."
    return 1
  fi
}
