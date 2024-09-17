# Updates
### 1. Video Screen Supported
Think with `wl-recorder -g "$(slurp)" -f ~/path/to/saving_file.mp4` command. and code
``` sh
#!/usr/bin/env bash

VIDEOS_DIR="$HOME/Videos"
FILENAME="$(date +'%B %d | %H:%M:%S | output.mp4')"
START_TIME=0

start_recording() {
    GEOMETRY="$(slurp)"
    echo "$(date +%s)" > "/tmp/screenrec_start_time"
    wf-recorder -g "$GEOMETRY" -f "$VIDEOS_DIR/$FILENAME" -y &
}

show_status() {
    if pgrep -x "wf-recorder" > /dev/null; then
        START_TIME=$(cat "/tmp/screenrec_start_time")
        CURRENT_TIME=$(date +%s)

        ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
        MINUTES=$((ELAPSED_TIME / 60))
        SECONDS=$((ELAPSED_TIME % 60))

        printf '{"text": "%02d:%02d", "class": "in_progres", "alt": "in_progres"}\n' "$MINUTES" "$SECONDS"
    else
        printf '{"text": "", "class": "none", "alt": "none"}\n'
    fi
}

stop_recordings() {
    if pkill -x "wf-recorder"; then
        last_recording=$(ls -t "$VIDEOS_DIR"/*.mp4 | head -n1)

        if [ -n "$last_recording" ]; then
            echo "file://$last_recording" | wl-copy -t 'text/uri-list'
        fi
    fi
}

case "$1" in
    start)
        start_recording
        ;;
    status)
        show_status
        ;;
    stop)
        stop_recordings
        ;;
    *)
        echo "Usage: $0 {start|status|stop}"
        ;;
esac
```

``` json
    "custom/screenrec": {
        "tooltip": false,
        "format": "{}{icon}",
        "format-icons": {
            "in_progres": "",
            "none": ""
        },
        "return-type": "json",
        "exec": "~/.scripts/screenrec.sh status",
        "on-click": "~/.scripts/screenrec.sh stop",
        "on-click-right": "~/.scripts/screenrec.sh start",
        "interval": 1,
    },
```

``` css
#custom-screenrec.in_progres {
    color: red
}
```

### 2. Bluetooth badge and set up

I don't know about the customization button yet.
``` sh
# Bluetooth install for pipewire
# Instead of "pipewire-media-session" we can use wireplubmer
sudo pacman -S pipewire pipewire-pulse pipewire-media-session bluez bluez-utils

sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Check is it work or not
bluetoothctl

power on
scan on  # looking for a right device
pair XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX  # for auto connect

# If we want to switch to headphones, then use
pavucontrol
```

For bluetooth we can use: [this code](https://github.com/knightfallxz/Hyprland-Dots/blob/070c32c1f65286dd2a642380b4aedecee65a8d74/waybar/Waybar-3.0/config#L131)