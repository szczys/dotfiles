eval "$(starship init bash)"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

PATH=$PATH:/usr/local/bin/yt-dlp
