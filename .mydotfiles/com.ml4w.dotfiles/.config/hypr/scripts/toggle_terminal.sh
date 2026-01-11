#!/bin/bash

# Toggle between workspace 3 and 4
current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')

if [ "$current_workspace" == "4" ]; then
  hyprctl dispatch workspace 3
else
  hyprctl dispatch workspace 4
fi
