#!/usr/bin/env bash

options=("doom\nnondoom")
selected=$(echo -e $options | rofi -dmenu -p "Emacs profile")

emacs --with-profile $selected --daemon=$selected
