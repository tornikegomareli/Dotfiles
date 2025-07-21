#!/bin/bash

# Weather plugin with multiple data sources and caching
CACHE_FILE="/tmp/sketchybar_weather_cache.json"
CACHE_DURATION=600 # 10 minutes in seconds
LOCATION="Tbilisi,GE" # Your location

# Function to check if cache is valid
is_cache_valid() {
  if [[ -f "$CACHE_FILE" ]]; then
    local cache_time=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)
    local current_time=$(date +%s)
    local age=$((current_time - cache_time))
    
    if [[ $age -lt $CACHE_DURATION ]]; then
      return 0
    fi
  fi
  return 1
}

# Function to get weather from wttr.in with better format
get_weather_wttr() {
  local weather_data=$(curl -s "wttr.in/${LOCATION}?format=j1" --connect-timeout 5 2>/dev/null)
  
  if [[ -n "$weather_data" ]]; then
    # Extract more detailed information
    local temp=$(echo "$weather_data" | jq -r '.current_condition[0].temp_C' 2>/dev/null)
    local feels_like=$(echo "$weather_data" | jq -r '.current_condition[0].FeelsLikeC' 2>/dev/null)
    local humidity=$(echo "$weather_data" | jq -r '.current_condition[0].humidity' 2>/dev/null)
    local condition=$(echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value' 2>/dev/null)
    local wind_speed=$(echo "$weather_data" | jq -r '.current_condition[0].windspeedKmph' 2>/dev/null)
    
    # Save to cache
    echo "$weather_data" > "$CACHE_FILE"
    
    # Return formatted data
    echo "{\"temp\":\"$temp\",\"feels_like\":\"$feels_like\",\"humidity\":\"$humidity\",\"condition\":\"$condition\",\"wind\":\"$wind_speed\"}"
    return 0
  fi
  return 1
}

# Function to get weather icon with more conditions
get_weather_icon() {
  local condition="$1"
  local hour=$(date +%H)
  local is_day=true
  
  if [[ $hour -lt 6 ]] || [[ $hour -gt 20 ]]; then
    is_day=false
  fi
  
  # Convert condition to lowercase for matching
  condition=$(echo "$condition" | tr '[:upper:]' '[:lower:]')
  
  # More detailed condition matching
  case "$condition" in
    *"clear"* | *"sunny"*)
      if $is_day; then echo "☀️"; else echo "🌙"; fi ;;
    *"partly cloudy"*)
      if $is_day; then echo "⛅"; else echo "☁️"; fi ;;
    *"cloudy"* | *"overcast"*)
      echo "☁️" ;;
    *"light rain"* | *"drizzle"* | *"patchy rain"*)
      echo "🌦️" ;;
    *"moderate rain"* | *"rain"*)
      echo "🌧️" ;;
    *"heavy rain"* | *"torrential"*)
      echo "⛈️" ;;
    *"thunder"* | *"storm"*)
      echo "🌩️" ;;
    *"snow"* | *"sleet"*)
      echo "❄️" ;;
    *"fog"* | *"mist"* | *"haze"*)
      echo "🌫️" ;;
    *"wind"* | *"breezy"*)
      echo "💨" ;;
    *)
      echo "🌡️" ;;
  esac
}

# Main execution
main() {
  local weather_json=""
  
  # Check cache first
  if is_cache_valid; then
    local cached_data=$(cat "$CACHE_FILE" 2>/dev/null)
    if [[ -n "$cached_data" ]]; then
      # Parse cached data
      local temp=$(echo "$cached_data" | jq -r '.current_condition[0].temp_C' 2>/dev/null)
      local condition=$(echo "$cached_data" | jq -r '.current_condition[0].weatherDesc[0].value' 2>/dev/null)
      
      if [[ -n "$temp" ]] && [[ -n "$condition" ]]; then
        weather_json="{\"temp\":\"$temp\",\"condition\":\"$condition\"}"
      fi
    fi
  fi
  
  # If no valid cache, fetch new data
  if [[ -z "$weather_json" ]]; then
    weather_json=$(get_weather_wttr)
  fi
  
  # Parse the weather data
  if [[ -n "$weather_json" ]] && [[ "$weather_json" != "null" ]]; then
    local temp=$(echo "$weather_json" | jq -r '.temp' 2>/dev/null)
    local condition=$(echo "$weather_json" | jq -r '.condition' 2>/dev/null)
    
    if [[ -n "$temp" ]] && [[ "$temp" != "null" ]]; then
      local icon=$(get_weather_icon "$condition")
      sketchybar --set weather label="${icon} ${temp}°C"
    else
      sketchybar --set weather label="🌡️ --°C"
    fi
  else
    # If all fails, show error state
    sketchybar --set weather label="🌡️ --°C"
  fi
}

# Run main function
main