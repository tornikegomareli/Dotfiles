#!/bin/bash

echo "Testing different icon methods in sketchybar..."

# Method 1: Test app.<name> format
echo "Method 1: Testing app.<name> format"
sketchybar --add item test_icon1 right \
  --set test_icon1 \
  icon="app.Safari" \
  icon.drawing=on \
  label="Safari (app.name)"

sleep 1

# Method 2: Test with bundle ID
echo "Method 2: Testing app.<bundle-id> format"
sketchybar --add item test_icon2 right \
  --set test_icon2 \
  icon="app.com.apple.Safari" \
  icon.drawing=on \
  label="Safari (bundle)"

sleep 1

# Method 3: Test with PNG path
echo "Method 3: Testing PNG file path"
PNG_PATH="/Users/tornikegomareli/.config/sketchybar/icon_cache/Safari.png"
if [[ -f "$PNG_PATH" ]]; then
  sketchybar --add item test_icon3 right \
    --set test_icon3 \
    icon="$PNG_PATH" \
    icon.drawing=on \
    label="Safari (PNG)"
fi

sleep 1

# Method 4: Test background.image
echo "Method 4: Testing background.image"
if [[ -f "$PNG_PATH" ]]; then
  sketchybar --add item test_icon4 right \
    --set test_icon4 \
    background.image="$PNG_PATH" \
    background.image.drawing=on \
    background.image.scale=0.5 \
    label="Safari (bg.image)"
fi

sleep 1

# Method 5: Test icon.background.image
echo "Method 5: Testing icon.background.image"
if [[ -f "$PNG_PATH" ]]; then
  sketchybar --add item test_icon5 right \
    --set test_icon5 \
    icon.background.image="$PNG_PATH" \
    icon.background.image.drawing=on \
    icon.background.image.scale=0.5 \
    label="Safari (icon.bg)"
fi

echo "Tests complete. Check your sketchybar to see which methods work."
echo "To remove test items, run:"
echo "for i in {1..5}; do sketchybar --remove test_icon\$i; done"