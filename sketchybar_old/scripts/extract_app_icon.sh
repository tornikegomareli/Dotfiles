#!/bin/bash

# Function to get app icon path from app name
get_app_icon_path() {
    local app_name="$1"
    
    # Try to get bundle identifier first
    local bundle_id=$(osascript -e "id of app \"$app_name\"" 2>/dev/null)
    
    if [[ -n "$bundle_id" ]]; then
        # Get app path from bundle identifier
        local app_path=$(osascript -e "POSIX path of (path to app id \"$bundle_id\")" 2>/dev/null)
    else
        # Try to find app path directly
        local app_path="/Applications/${app_name}.app"
        if [[ ! -d "$app_path" ]]; then
            # Try with spaces removed
            app_path="/Applications/${app_name// /}.app"
        fi
    fi
    
    if [[ -d "$app_path" ]]; then
        # Look for icon file in Resources
        local icon_path="${app_path}/Contents/Resources/AppIcon.icns"
        if [[ -f "$icon_path" ]]; then
            echo "$icon_path"
            return 0
        fi
        
        # Try other common icon names
        for icon_name in "icon.icns" "${app_name}.icns" "app.icns"; do
            icon_path="${app_path}/Contents/Resources/${icon_name}"
            if [[ -f "$icon_path" ]]; then
                echo "$icon_path"
                return 0
            fi
        done
        
        # Check Info.plist for icon file name
        local icon_file=$(defaults read "${app_path}/Contents/Info.plist" CFBundleIconFile 2>/dev/null | sed 's/.icns$//')
        if [[ -n "$icon_file" ]]; then
            icon_path="${app_path}/Contents/Resources/${icon_file}.icns"
            if [[ -f "$icon_path" ]]; then
                echo "$icon_path"
                return 0
            fi
        fi
    fi
    
    return 1
}

# Function to convert icns to png
convert_icns_to_png() {
    local icns_path="$1"
    local output_dir="$2"
    local app_name="$3"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Output PNG path
    local png_path="${output_dir}/${app_name}.png"
    
    # Use sips to convert icns to png (32x32 for menu bar)
    sips -s format png -z 32 32 "$icns_path" --out "$png_path" >/dev/null 2>&1
    
    if [[ -f "$png_path" ]]; then
        echo "$png_path"
        return 0
    fi
    
    return 1
}

# Main function
main() {
    local app_name="$1"
    local cache_dir="${HOME}/.config/sketchybar/icon_cache"
    
    # Check if we already have a cached icon
    local cached_icon="${cache_dir}/${app_name}.png"
    if [[ -f "$cached_icon" ]]; then
        echo "$cached_icon"
        return 0
    fi
    
    # Get icon path
    local icon_path=$(get_app_icon_path "$app_name")
    
    if [[ -n "$icon_path" ]]; then
        # Convert to PNG
        local png_path=$(convert_icns_to_png "$icon_path" "$cache_dir" "$app_name")
        if [[ -n "$png_path" ]]; then
            echo "$png_path"
            return 0
        fi
    fi
    
    return 1
}

# Test if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    app_name="${1:-Safari}"
    icon_path=$(main "$app_name")
    if [[ -n "$icon_path" ]]; then
        echo "Icon extracted to: $icon_path"
        # Show icon info
        file "$icon_path"
    else
        echo "Failed to extract icon for: $app_name"
    fi
fi