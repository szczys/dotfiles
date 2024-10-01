POLYBAR=~/compile/polybar/build/bin/polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m $POLYBAR --reload toph &
  done
else
  $POLYBAR --reload toph &
fi
