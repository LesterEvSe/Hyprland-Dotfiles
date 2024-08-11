#!/bin/bash

# It was difficult...
layout=$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | tail -n2 | head -n1)
language="??"

if [[ "$layout" == "English (US)" ]]; then
  language="EN"
elif [[ "$layout" == "Ukrainian" ]]; then
  language="UA"
fi

printf "%s   " "$language"