#!/usr/bin/env bash

options=("~/.config/null_emacs")
names=("null")
selected_idx=$(echo -e $names | rofi -dmenu -format "i" -p "Emacs profile" -no-custom)
selected=${options[$selected_idx]}
name=${names[$selected_idx]}

~/.config/scripts/emacs_server.sh -s $selected -n $name
