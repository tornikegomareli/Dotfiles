#!/usr/bin/env sh

# Get the workspace number from the item name (space.1 -> 1)
WORKSPACE="${NAME#space.}"

# Get the currently focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color=0xffF19E38
else
  sketchybar --set $NAME label.color=0xff93a4c3
fi