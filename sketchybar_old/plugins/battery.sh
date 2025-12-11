#!/bin/bash

get_battery_info() {
  if command -v pmset &> /dev/null; then
    pmset -g batt | grep -E "([0-9]+)%" | awk '{gsub(";", "", $3); print $3}'
  else
    echo "0%"
  fi
}

get_charging_status() {
  if command -v pmset &> /dev/null; then
    pmset -g batt | grep -q "AC Power" && echo "charging" || echo "discharging"
  else
    echo "unknown"
  fi
}

PERCENTAGE=$(get_battery_info)
CHARGING=$(get_charging_status)

if [ -z "$PERCENTAGE" ]; then
  PERCENTAGE="0%"
fi

BATTERY_LEVEL=${PERCENTAGE%\%}

if [ "$CHARGING" = "charging" ]; then
  ICON="􀢋"
  COLOR=0xff00ff00  # Green when charging
elif [ "$BATTERY_LEVEL" -gt 75 ]; then
  ICON="􀛨"
  COLOR=0xff00ff00  # Green for 76-100%
elif [ "$BATTERY_LEVEL" -gt 50 ]; then
  ICON="􀺶"
  COLOR=0xffffff00  # Yellow for 51-75%
elif [ "$BATTERY_LEVEL" -gt 25 ]; then
  ICON="􀺵"
  COLOR=0xffff8c00  # Orange for 26-50%
elif [ "$BATTERY_LEVEL" -gt 10 ]; then
  ICON="􀛩"
  COLOR=0xffff4500  # Dark orange for 11-25%
else
  ICON="􀛪"
  COLOR=0xffff0000  # Red for 0-10%
fi

sketchybar --set $NAME icon="$ICON" icon.color=$COLOR label="${BATTERY_LEVEL}%"