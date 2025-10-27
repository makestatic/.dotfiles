if ! pgrep -x emacs >/dev/null; then
    emacs --daemon >/dev/null 2>&1 &
fi

es() {
    if [ $# -eq 0 ]; then
        emacsclient -c -a ""
    else
        emacsclient -c -a "" "$@"
    fi
}

export EDITOR="emacsclient -c -a ''"
export VISUAL="$EDITOR"
alias ke="emacsclient -e '(kill-emacs)'"
alias e="es"
alias v="es"
alias t='tmux'
alias q='exit'
alias c='clear'

alias ls='ls -a --color=auto'
alias ll='ls -la --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -rfv' 
alias du='du -ch'

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

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
# >>> xmake >>>
test -f "/home/makes/.xmake/profile" && source "/home/makes/.xmake/profile"
# <<< xmake <<<