------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------
-- Globals so the binds module can reference them.
_G.mainMod  = "SUPER"
_G.terminal = "kitty"


-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & gammastep -O 3000")
    hl.exec_cmd(
        "swayidle -w " ..
        "timeout 840 'brightnessctl set 30%' resume 'brightnessctl set 100%' " ..
        "timeout 900 'bash ~/.config/hypr/scripts/lock-and-sleep.sh'"
    )
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE",                       "24")
hl.env("HYPRCURSOR_SIZE",                    "24")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(009c73aa)", "rgba(00ff99aa)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split  = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })


---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "us,ua",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 to 1.0

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- gestures.workspace_swipe was removed in the new gestures system.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Per-device config example (kept from your conf)
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


----------------------
---- LOAD MODULES ----
----------------------
-- These are loaded last so the globals above (mainMod, terminal) are set.
require("binds.general")
require("binds.media-brightness")
require("windowrules")
