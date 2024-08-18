#!/bin/bash

CONFIG_FILE="$HOME/.config/waybar/scripts/brightness"
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
threshold=10

reset="reset"
curr=$(head -n 1 "$CONFIG_FILE")

if [ "$curr" != "$reset" ] && [ "$BATTERY_LEVEL" -ge $threshold ]; then
    echo $reset > $CONFIG_FILE
    exit 0
fi

if [ "$curr" == "$reset" ] && [ "$BATTERY_LEVEL" -lt $threshold ]; then
    echo "decreased" > $CONFIG_FILE
    brightnessctl set 30%
fi
