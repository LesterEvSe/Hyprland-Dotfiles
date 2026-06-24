local mod      = _G.mainMod  or "SUPER"
local terminal = _G.terminal or "kitty"

-------------------
-- SCREENSHOTS ----
-------------------
-- Shell command pieces (kept identical to your conf for behaviour parity)
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
hl.bind("ALT + C", hl.dsp.window.close())               -- old: killactive
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/lock-and-sleep.sh"))

-- Night mode (gammastep)
hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("gammastep -O 3000"))
hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd("pkill gammastep"))


---------------------------
-- WINDOW MANIPULATION ----
---------------------------
-- Swap windows: SUPER + SHIFT + arrows
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


----------------------
-- WORKSPACES --------
----------------------
-- SUPER + [0-9]            -> go to workspace
-- SUPER + SHIFT + [0-9]    -> send window to workspace
for i = 1, 10 do
    local key = i % 10 -- 10 maps to "0"
    hl.bind(mod .. " + " .. key,            hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,    hl.dsp.window.move({ workspace = i }))
end


-----------------------
-- SPECIAL WORKSPACE --
-----------------------
-- Hide active window into the special workspace (silent: don't switch view)
-- NOTE: silent move via `silent = true` on the move dispatcher. If that flag
-- isn't recognised in your build, fall back to:
--   hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent special"))
hl.bind(mod .. " + minus", hl.dsp.window.move({ workspace = "special", silent = true }))

-- Show / cycle through hidden windows: toggle special, cycle, then pull current to active ws
hl.bind(mod .. " + equal", function()
    hl.dispatch(hl.dsp.workspace.toggle_special())                        -- toggle special
    hl.dispatch(hl.dsp.window.cycle_next({ reverse = true }))             -- FIFO: oldest first
    hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))                 -- pull into current ws
end)


----------------------
-- FLOATING / MOUSE --
----------------------
hl.bind(mod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })  -- LMB
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- RMB
