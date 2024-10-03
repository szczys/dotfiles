alias vim=nvim
alias vact='source .venv/bin/activate'
alias config='/usr/bin/git --git-dir=/home/mike/.cfg/.git/ --work-tree=/home/mike'
alias vimdiff='nvim -d'
alias fix-ssh='eval $(ssh-agent -s); ssh-add'
alias erase-1024='JLinkExe -nogui 1 -if swd -speed auto -device MIMXRT1024XXX5A -CommanderScript /home/mike/golioth-compile/erase_mimxrt1024_evk.jlink'
alias getscreen='scrot --delay 5 -p'
