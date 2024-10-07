#!/bin/bash

#toggle between these workspaces:
workspace_a=3
workspace_b=4

#get focused
focused_workspace=`i3-msg -t get_workspaces | jq '.[] | select(.focused==true)' | jq .num`
notify-send "$focused_workspace"

if [ $focused_workspace == $workspace_a ]; then
  i3-msg workspace $workspace_b
else
  i3-msg workspace $workspace_a
fi

