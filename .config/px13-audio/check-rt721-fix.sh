#!/usr/bin/env bash
# Checks whether the running kernel includes the upstream RT721 resume fix
# (e32773a86100 "ASoC: rt721: Remove invalid register defaults").
# If it does and the udev workaround is still installed, sends a notification.
# Run with --verbose to print the result regardless.
set -u

RULE=/etc/udev/rules.d/90-px13-rt721-no-autosuspend.rules
MARKER='{ 0x2000046, 0x3400 },'   # line the fix deletes from rt721-sdca-sdw.h
VERBOSE=${1:-}

say() { echo "rt721-fix-check: $*"; }

# 7.3.4-arch1-2 -> v7.3.4 ; 7.4.0-arch1-1 -> v7.4
ver=$(uname -r | cut -d- -f1)
ver=${ver%.0}
tag="v$ver"
url="https://raw.githubusercontent.com/gregkh/linux/$tag/sound/soc/codecs/rt721-sdca-sdw.h"

src=""
for _ in 1 2 3 4 5; do
    src=$(curl -fsS --max-time 20 "$url" 2>/dev/null) && break
    src=""
    sleep 30
done

if [ -z "$src" ]; then
    say "could not fetch $url (offline, or tag $tag not published); try again later"
    exit 0
fi

if grep -qF "$MARKER" <<<"$src"; then
    say "kernel $tag does NOT include the fix yet; keep the workaround"
    exit 0
fi

say "kernel $tag includes the RT721 fix"
if [ -e "$RULE" ]; then
    notify-send -u critical -a "PX13 audio" \
        "RT721 headphone workaround no longer needed" \
        "Kernel $tag includes the fix. Follow ~/.config/px13-audio/README.md to remove the udev rule."
elif [ "$VERBOSE" = "--verbose" ]; then
    say "workaround already removed"
fi
