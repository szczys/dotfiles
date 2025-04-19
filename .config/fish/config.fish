starship init fish | source

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

# Git aliases
alias gs='git status'
alias glp="git log --date=short --pretty=format:'%C(bold yellow)%h%C(reset) %C(white)%ad %C(bold blue)(%ar)%C(reset) %C(bold green)%an %C(reset)%C(cyan)%s%C(reset)'"
