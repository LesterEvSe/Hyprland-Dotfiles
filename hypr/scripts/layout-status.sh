#!/bin/bash

layout=$(hyprctl devices -j | jq -r '.keyboards[-2].active_keymap')

case "$layout" in
  "English (US)")
    language="🇺🇸"
    ;;
  "Ukrainian")
    language="🇺🇦"
    ;;
  *)
    language="??"
    ;;
esac

printf "%s" "$language"
