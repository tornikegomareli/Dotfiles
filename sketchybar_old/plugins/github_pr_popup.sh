#!/bin/bash

source "$HOME/.config/sketchybar/scripts/utils.sh"

# First, update the count
PR_COUNT=$(gh search prs --author="@me" --state=open --json number 2>/dev/null | jq 'length' || echo "0")
if [[ $PR_COUNT -gt 0 ]]; then
  sketchybar --set github.prs label="󰊢 ${PR_COUNT}" label.color="0xff00ff00"
else
  sketchybar --set github.prs label="󰊢 ${PR_COUNT}" label.color="0xff93a4c3"
fi

# Toggle popup based on current state
POPUP_STATE=$(sketchybar --query github.prs | jq -r '.popup."drawing"')

if [[ "$POPUP_STATE" == "on" ]]; then
  # Hide popup
  sketchybar --set github.prs popup.drawing=off
else
  # Clear existing popup items
  sketchybar --remove '/github.prs.popup\..*/'
  
  # Get list of open PRs with details
  PR_LIST=$(gh search prs --author="@me" --state=open --json title,url,repository --limit=10 2>/dev/null)
  
  if [[ -n "$PR_LIST" ]] && [[ "$PR_LIST" != "[]" ]]; then
    # Parse PRs and create popup items
    echo "$PR_LIST" | jq -r '.[] | @base64' | while read -r encoded_pr; do
      # Decode the PR data
      pr_data=$(echo "$encoded_pr" | base64 --decode)
      title=$(echo "$pr_data" | jq -r '.title')
      url=$(echo "$pr_data" | jq -r '.url')
      repo=$(echo "$pr_data" | jq -r '.repository.name')
      
      # Truncate title if too long
      if [[ ${#title} -gt 40 ]]; then
        title="${title:0:37}..."
      fi
      
      # Create unique item name
      item_name="github.prs.popup.$(echo "$url" | md5)"
      
      # Add popup item
      sketchybar --add item "$item_name" popup.github.prs \
        --set "$item_name" \
        label="$repo: $title" \
        label.font="JetBrainsMono Nerd Font Mono:Regular:14.0" \
        click_script="open '$url'; sketchybar --set github.prs popup.drawing=off"
    done
  else
    # Show "No PRs" message
    sketchybar --add item github.prs.popup.empty popup.github.prs \
      --set github.prs.popup.empty \
      label="No open PRs" \
      label.font="JetBrainsMono Nerd Font Mono:Regular:14.0"
  fi
  
  # Show popup
  sketchybar --set github.prs popup.drawing=on
fi