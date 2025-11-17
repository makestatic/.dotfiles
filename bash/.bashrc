# if ! pgrep -x emacs >/dev/null; then
#     emacs --daemon >/dev/null 2>&1 &
# fi
#
set -o vi
es() {
    if [ $# -eq 0 ]; then
        emacsclient -c -a ""
    else
        emacsclient -c -a "" "$@"
    fi
}

export EDITOR="nvim"
export VISUAL="$EDITOR"
alias e=es
alias v=nvim
alias ke="emacsclient -e '(kill-emacs)'"
alias t=tmux
alias q=exit
alias c=clear
alias ls='ls -a --color=auto'
alias ll='ls -la --color=auto -h'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -rfv'
alias du='du -h'
alias now='date "+%T"'
alias datef='date "+%d-%m-%Y"'
alias ports='netstat -tulanp'
alias wget='wget -c'
alias path='echo -e "${PATH//:/\\n}"'
alias tmux-sessionizer='~/tmux-sessionizer.sh'

export PATH="/opt:$PATH"
for d in gcc-15/bin clang-21/bin v zig rust/bin c3 ldc/bin go/bin node/bin; do
    [ -d "/opt/$d" ] && case ":$PATH:" in *":/opt/$d:"*) ;; *) PATH="/opt/$d:$PATH" ;; esac
done
export PATH

[ -d /opt/gcc-15 ] && {
    export LD_LIBRARY_PATH="/opt/gcc-15/lib64:${LD_LIBRARY_PATH:-}"
    export C_INCLUDE_PATH="/opt/gcc-15/include"
    export CPLUS_INCLUDE_PATH="/opt/gcc-15/include"
}

bind -x '"\C-f": tmux-sessionizer' 2>/dev/null || true
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -f "$HOME/.xmake/profile" ] && source "$HOME/.xmake/profile"
