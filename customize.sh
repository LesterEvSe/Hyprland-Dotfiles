#!/bin/bash
yay -Syu --noconfirm

# xkb-switch - to determine the layout
yay -Sy --noconfirm xkb-switch

# grim for screenshots, slurp specific area
# playerctl - music control
# swaidle - auto-lock after a certain period of time
# gammastep - setting up a blue filter
# jq - for query in layout-status.sh
# libappindicator-gtk3, xdg-desktop-portal-wlr - to display the telegram icon
sudo pacman -Sy --noconfirm hyprland hyprlock hyprpaper \
    waybar grim slurp wl-clipboard ttf-jetbrains-mono-nerd \
    playerctl swayidle gammastep jq kitty vim fish \
    libappindicator-gtk3 xdg-desktop-portal-wlr brightnessctl wpctl playerctl \
    noto-fonts-emoji fonts-noto-color-emoji nerd-fonts

sudo usermod -aG input $USER  # To display some icons


# Apply current configs
mkdir -p ~/Pictures/screenshots
mkdir -p ~/Pictures/wallpapers

cd Pictures
cp archlinux-logo.png ~/Pictures/
cp girl-cat-night.jpeg nature-and-deer.jpg ~/Pictures/wallpapers/
cd ..

start_dir=$(pwd)

# Save previous configs
cd ~
if ! mkdir -p .config; then
  cd .config
  mkdir -p old_config
  mv fish hypr kitty waybar ~/.config/old_config
fi

cd "$start_dir"
cp -r fish hypr kitty waybar ~/.config

sudo sh -c 'echo $(which fish) >> /etc/shells'  # Add to the list of allowed
chsh -s $(which fish)  # Change shell

reboot
