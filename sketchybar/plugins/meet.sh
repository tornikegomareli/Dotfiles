#!/usr/bin/env bash

# Colors for mute states
unmuted_color="0xff8bcd5b"  # Green
muted_color="0xff992525"    # Red

# State file to track mute status
STATE_FILE="/tmp/sketchybar_meet_muted"

# Check if Google Meet is running in any browser
BROWSER_LIST="Google Chrome,Safari,Arc,Firefox,Microsoft Edge,Dia"
IFS=',' read -ra BROWSERS <<< "$BROWSER_LIST"

MEET_ACTIVE=false
for browser in "${BROWSERS[@]}"; do
  if osascript -e "tell application \"System Events\" to (name of processes) contains \"${browser}\"" | grep -q "true"; then
    if [ "$browser" = "Dia" ]; then
      # For Dia, check if the window title contains "Meet"
      if osascript -e "tell application \"System Events\" to tell process \"Dia\" to get title of front window" 2>/dev/null | grep -qi "meet"; then
        MEET_ACTIVE=true
        break
      fi
    else
      # For other browsers, check URL
      if osascript -e "tell application \"${browser}\" to get URL of active tab of front window" 2>/dev/null | grep -q "meet.google.com"; then
        MEET_ACTIVE=true
        break
      fi
    fi
  fi
done

if [ "$MEET_ACTIVE" = true ]; then
  # Check mute state from our state file
  if [ -f "$STATE_FILE" ]; then
    icon="󰍭"  # Muted mic
    color="$muted_color"
  else
    icon="󰍬"  # Active mic
    color="$unmuted_color"
  fi
  sketchybar --set $NAME icon="$icon" icon.color="$color" label="" background.color="0xcc000000"
else
  # Hide the icon and background when not in a meeting
  sketchybar --set $NAME icon="" label="" background.color="0x00000000"
  # Clean up state file when not in meeting
  rm -f "$STATE_FILE"
fi