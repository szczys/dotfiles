hl.monitor({
    output = "desc:Ancor Communications Inc ASUS VS229 JCLMTF198590",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "desc:Ancor Communications Inc ASUS VS228 D9LMTF093107",
    mode = "1920x1080@60",
    position = "1920x0",
    scale = 1,
})
hl.monitor({
    output = "desc:Samsung Display Corp. ATNA33AA08-0",
    mode = "1920x1200@60",
    position = "1920x1080",
    scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "desc:Ancor Communications Inc ASUS VS229 JCLMTF198590" })
hl.workspace_rule({ workspace = "2", monitor = "desc:Ancor Communications Inc ASUS VS229 JCLMTF198590" })
hl.workspace_rule({ workspace = "3", monitor = "desc:Ancor Communications Inc ASUS VS228 D9LMTF093107" })
hl.workspace_rule({ workspace = "4", monitor = "desc:Ancor Communications Inc ASUS VS228 D9LMTF093107" })
hl.workspace_rule({ workspace = "5", monitor = "desc:Tianma Microelectronics Ltd. TL134ADXP03" })

hl.on("hyprland.start", function()
    hl.exec_cmd("slack", { workspace = "1" })
    hl.exec_cmd("firefox", { workspace = "2" })
    hl.exec_cmd("kitty", { workspace = "4" })
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("sh -c 'sleep 3 && exec drata-agent'")
end)

-- Force a real DPMS off->on cycle; setDPMS(true) is a no-op if Hyprland already thinks the output is on.
-- Note: hl.dsp.dpms only honors a table's `action` field; anything else ("on", {enable=true}) toggles.
local function kick_dpms(name)
    hl.dispatch(hl.dsp.dpms({ action = "off", monitor = name }))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "on", monitor = name }))
    end, { timeout = 1000, type = "oneshot" })
end

-- MST externals re-enumerate (DP-8 -> DP-10 -> DP-12...) after resume / dock replug
hl.on("monitor.added", function(mon)
    if mon.name:match("^DP%-") then
        hl.timer(function() kick_dpms(mon.name) end, { timeout = 1500, type = "oneshot" })
    end
end)

-- Manual recovery that works under hyprlock (use the laptop keyboard)
hl.bind("SUPER + CTRL + ALT + W", function()
    hl.dispatch(hl.dsp.dpms({ action = "off" }))
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "on" })) end, { timeout = 1000, type = "oneshot" })
end, { locked = true, description = "Force-wake displays" })
