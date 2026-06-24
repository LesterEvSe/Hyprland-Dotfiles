
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})


-------------------------------------
-- Auto-assign apps to workspaces  --
-------------------------------------
hl.window_rule({ name = "ws-code",     match = { class = "Code"          }, workspace = "1" })
hl.window_rule({ name = "ws-firefox",  match = { class = "firefox"       }, workspace = "2" })
hl.window_rule({ name = "ws-chrome",   match = { class = "google-chrome" }, workspace = "2" })
hl.window_rule({ name = "ws-obsidian", match = { class = "obsidian"      }, workspace = "3" })
hl.window_rule({ name = "ws-spotify",  match = { class = "Spotify"       }, workspace = "4" })


------------------------------
-- Floating apps with size  --
------------------------------
-- Telegram
hl.window_rule({
    name  = "tg-float",
    match = { class = "^(org.telegram.desktop|telegramdesktop)$" },
    float = true,
    size  = "889 889",
})

-- Discord (native)
hl.window_rule({
    name  = "discord-float",
    match = { class = "^(discord)$" },
    float = true,
    size  = "1000 900",
})

-- Vesktop
hl.window_rule({
    name   = "vesktop-float",
    match  = { class = "^(vesktop)$" },
    float  = true,
    center = true,
    size   = "1000 900",
})

-- Filelight
hl.window_rule({
    name  = "filelight-float",
    match = { class = "^(org.kde.filelight)$" },
    float = true,
    size  = "1000 800",
})

-- Dolphin
hl.window_rule({
    name  = "dolphin-float",
    match = { class = "^(org.kde.dolphin)$" },
    float = true,
    size  = "1000 600",
})