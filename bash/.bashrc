alias v='nvim'
alias t='tmux'
alias q='exit'
alias c='clear'
alias ls='ls -a --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -rf'
alias ln='ln -i'
alias du='du -ch'
alias mount='mount | column -t'
alias now='date "+%T"'
alias datef='date "+%d-%m-%Y"'
alias ports='netstat -tulanp'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias tmux-sessionizer='~/tmux-sessionizer.sh'

OPT=/opt
for d in gcc-15 clang-21 zig rust c3 ldc/bin go/bin node/bin; do
    [ -d "$OPT/$d" ] && PATH="$OPT/$d:$PATH"
done
export PATH

bind -x '"\C-f": tmux-sessionizer'
eval "$(starship init bash)"
