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

-- 0.57.0 enabled this by default (PR #15803); its format-table resets after
-- MST/dock re-enumeration on resume kill Wayland clients. See hyprwm/Hyprland#16716.
hl.config({
    quirks = {
        skip_non_kms_dmabuf_formats = false,
    },
})

-- Force a real DPMS off->on cycle; setDPMS(true) is a no-op if Hyprland already thinks the output is on.
-- Note: hl.dsp.dpms only honors a table's `action` field; anything else ("on", {enable=true}) toggles.
-- Delays trimmed from 1500/1000 ms to cut wake time; if the externals come up
-- black again after resume, raise KICK_DELAY_MS first (SUPER+CTRL+ALT+W recovers).
local KICK_DELAY_MS = 500   -- after monitor.added, let the initial modeset finish
local KICK_OFF_MS = 250     -- how long the output stays off during the kick

local function kick_dpms(name)
    hl.dispatch(hl.dsp.dpms({ action = "off", monitor = name }))
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "on", monitor = name }))
    end, { timeout = KICK_OFF_MS, type = "oneshot" })
end

-- MST externals re-enumerate (DP-8 -> DP-10 -> DP-12...) after resume / dock replug
hl.on("monitor.added", function(mon)
    if mon.name:match("^DP%-") then
        hl.timer(function() kick_dpms(mon.name) end, { timeout = KICK_DELAY_MS, type = "oneshot" })
    end
end)

-- Manual recovery that works under hyprlock (use the laptop keyboard)
hl.bind("SUPER + CTRL + ALT + W", function()
    hl.dispatch(hl.dsp.dpms({ action = "off" }))
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "on" })) end, { timeout = 1000, type = "oneshot" })
end, { locked = true, description = "Force-wake displays" })
