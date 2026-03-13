#!/usr/bin/env bash
hyprctl keyword monitor eDP-1,2560x1600,1280x1080,1
hyprctl --instance 0 dispatch moveworkspacetomonitor 1 1
hyprctl --instance 0 dispatch moveworkspacetomonitor 2 1
hyprctl --instance 0 dispatch moveworkspacetomonitor 3 2
hyprctl --instance 0 dispatch moveworkspacetomonitor 4 2
hyprctl keyword monitor eDP-1, disable
