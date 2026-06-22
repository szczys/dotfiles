-- Host-specific configuration for Nelson
-- Monitors: laptop eDP-1 + external (laptop positioned to the right)

hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "1920x1080",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("slack", { workspace = "1" })
    hl.exec_cmd("firefox", { workspace = "2" })
    hl.exec_cmd("kitty", { workspace = "4" })
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
end)
