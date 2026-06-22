--    ___       __           __           __
--   / _ |__ __/ /____  ___ / /____ _____/ /_
--  / __ / // / __/ _ \(_-</ __/ _ `/ __/ __/
-- /_/ |_\_,_/\__/\___/___/\__/\_,_/_/  \__/
--
-- Shared custom configuration for all hosts

-- Environment variables
hl.env("SDL_VIDEODRIVER", "wayland")

-- Cursor, misc
hl.config({
    cursor = {
        no_hardware_cursors = false,
    },
    misc = {
        focus_on_activate = true,
    },
})

-- Unbind default ML4W keybindings we override (pcall to not crash on missing binds)
local unbinds = {
    "SUPER + B",
    "SUPER + E",
    "SUPER + S",
    "SUPER + J",
    "SUPER + K",
    "SUPER + CTRL + E",
    "SUPER + CTRL + C",
    "SUPER + CTRL + RETURN",
}
for _, key in ipairs(unbinds) do
    pcall(hl.unbind, key)
end

-- Custom keybindings (vim-style HJKL navigation)
hl.bind("SUPER + E", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })
hl.bind("SUPER + S", hl.dsp.layout("swapsplit"), { description = "Swapsplit" })
hl.bind("SUPER + D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -replace -i"), { description = "Open application launcher" })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen on power button" })
hl.bind("F12", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_terminal.sh"), { description = "Toggle terminal workspace" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grimblast copy area"), { description = "Screenshot area to clipboard" })
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast save screen"), { description = "Screenshot active screen" })

-- Load host-specific configuration
local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")
local host_file = "custom-" .. hostname
local ok, err = pcall(require, host_file)
if not ok then
    print("Warning: could not load host config " .. host_file .. ": " .. tostring(err))
end