starship init fish | source

# Abbreviations
abbr -a ll 'ls -lah'

# Git Abbreviations
abbr -a gco 'git checkout'
abbr -a gd 'git diff'
abbr -a gdc 'git diff --cached'
abbr -a gl 'git log'
abbr -a gs 'git status'

# Git Aliases
alias glp="git log --date=short --pretty=format:'%C(bold yellow)%h%C(reset) %C(white)%ad %C(bold blue)(%ar)%C(reset) %C(bold green)%an %C(reset)%C(cyan)%s%C(reset)'"

# Aliases
alias vim='nvim'
alias vact='source .venv/bin/activate.fish'
alias config='/usr/bin/git --git-dir=/home/mike/.cfg/.git/ --work-tree=/home/mike'
alias vimdiff='nvim -d'
alias erase-rak='gdb -ex "set confirm off" -ex "target extended-remote /dev/ttyACM1" -ex "monitor swdp_scan" -ex "attach 1" -ex "monitor erase_mass" -ex "kill" -ex "quit" -silent'
alias getscreen='scrot --delay 5 -p'
alias fix-camera='~/compile/linux-automation/c920webcam/setup_webcam.sh'
alias idf-source='source ~/compile/esp-idf/export.sh'
alias loom-converter='~/compile/linux-automation/loom-converter/loom_convert.sh'

# Set colors in minicom by default
set -Ux MINICOM "--color=on"

# Use nvim for everything
set -Ux EDITOR nvim

# Fix color highlighting when searching in Hyprland
set -U fish_color_search_match white --background=black

# Handle ssh-agent
if status is-interactive; and test (uname) = Linux
  if test "$hostname" = "nelson"
    set SSH_PRIVATE_KEYS \
        ~/.ssh/id_ed25519
  else if test "$hostname" = "krusty"
    set SSH_PRIVATE_KEYS \
        ~/.ssh/id_rsa
  end

  SHELL=fish keychain --eval $SSH_PRIVATE_KEYS | source

  # set NPM version
  nvm use lts
end

# set PATH so it includes user's private bin if it exists
if test -d $HOME/bin
  set -U fish_user_paths $HOME/bin $fish_user_paths
end

# set PATH so it includes user's private bin if it exists
if test -d $HOME/.local/bin
  fish_add_path $HOME/.local/bin
end

# Use kj for escape
set fish_key_bindings fish_user_key_bindings
