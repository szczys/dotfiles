function battery --description 'Show or set the battery charge limit: battery [PERCENT]'
  set -l bat /sys/class/power_supply/BAT0
  set -l limit $bat/charge_control_end_threshold

  if not test -e $limit
    echo "battery: $limit not found (charge limit not supported?)" >&2
    return 1
  end

  # No argument: show current state
  if not count $argv > /dev/null
    echo "Charge: "(cat $bat/capacity)"% ("(cat $bat/status)"), limit: "(cat $limit)"%"
    return 0
  end

  set -l pct (string trim -c '%' -- $argv[1])
  if not string match -qr '^[0-9]+$' -- $pct; or test $pct -lt 20 -o $pct -gt 100
    echo "Usage: battery [PERCENT]   (PERCENT: 20-100, no argument shows current state)" >&2
    return 2
  end

  # Writable by the users group via udev rule; fall back to sudo if not.
  if test -w $limit
    echo $pct > $limit
  else
    echo $pct | sudo tee $limit > /dev/null
  end
  or return 1

  echo "Charge limit set to "(cat $limit)"%"
end
