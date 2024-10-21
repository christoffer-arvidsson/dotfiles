#!/usr/bin/env bash

# Layouts:
# 1 monitor: p
# 2 monitor: p e1
# 3 monitor: p e1 e2

# TODO: Consider that e1 might have to be right of e2 sometimes

set -x

function get_num_monitors {
    xrandr | grep ' connected' | wc -l
}

function get_monitor_resolution {
    xrandr --query | grep -A 1 $1 | grep -v connected | awk '{ print $1 }'
}

function monitor_add() {
    # move workspaces
    to_move=${@:2}
    for desktop in $to_move; do
        echo $desktop
        bspc desktop "$desktop" --to-monitor "%$1"
    done

    # # remove default desktop
    bspc desktop -r temp

    # Reorder
    bspc wm -O "$1" "%$PRIMARY_MONITOR"
}

function monitor_remove() {
    # # add temp desktop
    bspc monitor "%$1" -a temp

    # move all workspaces to primary
    for desktop in $(bspc query -D -m "%$1"); do
        bspc desktop "$desktop" --to-monitor "%$PRIMARY_MONITOR"
    done

    bspc monitor "%$1" -r
}

function set_xrandr() {
    res=$(get_monitor_resolution "$PRIMARY_MONITOR")
    cmd="xrandr --output "$PRIMARY_MONITOR" --mode "${res}" --primary --pos $p_offset --scale $p_scale --filter nearest"

    for i in ${!EXTERNAL_MONITORS[@]}; do
        monitor="${EXTERNAL_MONITORS[$i]}"
        res=$(get_monitor_resolution "$monitor")

        # if [ $i -lt ${#offsets[@]} ] && [ $i -lt ${#scales[@]} ]; then
            # Valid index, set the external monitor with resolution, offsets, and scales
            cmd="$cmd --output "$monitor" --mode "${res}" --pos ${offsets[$i]} --scale ${scales[$i]} --filter nearest"
        # else
        #     # Out of bounds, turn off the monitor
        #     cmd="$cmd --output "$monitor" --off"
        # fi
    done

    eval $cmd
}

function dock() {
    # Load layout from selected file
    n_monitors=$(get_num_monitors)
    layout=$1
    source ~/.config/bspwm/monitors/$layout
    echo "Using $description $tag"

    set_xrandr
}

function undock() {
    echo "Undocking"
    layout=$1
    source ~/.config/bspwm/monitors/undocked.layout

    for i in ${!EXTERNAL_MONITORS[@]}; do
        monitor_remove ${EXTERNAL_MONITORS[$i]}
    done

    set_xrandr

}

function main() {
    N_MONITORS=$(get_num_monitors)
    PRIMARY_MONITOR=$(xrandr | grep " connected primary" | awk '{ print $1 }')
    EXTERNAL_MONITORS=($(xrandr -q | grep " connected" | grep -v "primary" | awk '{ print $1 }'))

    echo "Num monitors: $N_MONITORS"
    echo "Found primary monitor: $PRIMARY_MONITOR $(get_monitor_resolution $PRIMARY_MONITOR)"
    echo "Externals: ${EXTERNAL_MONITORS[*]}"

    case "$1" in
        "startup")
            xrandr --output $PRIMARY_MONITOR --primary
            bspc monitor "%$PRIMARY_MONITOR" -d 1 2 3 4 5 6 7 8 9 10
            ;;

        "select")
            selected=$(find ~/.config/bspwm/monitors -printf '%f\n' -name '*.layout' \
                           | grep -e "^$N_MONITORS" -e "undocked" \
                           | sed 's/ /\n/g' \
                           | rofi -dmenu -p "Select monitor layout" -no-custom)

            echo "Selected $selected"

            case $selected in
                "undocked.layout")
                    undock ;;
                "")
                    echo "cancelled"
                    exit 0
                    ;;
                *)
                    undock
                    dock $selected ;;
            esac
            ;;

        *)
            dock $1
            ;;
    esac

    sleep 1
    ~/.config/polybar/scripts/launch.sh
    feh --bg-scale "$HOME/.dotfiles/.img/space.jpg"  --stretch
}

main $1
