#!/bin/bash

# Function to get window context based on app
get_window_context() {
    local app_name="$1"
    local window_title="$2"
    local context=""
    
    case "$app_name" in
        "Safari")
            context=$(osascript <<EOF 2>/dev/null
tell application "Safari"
    if (count of windows) > 0 then
        set tabName to name of current tab of front window
        set tabURL to URL of current tab of front window
        return tabName & " - " & tabURL
    else
        return ""
    end if
end tell
EOF
)
            ;;
            
        "Google Chrome")
            context=$(osascript <<EOF 2>/dev/null
tell application "Google Chrome"
    if (count of windows) > 0 then
        set tabTitle to title of active tab of front window
        set tabURL to URL of active tab of front window
        return tabTitle & " - " & tabURL
    else
        return ""
    end if
end tell
EOF
)
            ;;
            
        "Firefox")
            # Firefox doesn't support AppleScript well, use window title
            context="$window_title"
            ;;
            
        "Finder")
            context=$(osascript <<EOF 2>/dev/null
tell application "Finder"
    if (count of windows) > 0 then
        try
            set currentPath to (POSIX path of (target of front window as alias))
            set windowName to name of front window
            return windowName & " - " & currentPath
        on error
            return name of front window
        end try
    else
        return "Desktop"
    end if
end tell
EOF
)
            ;;
            
        "Xcode")
            # Xcode window title usually contains the project and file name
            context="$window_title"
            ;;
            
        "Terminal")
            context=$(osascript <<EOF 2>/dev/null
tell application "Terminal"
    if (count of windows) > 0 then
        tell front window
            set currentTab to selected tab
            set tabTitle to custom title of currentTab
            return tabTitle
        end tell
    else
        return ""
    end if
end tell
EOF
)
            ;;
            
        "iTerm2")
            context=$(osascript <<EOF 2>/dev/null
tell application "iTerm"
    tell current window
        tell current session
            set sessionName to name
            return sessionName
        end tell
    end tell
end tell
EOF
)
            ;;
            
        "ghostty"|"Ghostty")
            # Ghostty shows pwd in window title by default
            context="$window_title"
            ;;
            
        "Code"|"Visual Studio Code")
            # VS Code shows file and project in window title
            context="$window_title"
            ;;
            
        "Slack")
            # Use window title which shows workspace and channel
            context="$window_title"
            ;;
            
        *)
            # Default: use window title
            context="$window_title"
            ;;
    esac
    
    # Return context or app name if context is empty
    if [[ -z "$context" || "$context" == "" ]]; then
        echo "$app_name"
    else
        echo "$context"
    fi
}

# Main execution
if [[ "$1" == "test" ]]; then
    # Test mode
    echo "Testing window context retrieval..."
    echo
    
    # Get current window info from aerospace
    WINDOW_INFO=$(aerospace list-windows --focused)
    APP_NAME=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $2}')
    WINDOW_TITLE=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $3}')
    
    echo "Current app: $APP_NAME"
    echo "Window title: $WINDOW_TITLE"
    echo "Context: $(get_window_context "$APP_NAME" "$WINDOW_TITLE")"
else
    # Production mode
    WINDOW_INFO=$(aerospace list-windows --focused)
    APP_NAME=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $2}')
    WINDOW_TITLE=$(echo "$WINDOW_INFO" | awk -F' \\| ' '{print $3}')
    
    CONTEXT=$(get_window_context "$APP_NAME" "$WINDOW_TITLE")
    
    # Truncate if too long
    if [[ ${#CONTEXT} -gt 50 ]]; then
        CONTEXT=$(echo "$CONTEXT" | cut -c 1-47)...
    fi
    
    echo "$CONTEXT"
fi