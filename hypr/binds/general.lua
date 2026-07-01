local mod      = _G.mainMod  or "SUPER"
local terminal = _G.terminal or "kitty"

-------------------
-- SCREENSHOTS ----
-------------------
-- Shell command pieces
local slurp_cmd       = "slurp -o -d -w 2 -B 00000000 -b 00000000 -s 00000000 -c"
local grim_cmd        = "grim -o $(hyprctl activeworkspace | grep -Po '(?<=\\d\\) on monitor ).*?(?=:)') -t png -l 6 -"
local screenshot_path = "tee ~/Pictures/screenshots/screenshot-$(date +'%d.%m.%y-%H:%M:%S').png"

-- Region screen, not saved
hl.bind("Print",
    hl.dsp.exec_cmd(
        "wl-copy -c; grim -g \"$(" .. slurp_cmd .. " 009c73 && sleep 0.1)\" -t png -l 9 - | wl-copy -t image/png"
    ))

-- Region screen, saved
hl.bind("SHIFT + Print",
    hl.dsp.exec_cmd(
        "grim -g \"$(" .. slurp_cmd .. " 800080 && sleep 0.1)\" -t png -l 6 - | " ..
        screenshot_path .. " | wl-copy -t image/png"
    ))

-- Fullscreen, not saved
hl.bind("CTRL + Print",
    hl.dsp.exec_cmd(grim_cmd .. " | wl-copy -t image/png"))

-- Fullscreen, saved
hl.bind("CTRL + SHIFT + Print",
    hl.dsp.exec_cmd(grim_cmd .. " | " .. screenshot_path .. " | wl-copy -t image/png"))


---------------------
-- APPLICATIONS ----
---------------------
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("Telegram"))
hl.bind(mod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + G", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("code"))        -- VS Code
hl.bind(mod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd("spotify"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("vesktop"))     -- Discord client
hl.bind(mod .. " + R", hl.dsp.exec_cmd("dolphin"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("wl-paste | swappy -f -"))
hl.bind("CTRL + " .. mod .. " + S", hl.dsp.exec_cmd("steam"))


---------------------
-- SESSION CONTROL --
---------------------
-- NOTE: if you're using uwsm, the wiki recommends `uwsm stop` over hl.dsp.exit().
-- See https://wiki.hypr.land/Configuring/Basics/Dispatchers/ (Warning box).
hl.bind("ALT + M", hl.dsp.exit())
hl.bind("ALT + C", hl.dsp.window.close())
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/lock-and-sleep.sh"))

-- Night mode
hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("gammastep -O 4000"))
hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd("pkill gammastep"))

-- hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("bash ~/.config/gammastep/scripts/gammastep-toggle"))
-- hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd("pkill -x gammastep; gammastep -x"))


---------------------------
-- WINDOW MANIPULATION ----
---------------------------
-- NOTE: swap-by-direction is `hl.dsp.window.swap({ direction = ... })`; verify with
-- `hyprctl repl 'hl.dsp.window.swap'` if you hit an error.
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left"  }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down"  }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up"    }))

-- Move focus
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down"  }))


------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@120.00",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@180.00",
    position = "0x1080",
    scale    = 1,
})

----------------------
----- WORKSPACES -----
----------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,            hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i }))
end

-- Bind specific workspaces to the external monitor (Top)
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

-- Bind the rest to the laptop (Bottom)
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })


-----------------------
-- SPECIAL WORKSPACE --
-----------------------
-- Hide active window
hl.bind(mod .. " + minus", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Restore/Pop the window back out
hl.bind(mod .. " + equal", function()
    -- 1. Fetch the list of windows currently hiding in your special workspace
    local magic_windows = hl.get_windows({ workspace = "special:magic" })
    
    -- 2. Make sure the workspace isn't empty before trying to do anything
    if magic_windows then
        -- 3. Loop through the hidden windows, move the first one to the active workspace (+0), and stop
        for _, win in pairs(magic_windows) do
            hl.dispatch(hl.dsp.window.move({ window = win, workspace = "+0" }))
            break
        end
    end
end)

----------------------
-- FLOATING / MOUSE --
----------------------
hl.bind(mod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })  -- LMB
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- RMB
