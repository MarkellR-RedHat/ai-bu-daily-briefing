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
  echo "----------------------------"
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
  echo "------------------------"
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
