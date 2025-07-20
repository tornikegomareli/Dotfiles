#!/bin/bash

# მიმდინარე თარიღის განსაზღვრა
current_date=$(date -u +"%Y-%m-%d")

# ამინდის მონაცემების მიღება API-დან (თბილისის კოორდინატები: 41.7151, 44.8271)
weather_data=$(curl -s "https://api.brightsky.dev/weather?lat=41.7151&lon=44.8271&date=${current_date}")

# მიმდინარე დროის განსაზღვრა UTC-ში
current_time=$(date -u +"%Y-%m-%dT%H:%M:%S%z")
current_minute=$(date -u +"%M")

# სწორი სრული საათის გამოთვლა მიმდინარე წუთის საფუძველზე
if [ "$current_minute" -le 30 ]; then
  correct_hour=$(date -u +"%Y-%m-%dT%H:00:00+00:00")
else
  correct_hour=$(date -u -r $(( $(date -u +%s) + 3600 )) +"%Y-%m-%dT%H:00:00+00:00")
fi

# მონაცემების ამოღება
temperature=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .temperature')
icon=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .icon')
condition=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .condition')
wind_speed=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .wind_speed')
cloud_cover=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .cloud_cover')
visibility=$(echo "$weather_data" | jq -r --arg correct_hour "$correct_hour" '
    .weather[] | select(.timestamp == $correct_hour) | .visibility')

# შედეგების გამოტანა ცალკეულ ხაზებზე
echo "სადგური: თბილისი, საქართველო"
echo "მდგომარეობა: ${condition}"
echo "ხატულა: ${icon}"
echo "ტემპერატურა: ${temperature}°C"
echo "ქარის სიჩქარე: ${wind_speed}"
echo "ღრუბლიანობა: ${cloud_cover}"
echo "ხილვადობა: ${visibility}"
