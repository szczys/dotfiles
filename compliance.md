# Compliance tools for Arch Linux

## Drata Agent patch

Drata Agent's tray popover hides itself on Electron's `blur` event, which
fires spuriously under Hyprland with `follow_mouse = 1`. The fix is a
user-local asar patch that neutralizes the `blur -> hide()` handler.

Tracked files:
- `~/.local/bin/drata-agent` — wrapper running the patched asar
- `~/.local/bin/drata-agent-repatch` — re-applies the patch after drata upgrades
- `~/.local/share/applications/drata-agent.desktop` — launcher override
- `~/.local/share/dotfiles_misc/drata-agent-repatch.hook` — pacman hook source

Setup on a fresh machine:
1. Generate the patched asar (re-extracts from the installed package):
   `drata-agent-repatch`
2. Install the pacman hook so upgrades re-patch automatically:
   `sudo install -m 644 ~/.local/share/dotfiles_misc/drata-agent-repatch.hook /etc/pacman.d/hooks/drata-agent-repatch.hook`

To re-apply the patch manually after a drata upgrade if the hook is not installed:
`drata-agent-repatch`
