#!/bin/bash

# Simple weather script using wttr.in
# You can change the location by modifying the URL
LOCATION="Tbilisi" # Change this to your city

# Get weather data
WEATHER_DATA=$(curl -s "wttr.in/${LOCATION}?format=j1" 2>/dev/null)

if [ -z "$WEATHER_DATA" ]; then
  sketchybar --set weather label="--"
  exit 0
fi

# Extract temperature and condition
TEMP_C=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].temp_C' 2>/dev/null)
CONDITION=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherDesc[0].value' 2>/dev/null)

# Get current hour
HOUR=$(date +%H)

# Set weather icon based on condition and time
ICON="☁️" # default
case "$CONDITION" in
*"Clear"* | *"Sunny"*)
  if [ $HOUR -ge 6 ] && [ $HOUR -lt 20 ]; then
    ICON="☀️"
  else
    ICON="🌑"
  fi
  ;;
*"Partly cloudy"*)
  if [ $HOUR -ge 6 ] && [ $HOUR -lt 20 ]; then
    ICON="⛅"
  else
    ICON="☁️"
  fi
  ;;
*"Cloudy"* | *"Overcast"*) ICON="☁️" ;;
*"Rain"* | *"rain"*) ICON="🌧️" ;;
*"Thunder"* | *"storm"*) ICON="⛈️" ;;
*"Snow"* | *"snow"*) ICON="❄️" ;;
*"Fog"* | *"fog"* | *"Mist"* | *"mist"*) ICON="🌫️" ;;
esac

# Update sketchybar
if [ ! -z "$TEMP_C" ]; then
  sketchybar --set weather label="${ICON} ${TEMP_C}°C"
else
  sketchybar --set weather label="--"
fi

