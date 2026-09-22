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
