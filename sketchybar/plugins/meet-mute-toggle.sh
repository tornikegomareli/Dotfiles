#!/usr/bin/env bash

STATE_FILE="/tmp/sketchybar_meet_muted"

# Toggle the mute state
if [ -f "$STATE_FILE" ]; then
  rm "$STATE_FILE"
else
  touch "$STATE_FILE"
fi

# Google Meet uses Cmd+D to toggle microphone
osascript <<'END'
tell application "System Events"
  keystroke "d" using {command down}
end tell
END

# Force update the meet icon
sketchybar --trigger window_focus