starship init fish | source

# Abbreviations
abbr -a -U -- ll 'ls -lah'

# Git Abbreviations
abbr -a -U -- gco 'git checkout'
abbr -a -U -- gd 'git diff'
abbr -a -U -- gdc 'git diff --cached'
abbr -a -U -- gl 'git log'
abbr -a -U -- gs 'git status'

# Git Aliases
alias glp="git log --date=short --pretty=format:'%C(bold yellow)%h%C(reset) %C(white)%ad %C(bold blue)(%ar)%C(reset) %C(bold green)%an %C(reset)%C(cyan)%s%C(reset)'"

# Aliases
alias vim='nvim'
alias vact='source .venv/bin/activate.fish'
alias config='/usr/bin/git --git-dir=/home/mike/.cfg/.git/ --work-tree=/home/mike'
alias vimdiff='nvim -d'
alias erase-1024='JLinkExe -nogui 1 -if swd -speed auto -device MIMXRT1024XXX5A -CommanderScript /home/mike/golioth-compile/erase_mimxrt1024_evk.jlink'
alias erase-rak='gdb -ex "set confirm off" -ex "target extended-remote /dev/ttyACM1" -ex "monitor swdp_scan" -ex "attach 1" -ex "monitor erase_mass" -ex "kill" -ex "quit" -silent'
alias getscreen='scrot --delay 5 -p'
alias fix-camera='~/compile/linux-automation/c920webcam/setup_webcam.sh'
alias idf-source='source ~/compile/esp-idf/export.sh'

# Set colors in minicom by default
set -U MINICOM "--color=on"

# Handle ssh-agent
if test "$hostname" = "nelson"
  eval (keychain --eval --agents ssh id_ed25519)
else
  eval (keychain --eval --agents ssh id_rsa)
end

# set PATH so it includes user's private bin if it exists
if test -d $HOME/bin
  set -U fish_user_paths $HOME/bin $fish_user_paths
end

# set PATH so it includes user's private bin if it exists
if test -d $HOME/.local/bin
  set -U fish_user_paths $HOME/.local/bin $fish_user_paths
end

# set GOPATH and add to PATH if it exists
if test -d $HOME/.local/bin
  set -U GOPATH $HOME/go
  set -U fish_user_paths $HOME/$GOPATH/bin $fish_user_paths
  set -U fish_user_paths /usr/local/go/bin $fish_user_paths
end

# set NPM version
nvm use lts
