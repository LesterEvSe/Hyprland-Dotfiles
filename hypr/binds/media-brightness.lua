-- Notes:
--   * `binde` (repeatable) -> { repeating = true }
--   * laptop media/brightness keys -> add { locked = true } so they fire
--     even when the session is locked.

----------------
-- BRIGHTNESS --
----------------
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl s 5%+"),
    { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl s 5%-"),
    { repeating = true, locked = true })


-----------
-- AUDIO --
-----------
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true, locked = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true })


--------------------
-- MUSIC CONTROL  --
--------------------
hl.bind("SHIFT + left",  hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SHIFT + right", hl.dsp.exec_cmd("playerctl next"))
hl.bind("SHIFT + up",    hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("SHIFT + down",  hl.dsp.exec_cmd("playerctl stop"))
