#!/bin/bash

# Layouts:
# 1 monitor: p
# 2 monitor: p e1
# 3 monitor: p e1 e2

# TODO: Consider that e1 might have to be right of e2 sometimes

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
    bspc desktop -r Desktop

    # Reorder
    bspc wm -O "$1" "%$PRIMARY_MONITOR"
}

function monitor_remove() {
    # # add temp desktop
    bspc monitor "%$1" -a Desktop

    # move all workspaces to primary
    for desktop in $(bspc query -D -m "%$1"); do
        bspc desktop "$desktop" --to-monitor "%$PRIMARY_MONITOR"
    done

    bspc monitor "%$1" -r
}

function nvidia_command() {
    monitor=$1
    res=$(get_monitor_resolution $monitor)

    echo "$monitor: nvidia-auto-select @${res}${2} {ViewPortIn=$res, ViewPortOut=$res+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
}

function assemble_nvidia_command() {
    cmd="nvidia-settings --assign \"CurrentMetaMode="
    cmd="$cmd$(nvidia_command $PRIMARY_MONITOR '$p_offset')"

    for i in ${!EXTERNAL_MONITORS[@]}; do
        cmd="$cmd, $(nvidia_command ${EXTERNAL_MONITORS[$i]} ${offsets[$i]})"
    done

    cmd="$cmd\""
    echo $cmd
}

function dock() {
    # Load layout from selected file
    n_monitors=$(get_num_monitors)
    layout=$1
    source ~/.config/bspwm/monitors/$layout
    echo "Using $description $tag"

    cmd=$(assemble_nvidia_command)
    eval $cmd

    # Move desktops to externals
    # for i in ${!EXTERNAL_MONITORS[@]}; do
    #     monitor_add ${EXTERNAL_MONITORS[$i]} ${per_ext[$i]}
    # done
}

function undock() {
    echo "Undocking"
    for i in ${!EXTERNAL_MONITORS[@]}; do
        monitor_remove ${EXTERNAL_MONITORS[$i]}
    done

    bspc monitor "%$PRIMARY_MONITOR" -d 1 2 3 4 5 6 7 8 9 10

    cmd="nvidia-settings --assign \"CurrentMetaMode="
    cmd="$cmd$(nvidia_command $PRIMARY_MONITOR '+0+0')"
    cmd="$cmd\""
    eval $cmd
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
            cmd="nvidia-settings --assign \"CurrentMetaMode=$(nvidia_command $PRIMARY_MONITOR)\""
            eval $cmd
            bspc monitor "%$PRIMARY_MONITOR" -d 1 2 3 4 5 6 7 8 9 10
            ;;

        "select")
            selected=$(find ~/.config/bspwm/monitors -printf '%f\n' -name '*.layout' \
                           | grep -e "^$N_MONITORS" -e "undocked" \
                           | sed 's/ /\n/g' \
                           | rofi -dmenu -p "Select monitor layout" -no-custom)

            echo "Selected $selected"

            case $selected in
                "undocked.layout") undock ;;
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

    feh --bg-scale $WALLPAPER --stretch
    ~/.config/eww/launch.sh
}

main $1
