#!/bin/sh

# Get current input source
INPUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed 's/.*= "\(.*\)";/\1/' | head -1)

# If empty, try alternative method
if [ -z "$INPUT" ]; then
  INPUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null | awk -F. '{print $NF}')
fi

# Map to flag emoji
case "$INPUT" in
  *Georgian*|*georgian*|*ka*|*Kartuli*)
    LABEL="🇬🇪 KA"
    ;;
  *US*|*ABC*|*English*|*en*|*USInternational*)
    LABEL="🇺🇸 EN"
    ;;
  *)
    LABEL="$INPUT"
    ;;
esac

sketchybar --set $NAME label="$LABEL"
