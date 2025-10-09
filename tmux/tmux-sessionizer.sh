#!/usr/bin/env bash

# directories to search in
search_dirs=(
    "$HOME/github"
    "$HOME/Prog"
    "$HOME/makestatic"
)

existing_dirs=()
for dir in "${search_dirs[@]}"; do
    if [[ -d $dir ]]; then
        existing_dirs+=("$dir")
    fi
done

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${existing_dirs[@]}" -mindepth 1 -maxdepth 4 -type d 2>/dev/null \
        | grep -v '/\.' \
        | fzf)
fi

[[ -z $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

tmux_running=$(pgrep tmux)

if [[ -z $TMUX && -z $tmux_running ]]; then
    exec tmux new-session -s "$selected_name" -c "$selected"
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
