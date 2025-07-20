#!/bin/bash

# Get the focused window information from aerospace
WINDOW_INFO=$(aerospace list-windows --focused)

# Extract the app name (second field when split by " | ")
APP_NAME=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $2}')

# If still empty, set a default
if [[ -z "$APP_NAME" || "$APP_NAME" = "" ]]; then
  APP_NAME="Desktop"
fi

# Truncate if too long
if [[ ${#APP_NAME} -gt 50 ]]; then
  APP_NAME=$(echo "$APP_NAME" | cut -c 1-50)...
fi

sketchybar --set $NAME label="${APP_NAME}"
