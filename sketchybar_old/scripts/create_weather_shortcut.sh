#!/bin/bash

# This script helps create an Apple Shortcut for weather data
echo "Creating Apple Weather Shortcut..."

# Create the shortcut using shortcuts CLI
shortcuts create "Get Current Weather" <<EOF
# This creates a basic weather shortcut structure
# You'll need to manually configure it in Shortcuts app to:
# 1. Get current location
# 2. Get weather at location
# 3. Format output as: temperature°C condition
# 4. Return the formatted text
EOF

echo "
To use Apple Weather data:

1. Open the Shortcuts app
2. Find 'Get Current Weather' shortcut
3. Edit it to add these actions:
   - Get Current Location
   - Get Current Weather at [Location]
   - Get [Temperature] from [Weather Conditions]
   - Get [Condition] from [Weather Conditions]  
   - Text: [Temperature]°C [Condition]
   - Stop and Output [Text]

4. Save the shortcut

5. Update weather plugin to use:
   weather=\$(shortcuts run 'Get Current Weather' 2>/dev/null)

The weather plugin will automatically use this if available.
"