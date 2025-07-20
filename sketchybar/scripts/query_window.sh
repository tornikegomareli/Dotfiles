#!/bin/sh

# Get focused window ID
focused_id=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null | head -1)

# Query aerospace for window info in current workspace
aerospace_output=$(aerospace list-windows --workspace focused --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null)

# Check if the output is empty
if [ -z "$aerospace_output" ]; then
  # Output is empty, print "empty" to indicate no windows
  echo "empty"
else
  # Process each window and add focus status
  echo "$aerospace_output" | while IFS='|' read -r id app title; do
    if [ "$id" = "$focused_id" ]; then
      echo "$id|$app|$title|true"
    else
      echo "$id|$app|$title|false"
    fi
  done
fi
