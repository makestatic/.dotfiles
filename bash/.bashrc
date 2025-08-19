# PS1='\n\e[34m$PWD\e[0m * '

alias v="nvim"
alias t="tmux"
alias q="exit"
alias c="clear"
alias mount='mount |column -t'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ports='netstat -tulanp'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -rf'
alias ls='ls -a --color=auto'
alias ln='ln -i'
alias du='du -ch'
alias emacs='emacs -nw'

# Local bins
export LOCAL_BIN="$HOME/.local/bin"
export PATH="$LOCAL_BIN:$PATH"
export BUN_INSTALL="$LOCAL_BIN/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$LOCAL_BIN/zig:$PATH"
export PATH="$LOCAL_BIN/go/bin:$PATH"
export NODE_INSTALL="$LOCAL_BIN/node"
export PATH="$NODE_INSTALL/bin:$PATH"

alias tmux-sessionizer='~/tmux-sessionizer.sh'
bind -x '"\C-f": tmux-sessionizer'

eval "$(starship init bash)"
