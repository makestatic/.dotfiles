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
alias path='echo -e "${PATH//:/\\n}"'
alias tmux-sessionizer='~/tmux-sessionizer.sh'

# paths
OPT=/opt
for d in gcc-15/bin clang-21/bin zig rust/bin c3 ldc/bin go/bin node/bin; do
    [ -d "$OPT/$d" ] && case ":$PATH:" in
        *":$OPT/$d:"*) : ;;  # already in PATH. skip
        *) PATH="$OPT/$d:$PATH" ;;
    esac
done
export PATH

# GCC-15
if [ -d /opt/gcc-15 ]; then
    export LD_LIBRARY_PATH="/opt/gcc-15/lib64:${LD_LIBRARY_PATH:-}"
    export C_INCLUDE_PATH="/opt/gcc-15/include"
    export CPLUS_INCLUDE_PATH="/opt/gcc-15/include"
fi

bind -x '"\C-f": tmux-sessionizer' 2>/dev/null || true
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)" || true

# source on login
if [ -n "$PS1" ] && [ -f ~/.bashrc ] && [ "$BASH_SOURCE" != "$HOME/.bashrc" ]; then
    case "$0" in
        -*)
            [[ -f ~/.bashrc ]] && . ~/.bashrc
        ;;
    esac
fi
