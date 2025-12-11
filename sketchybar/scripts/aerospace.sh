#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Get the currently focused workspace from aerospace
CURRENT=$(aerospace list-workspaces --focused)

# Update all workspace indicators
for sid in 1 2 3 4 5 6 7; do
  if [ "$sid" = "$CURRENT" ]; then
    sketchybar --set space.$sid background.drawing=on \
                                background.color=$ITEM_BG_COLOR \
                                background.corner_radius=5 \
                                icon.color=$WHITE
  else
    sketchybar --set space.$sid background.drawing=off \
                                icon.color=$ACCENT_COLOR
  fi
done
