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

## Automatic Updates (Drata Compliance)

This repository includes systemd units (`auto-update.service` and `auto-update.timer`) designed to run weekly automated `pacman` updates every Friday at 11:00 PM to satisfy workstation compliance controls.

### Installation & Setup

1. Copy the systemd service and timer files to the system directory:
   ```bash
   sudo cp ~/.local/share/dotfiles_misc/auto-update.service /etc/systemd/system/
   sudo cp ~/.local/share/dotfiles_misc/auto-update.timer /etc/systemd/system/
   ```

2. Reload systemd to recognize the new unit files:
   ```bash
   sudo systemctl daemon-reload
   ```

3. Enable and start the timer:
   ```bash
   sudo systemctl enable --now auto-update.timer
   ```

### Verification & Compliance Artifacts

* **Verify the timer is scheduled:**
  ```bash
  systemctl list-timers auto-update.timer
  ```
  *Check:* Ensure the `NEXT` column lists the upcoming Friday at 23:00.

* **Check service execution logs (for Drata uploads):**
  ```bash
  journalctl -u auto-update.service
  ```
  *Check:* Ensure recent executions return an exit code of `0` (success).

## ClamAV Scheduled System Scans

This directory contains systemd service and timer files to automate daily ClamAV malware scans and display desktop notifications upon completion.

### Files
* `clamscan.service` - Executes the system scan and triggers a desktop notification based on the exit status.
* `clamscan.timer` - Schedules the scan to run automatically once per day.

### Installation

Copy the unit files from `~/.local/share/dotfiles_misc/` into the systemd system directory, reload, and enable the service:

```bash
sudo cp ~/.local/share/dotfiles_misc/clamscan.service /etc/systemd/system/
sudo cp ~/.local/share/dotfiles_misc/clamscan.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now clamscan.timer
```

* **Check next scheduled execution:**
  ```bash
  systemctl list-timers clamscan.timer
  ```

* **Manually trigger a test scan:**
  ```bash
  sudo systemctl start clamscan.service
  ```

* **Inspect scan history and logs:**
  ```bash
  sudo journalctl -u clamscan.service
  ```
