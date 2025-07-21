#!/bin/bash

# Check if gh is installed and authenticated
if ! command -v gh &> /dev/null || ! gh auth status &>/dev/null; then
  sketchybar --set github.label label="git: not ready"
  exit 0
fi

# Count my open PRs
MY_OPEN_PRS=$(gh search prs --author="@me" --state=open --json number 2>/dev/null | jq 'length' || echo "0")

# Count review requests
REVIEW_REQUESTS=0
for repo in "Techzy/CocaColaLoyalty.iOS" "Techzy/SilkRewards-iOS" "urbansportsclub/one-app-ios" "urbansportsclub/bridge"; do
  COUNT=$(gh search prs --repo="$repo" --review-requested="@me" --state=open --json number 2>/dev/null | jq 'length' || echo "0")
  REVIEW_REQUESTS=$((REVIEW_REQUESTS + COUNT))
done

# Get current user
CURRENT_USER=$(gh api user --jq .login 2>/dev/null)

# Count issues on personal repos
PERSONAL_ISSUES=$(gh search issues --owner="$CURRENT_USER" --state=open --json number 2>/dev/null | jq 'length' || echo "0")

# Update each component
sketchybar --set github.label label="git:" label.color="0xff93a4c3"

# PR component
if [[ $MY_OPEN_PRS -gt 0 ]]; then
  sketchybar --set github.prs label="󰊢 ${MY_OPEN_PRS}" label.color="0xff00ff00"
else
  sketchybar --set github.prs label="󰊢 ${MY_OPEN_PRS}" label.color="0xff93a4c3"
fi

# Review component  
if [[ $REVIEW_REQUESTS -gt 0 ]]; then
  sketchybar --set github.reviews label="󰄬 ${REVIEW_REQUESTS}" label.color="0xffF19E38"
else
  sketchybar --set github.reviews label="󰄬 ${REVIEW_REQUESTS}" label.color="0xff93a4c3"
fi

# Issues component
if [[ $PERSONAL_ISSUES -gt 0 ]]; then
  sketchybar --set github.issues label="󰠗 ${PERSONAL_ISSUES}" label.color="0xff00ff00"
else
  sketchybar --set github.issues label="󰠗 ${PERSONAL_ISSUES}" label.color="0xff93a4c3"
fi