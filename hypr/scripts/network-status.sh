#!/bin/sh

status="$(nmcli general status | grep -oh "\w*connect\w*")"
icon="󰈀" # default value

if [[ "$status" == "disconnected" ]]; then
  icon="󰤮"
elif [[ "$status" == "connecting" ]]; then
  icon="󱍸"
elif [[ "$status" == "connected" ]]; then
  strength="$(nmcli -f IN-USE,SIGNAL device wifi | grep '*' | awk '{print $2}')"
  if [[ "$?" == "0" ]]; then
    if [[ "$strength" -eq "0" ]]; then
      icon="󰤯"
    elif [[ ("$strength" -ge "0") && ("$strength" -le "25") ]]; then
      icon="󰤟"
    elif [[ ("$strength" -ge "25") && ("$strength" -le "50") ]]; then
      icon="󰤢"
    elif [[ ("$strength" -ge "50") && ("$strength" -le "75") ]]; then
      icon="󰤥"
    elif [[ ("$strength" -ge "75") && ("$strength" -le "100") ]]; then
      icon="󰤨"
    fi
  fi
fi

# Add a force space
printf "%s\u00A0" "$icon"
