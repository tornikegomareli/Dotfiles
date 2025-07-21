#!/bin/bash

source "$HOME/.config/sketchybar/scripts/utils.sh"

# First, update the count
REVIEW_COUNT=0
for repo in "Techzy/CocaColaLoyalty.iOS" "Techzy/SilkRewards-iOS" "urbansportsclub/one-app-ios" "urbansportsclub/bridge"; do
  COUNT=$(gh search prs --repo="$repo" --review-requested="@me" --state=open --json number 2>/dev/null | jq 'length' || echo "0")
  REVIEW_COUNT=$((REVIEW_COUNT + COUNT))
done

if [[ $REVIEW_COUNT -gt 0 ]]; then
  sketchybar --set github.reviews label="󰄬 ${REVIEW_COUNT}" label.color="0xffF19E38"
else
  sketchybar --set github.reviews label="󰄬 ${REVIEW_COUNT}" label.color="0xff93a4c3"
fi

# Toggle popup based on current state
POPUP_STATE=$(sketchybar --query github.reviews | jq -r '.popup."drawing"')

if [[ "$POPUP_STATE" == "on" ]]; then
  # Hide popup
  sketchybar --set github.reviews popup.drawing=off
else
  # Clear existing popup items
  sketchybar --remove '/github.reviews.popup\..*/'
  
  # Get review requests from all monitored repos
  REPOS=("Techzy/CocaColaLoyalty.iOS" "Techzy/SilkRewards-iOS" "urbansportsclub/one-app-ios" "urbansportsclub/bridge")
  has_reviews=false
  
  for repo in "${REPOS[@]}"; do
    REVIEWS=$(gh search prs --repo="$repo" --review-requested="@me" --state=open --json title,url,number --limit=5 2>/dev/null)
    
    if [[ -n "$REVIEWS" ]] && [[ "$REVIEWS" != "[]" ]]; then
      has_reviews=true
      echo "$REVIEWS" | jq -r '.[] | @base64' | while read -r encoded_pr; do
        # Decode the PR data
        pr_data=$(echo "$encoded_pr" | base64 --decode)
        title=$(echo "$pr_data" | jq -r '.title')
        url=$(echo "$pr_data" | jq -r '.url')
        number=$(echo "$pr_data" | jq -r '.number')
        
        # Extract repo name from repo variable
        repo_name=$(echo "$repo" | cut -d'/' -f2)
        
        # Truncate title if too long
        if [[ ${#title} -gt 35 ]]; then
          title="${title:0:32}..."
        fi
        
        # Create unique item name
        item_name="github.reviews.popup.$(echo "${repo}_${number}" | md5)"
        
        # Add popup item
        sketchybar --add item "$item_name" popup.github.reviews \
          --set "$item_name" \
          label="$repo_name #$number: $title" \
          label.font="JetBrainsMono Nerd Font Mono:Regular:14.0" \
          click_script="open '$url'; sketchybar --set github.reviews popup.drawing=off"
      done
    fi
  done
  
  if [[ "$has_reviews" == "false" ]]; then
    # Show "No reviews" message
    sketchybar --add item github.reviews.popup.empty popup.github.reviews \
      --set github.reviews.popup.empty \
      label="No pending reviews" \
      label.font="JetBrainsMono Nerd Font Mono:Regular:14.0"
  fi
  
  # Show popup
  sketchybar --set github.reviews popup.drawing=on
fi