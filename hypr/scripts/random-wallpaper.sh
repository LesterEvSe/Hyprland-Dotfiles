#!/bin/bash

# Get random file
random_wallpaper=$(find ~/Pictures/wallpapers/ -type f | shuf -n 1)

# For relative path
relative_wallpaper=$(echo "$random_wallpaper" | sed "s|$HOME|~|")

# Find and insert
sed -i "s|^preload = .*|preload = $relative_wallpaper|" ~/.config/hypr/hyprpaper.conf
sed -i "/^wallpaper =,/c\wallpaper =, $relative_wallpaper" ~/.config/hypr/hyprpaper.conf
