function vpn
  function show_usage
    echo "Usage: vpn [up|down]"
  end

  if count $argv > /dev/null
    if test $hostname = "nelson"
      set vpn_name "maggie"
    else if test $hostname = "krusty"
      set vpn_name "lisa"
    else
      echo "Unknown hostname, abort"
      return 1
    end

    if test "$argv[1]" = "up" -o "$argv[1]" = "down"
      echo "Setting VPN $vpn_name to $argv[1]"
      sudo nmcli conn "$argv[1]" "$vpn_name"
    else
      show_usage
      return 2
    end

  else
    show_usage
    return 2
  end
end

