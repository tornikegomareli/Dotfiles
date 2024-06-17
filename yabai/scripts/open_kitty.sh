#!/usr/bin/env bash

# Detects if Kitty is running
if ! pgrep -f "kitty" >/dev/null 2>&1; then
	open -a "/Applications/kitty.app"
else
	# Send a signal to create a new window
	# Note: Kitty does not support AppleScript; it relies on the kitty remote control feature
	kitty @ new-window || {
		# Get pids for any app with "kitty" and kill
		while IFS="" read -r pid; do
			kill -15 "${pid}"
		done < <(pgrep -f "kitty")
		open -a "/Applications/kitty.app"
	}
fi
