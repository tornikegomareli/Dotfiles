#!/bin/bash

# Function to get location using CoreLocationCLI (if installed)
get_location() {
  if command -v CoreLocationCLI &> /dev/null; then
    local location=$(CoreLocationCLI -once -format "%address" 2>/dev/null | head -1)
    if [[ -n "$location" ]]; then
      # Extract city from address
      echo "$location" | awk -F', ' '{print $2}'
    else
      echo "Tbilisi" # Default fallback
    fi
  else
    echo "Tbilisi" # Default if CoreLocationCLI not installed
  fi
}

# Try to get weather using shortcuts (requires a shortcut named "Get Weather")
get_weather_from_shortcuts() {
  # Check if shortcuts CLI is available
  if command -v shortcuts &> /dev/null; then
    # Run the Get Weather shortcut
    weather_output=$(shortcuts run "Get Weather" 2>/dev/null)
    echo "$weather_output"
  fi
}

# Create Apple Weather shortcut if it doesn't exist
create_weather_shortcut() {
  osascript <<EOF 2>/dev/null
tell application "Shortcuts"
  -- Check if shortcut exists
  try
    set weatherShortcut to shortcut "Get Weather"
  on error
    -- Create new shortcut
    make new shortcut with properties {name:"Get Weather"}
    -- This would need manual setup in Shortcuts app
  end try
end tell
EOF
}

# Get weather using AppleScript and system events
get_weather_from_system() {
  # Try to get weather from notification center widget data
  osascript <<EOF 2>/dev/null
tell application "System Events"
  try
    -- This is a placeholder - actual implementation would need
    -- to access weather data through available APIs
    return "Unable to access Apple Weather"
  end try
end tell
EOF
}

# Fallback to OpenWeatherMap (free tier)
get_weather_openweather() {
  local API_KEY="YOUR_API_KEY_HERE" # You'll need to get a free API key
  local CITY=$(get_location)
  
  if [[ "$API_KEY" == "YOUR_API_KEY_HERE" ]]; then
    # Use wttr.in as fallback if no API key
    local WEATHER_DATA=$(curl -s "wttr.in/${CITY}?format=%t+%C" 2>/dev/null)
    echo "$WEATHER_DATA"
  else
    local WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=metric" 2>/dev/null)
    if [[ -n "$WEATHER_DATA" ]]; then
      local TEMP=$(echo "$WEATHER_DATA" | jq -r '.main.temp' | cut -d'.' -f1)
      local DESC=$(echo "$WEATHER_DATA" | jq -r '.weather[0].main')
      echo "${TEMP}°C ${DESC}"
    fi
  fi
}

# Main weather function
get_weather() {
  # Try shortcuts first
  local weather=$(get_weather_from_shortcuts)
  
  if [[ -z "$weather" ]] || [[ "$weather" == "Unable to access Apple Weather" ]]; then
    # Fallback to other methods
    weather=$(get_weather_openweather)
  fi
  
  echo "$weather"
}

# Parse weather and set icon
weather_info=$(get_weather)

if [[ -z "$weather_info" ]]; then
  sketchybar --set weather label="--"
  exit 0
fi

# Extract temperature (assumes format like "15°C Clear")
TEMP=$(echo "$weather_info" | grep -oE '[0-9]+°[CF]' | head -1)
CONDITION=$(echo "$weather_info" | sed 's/[0-9]*°[CF]//g' | xargs)

# Get current hour
HOUR=$(date +%H)

# Set weather icon based on condition
ICON="☁️" # default
case "$(echo $CONDITION | tr '[:upper:]' '[:lower:]')" in
  *clear* | *sunny*)
    if [ $HOUR -ge 6 ] && [ $HOUR -lt 20 ]; then
      ICON="☀️"
    else
      ICON="🌙"
    fi
    ;;
  *partly*cloud*)
    if [ $HOUR -ge 6 ] && [ $HOUR -lt 20 ]; then
      ICON="⛅"
    else
      ICON="☁️"
    fi
    ;;
  *cloud* | *overcast*) ICON="☁️" ;;
  *rain* | *drizzle*) ICON="🌧️" ;;
  *thunder* | *storm*) ICON="⛈️" ;;
  *snow*) ICON="❄️" ;;
  *fog* | *mist* | *haze*) ICON="🌫️" ;;
  *) ICON="🌡️" ;;
esac

# Update sketchybar
if [[ -n "$TEMP" ]]; then
  sketchybar --set weather label="${ICON} ${TEMP}"
else
  sketchybar --set weather label="${ICON} ${weather_info}"
fi