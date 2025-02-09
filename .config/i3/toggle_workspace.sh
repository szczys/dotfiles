#!/bin/bash

#toggle between these workspaces:
workspace_a=4
workspace_b=3

#get focused
focused_workspace=`i3-msg -t get_workspaces | jq '.[] | select(.focused==true)' | jq .num`

if [ $focused_workspace == $workspace_a ]; then
  i3-msg workspace $workspace_b
else
  i3-msg workspace $workspace_a
fi

