function gd
  if count $argv > /dev/null
    git diff $argv[1]
  else
    git diff
  end
end
