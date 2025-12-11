#!/usr/bin/env bash

# Get the number of CPU cores
CORE_COUNT=$(sysctl -n hw.ncpu)

# Get CPU usage for all processes and calculate average
cpu_usage="$(ps -axro pcpu | awk '{sum+=$1} END {print sum}')"

# Calculate average CPU usage per core
if command -v bc >/dev/null 2>&1; then
  # If bc is available, use it for decimal calculation
  average_by_core=$(echo "scale=1; ${cpu_usage}/${CORE_COUNT}" | bc)
else
  # Otherwise use integer division
  average_by_core=$((${cpu_usage%.*}/${CORE_COUNT}))
fi

# Update sketchybar
sketchybar --set cpu label="${average_by_core}%"