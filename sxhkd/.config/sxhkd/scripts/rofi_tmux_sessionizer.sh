#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/projects ~/repos ~/work -mindepth 1 -maxdepth 1 -type d -not -path '*/[@.]*' | rofi -dmenu -p "Select directory for tmux session")
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    kitty -e tmux new-session -sA $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    kitty -e tmux new-session -dsA $selected_name -c $selected
fi

kitty -e tmux switch-client -t $selected_name
