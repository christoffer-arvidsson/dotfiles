#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else

    selected=$(find ~/.dotfiles ~/.config ~/projects ~/repos ~/work -mindepth 0 -maxdepth 1 -type d | rofi -dmenu -p "Select directory for tmux session")
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] || [[ -z $tmux_running ]]; then
    alacritty -e tmux new-session -A -s $selected_name -c $selected
elif ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new -s $selected_name -c $selected -d
    alacritty -e tmux switch-client -t $selected_name
else
    echo "What the hell you are already in tmux"
    exit 1
fi

exit 0
