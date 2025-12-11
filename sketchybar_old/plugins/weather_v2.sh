#!/bin/bash

# Configuration
CITY="Tbilisi"
COUNTRY="GE"
CACHE_FILE="/tmp/sketchybar_weather.cache"
CACHE_DURATION=600  # 10 minutes

# Function to check cache age
is_cache_fresh() {
  if [[ -f "$CACHE_FILE" ]]; then
    local cache_age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    [[ $cache_age -lt $CACHE_DURATION ]]
  else
    return 1
  fi
}

# Get weather data with caching
get_weather() {
  # Check cache first
  if is_cache_fresh; then
    cat "$CACHE_FILE"
    return 0
  fi
  
  # Fetch new data - using multiple fallback sources
  local weather_data=""
  
  # Try wttr.in first (most reliable)
  weather_data=$(curl -s --connect-timeout 3 "wttr.in/${CITY}?format=%t+%C" 2>/dev/null)
  
  if [[ -z "$weather_data" ]]; then
    # Try alternative format
    weather_data=$(curl -s --connect-timeout 3 "wttr.in/${CITY}?format=3" 2>/dev/null | head -1)
  fi
  
  if [[ -n "$weather_data" ]]; then
    echo "$weather_data" > "$CACHE_FILE"
    echo "$weather_data"
    return 0
  fi
  
  return 1
}

# Get weather icon based on condition and time
get_icon() {
  local condition="$1"
  local hour=$(date +%H)
  
  # Convert to lowercase
  condition=$(echo "$condition" | tr '[:upper:]' '[:lower:]')
  
  # Day/night detection
  local is_night=false
  [[ $hour -lt 6 || $hour -gt 20 ]] && is_night=true
  
  # Icon selection with SF Symbols fallback
  case "$condition" in
    *clear*|*sunny*)
      if $is_night; then
        echo "🌙"  # or SF Symbol: 􀆹
      else
        echo "☀️"   # or SF Symbol: 􀆮
      fi
      ;;
    *partly*cloud*)
      if $is_night; then
        echo "☁️"   # or SF Symbol: 􀇂
      else
        echo "⛅"   # or SF Symbol: 􀇔
      fi
      ;;
    *cloud*|*overcast*)
      echo "☁️"     # or SF Symbol: 􀇂
      ;;
    *light*rain*|*drizzle*)
      echo "🌦️"     # or SF Symbol: 􀇖
      ;;
    *rain*)
      echo "🌧️"     # or SF Symbol: 􀇞
      ;;
    *thunder*|*storm*)
      echo "⛈️"     # or SF Symbol: 􀇟
      ;;
    *snow*)
      echo "❄️"     # or SF Symbol: 􀇥
      ;;
    *fog*|*mist*)
      echo "🌫️"     # or SF Symbol: 􀇊
      ;;
    *)
      echo "🌡️"     # or SF Symbol: 􀇬
      ;;
  esac
}

# Main logic
main() {
  local weather_info=$(get_weather)
  
  if [[ -z "$weather_info" ]]; then
    # Show last known data if available
    if [[ -f "$CACHE_FILE" ]]; then
      weather_info=$(cat "$CACHE_FILE")
    else
      sketchybar --set weather label="☁️ --°"
      exit 1
    fi
  fi
  
  # Parse temperature and condition
  # Handle different formats
  if [[ "$weather_info" =~ ([+-]?[0-9]+)°[CF] ]]; then
    local temp="${BASH_REMATCH[1]}"
    local condition="${weather_info#*°[CF]}"
    condition=$(echo "$condition" | xargs)  # Trim whitespace
  else
    # Fallback parsing
    local temp=$(echo "$weather_info" | grep -oE '[+-]?[0-9]+' | head -1)
    local condition=$(echo "$weather_info" | sed 's/[+-]*[0-9]*°*[CF]*//g' | xargs)
  fi
  
  # Get appropriate icon
  local icon=$(get_icon "$condition")
  
  # Format display
  if [[ -n "$temp" ]]; then
    sketchybar --set weather label="${icon} ${temp}°"
  else
    sketchybar --set weather label="${icon} ${weather_info}"
  fi
}

# Run main
main