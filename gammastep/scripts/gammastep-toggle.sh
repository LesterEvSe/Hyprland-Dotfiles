#!/bin/bash
if pgrep -x gammastep > /dev/null; then
    pkill -x gammastep
    gammastep -O 3000 -P &
    disown
else
    pkill -f "gammastep -O"
    systemctl --user start gammastep.service
fi