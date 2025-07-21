#!/bin/bash

source "$HOME/.config/sketchybar/scripts/utils.sh"

# First, update the count
CURRENT_USER=$(gh api user --jq .login 2>/dev/null)
ISSUE_COUNT=$(gh search issues --owner="$CURRENT_USER" --state=open --json number 2>/dev/null | jq 'length' || echo "0")

if [[ $ISSUE_COUNT -gt 0 ]]; then
  sketchybar --set github.issues label="󰠗 ${ISSUE_COUNT}" label.color="0xff00ff00"
else
  sketchybar --set github.issues label="󰠗 ${ISSUE_COUNT}" label.color="0xff93a4c3"
fi

# Toggle popup based on current state
POPUP_STATE=$(sketchybar --query github.issues | jq -r '.popup."drawing"')

if [[ "$POPUP_STATE" == "on" ]]; then
  # Hide popup
  sketchybar --set github.issues popup.drawing=off
else
  # Clear existing popup items
  sketchybar --remove '/github.issues.popup\..*/'
  
  # Get current user
  CURRENT_USER=$(gh api user --jq .login 2>/dev/null)
  
  # Get open issues from personal repos
  ISSUES=$(gh search issues --owner="$CURRENT_USER" --state=open --json title,url,repository,number --limit=10 2>/dev/null)
  
  if [[ -n "$ISSUES" ]] && [[ "$ISSUES" != "[]" ]]; then
    # Parse issues and create popup items
    echo "$ISSUES" | jq -r '.[] | @base64' | while read -r encoded_issue; do
      # Decode the issue data
      issue_data=$(echo "$encoded_issue" | base64 --decode)
      title=$(echo "$issue_data" | jq -r '.title')
      url=$(echo "$issue_data" | jq -r '.url')
      repo=$(echo "$issue_data" | jq -r '.repository.name')
      number=$(echo "$issue_data" | jq -r '.number')
      
      # Truncate title if too long
      if [[ ${#title} -gt 35 ]]; then
        title="${title:0:32}..."
      fi
      
      # Create unique item name
      item_name="github.issues.popup.$(echo "$url" | md5)"
      
      # Add popup item
      sketchybar --add item "$item_name" popup.github.issues \
        --set "$item_name" \
        label="$repo #$number: $title" \
        label.font="JetBrainsMono Nerd Font Mono:Regular:14.0" \
        click_script="open '$url'; sketchybar --set github.issues popup.drawing=off"
    done
  else
    # Show "No issues" message
    sketchybar --add item github.issues.popup.empty popup.github.issues \
      --set github.issues.popup.empty \
      label="No open issues" \
      label.font="JetBrainsMono Nerd Font Mono:Regular:14.0"
  fi
  
  # Show popup
  sketchybar --set github.issues popup.drawing=on
fi