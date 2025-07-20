#!/usr/bin/env bash

hour="$(date +%I)"
minute="$(date +%M)"

suffix=""

if [ "${minute}" -gt "30" ]; then
  suffix="-30"
fi

case "${hour}${suffix}" in
  "01")    icon="🕐" ;;
  "01-30") icon="🕜" ;;
  "02")    icon="🕑" ;;
  "02-30") icon="🕝" ;;
  "03")    icon="🕒" ;;
  "03-30") icon="🕞" ;;
  "04")    icon="🕓" ;;
  "04-30") icon="🕟" ;;
  "05")    icon="🕔" ;;
  "05-30") icon="🕠" ;;
  "06")    icon="🕕" ;;
  "06-30") icon="🕡" ;;
  "07")    icon="🕖" ;;
  "07-30") icon="🕢" ;;
  "08")    icon="🕗" ;;
  "08-30") icon="🕣" ;;
  "09")    icon="🕘" ;;
  "09-30") icon="🕤" ;;
  "10")    icon="🕙" ;;
  "10-30") icon="🕥" ;;
  "11")    icon="🕚" ;;
  "11-30") icon="🕦" ;;
  "12")    icon="🕛" ;;
  "12-30") icon="🕧" ;;
esac

sketchybar -m \
  --set time_logo icon="" \
  --set time label="$(date '+%A / %d %B / %H:%M')"