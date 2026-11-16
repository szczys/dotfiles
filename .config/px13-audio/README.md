# PX13 headphone workaround (RT721 on kernel 7.3)

## The problem
On kernel 7.3.x the Realtek RT721 codec (headphone jack and headset mic) can't
wake up after it powers down, so the headphone output disappears. The kernel
log shows:

    rt721-sdca sdw:0:1:025d:0721:01: ASoC error (-61): at snd_soc_pcm_component_pm_runtime_get()

- Broken by: `7a0886826308` "ASoC: codecs: rt721-sdca-sdw: Propagate regcache_sync() errors" (7.3)
- Fixed by: `e32773a86100` "ASoC: rt721: Remove invalid register defaults"
  (mainline 7.4-rc1, Oct 2026; waiting for a 7.3.x stable backport)

## The workaround
A udev rule keeps the codec powered so it never has to wake up:
`/etc/udev/rules.d/90-px13-rt721-no-autosuspend.rules` (copy in this folder).

Install it:

    sudo install -Dm644 ~/.config/px13-audio/90-px13-rt721-no-autosuspend.rules /etc/udev/rules.d/
    # then reboot

## How you'll know it's no longer needed
`rt721-fix-check.service` (systemd user unit) runs `check-rt721-fix.sh` at
login. It downloads `rt721-sdca-sdw.h` for your running kernel's upstream
version and looks for the line the fix deletes. If the line is gone and the
rule is still installed, you get a critical notification.

Check by hand at any time:

    ~/.config/px13-audio/check-rt721-fix.sh --verbose

You can also watch the stable changelogs (https://cdn.kernel.org/pub/linux/kernel/v7.x/)
for "rt721: Remove invalid register defaults".

## Removing the workaround
Do this only after the notification, or after the manual check reports the fix.

1. Delete the rule, then reboot:

       sudo rm /etc/udev/rules.d/90-px13-rt721-no-autosuspend.rules

2. After the reboot, confirm the codec suspends and wakes normally:

       cat /sys/bus/soundwire/devices/sdw:0:1:025d:0721:01/power/control   # should say: auto
       journalctl -k -b | grep 'rt721.*-61'                                 # should print nothing
       wpctl status                                                         # Headphones/Speaker sink present

   Play something through the headphones, wait a minute with nothing
   playing, then play again. If it plays the second time, the fix works.
   If it doesn't, put the rule back (step "Install it" above).

3. Remove the checker:

       systemctl --user disable --now rt721-fix-check.service
       rm ~/.config/systemd/user/rt721-fix-check.service
       rm -r ~/.config/px13-audio
