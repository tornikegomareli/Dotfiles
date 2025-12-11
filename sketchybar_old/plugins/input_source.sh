#!/bin/bash

# Get current input source
get_input_source() {
  # Use defaults to read the current input source
  defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | \
    grep -E '"(Input Mode|KeyboardLayout Name)"' | \
    head -1 | \
    sed -E 's/.*"(Input Mode|KeyboardLayout Name)" = "?([^";]+)"?;.*/\2/'
}

# Get the current input source
CURRENT_SOURCE=$(get_input_source)

# Set flag based on input source
case "$CURRENT_SOURCE" in
  *"Georgian"*|*"georgian"*|*"com.apple.keylayout.Georgian"*|*"კა"*)
    FLAG="🇬🇪"
    LABEL="KA"
    ;;
  *"English"*|*"english"*|*"U.S."*|*"ABC"*|*"com.apple.keylayout.US"*|*)
    FLAG="🇺🇸"
    LABEL="EN"
    ;;
esac

# Update sketchybar
sketchybar --set $NAME icon="$FLAG" label="$LABEL"