#!/bin/bash

if [ "$(hostname)" == "nelson" ]; then
  xss-lock --transfer-sleep-lock -- cinnamon-screensaver &
  xset dpms 300
fi

if [ "$(hostname)" == "krusty" ]; then
  xss-lock --transfer-sleep-lock -- i3lock -c 04090e --nofork
  xset dpms 300
fi

