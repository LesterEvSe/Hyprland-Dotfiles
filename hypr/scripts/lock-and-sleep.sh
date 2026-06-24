#!/bin/bash
pgrep -x hyprlock >/dev/null || hyprlock --immediate
systemctl suspend
