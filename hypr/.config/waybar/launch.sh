#!/usr/bin/env bash

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "ps aux | grep '[w]aybar$' | awk '{print \$2}' | xargs -r kill" EXIT

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    ps aux | grep '[w]aybar$' | awk '{print $2}' | xargs -r kill
done

