#!/bin/bash

# Source the icon extraction script
source /Users/tornikegomareli/.config/sketchybar/scripts/extract_app_icon.sh

# Get the focused window information from aerospace
WINDOW_INFO=$(aerospace list-windows --focused)
APP_NAME=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $2}')

# If empty, set a default
if [[ -z "$APP_NAME" || "$APP_NAME" = "" ]]; then
    APP_NAME="Desktop"
fi

# Try to get the icon PNG path
ICON_PATH=$(main "$APP_NAME")

# Debug output
echo "App: $APP_NAME"
echo "Icon path: $ICON_PATH"

if [[ -n "$ICON_PATH" && -f "$ICON_PATH" ]]; then
    # Try using the image as icon
    sketchybar --set $NAME \
        icon="$ICON_PATH" \
        icon.drawing=on \
        icon.scale=0.8 \
        label="$APP_NAME"
else
    # Fallback to text icon
    echo "Falling back to text icon"
    
    # Source the original icon function
    source /Users/tornikegomareli/.config/sketchybar/plugins/window_title.sh
    ICON=$(get_app_icon "$APP_NAME")
    
    sketchybar --set $NAME \
        icon="$ICON" \
        icon.drawing=on \
        label="$APP_NAME"
fi