#!/usr/bin/env bash

declare -A ws_icon_map=(
    ["1"]=""     # web
    ["2"]=""     # code
    ["3"]=""     # opt1
    ["4"]=""     # opt2
    ["5"]=""     # opt3
    ["6"]=""     # opt4
    ["7"]=""     # opt5
    ["8"]=""     # opt6
    ["9"]=""     # msg
    ["10"]=""     # music
    [default]=""  # default icon
)

get_ws_icon() {
    local ws_index=$1
    # Check if the index exists in the map, otherwise return the default icon
    echo "${ws_icon_map[$ws_index]:-${ws_icon_map[default]}}"
}

function get_workspaces_widget {
    workspaces="1 2 3 4 5 6 7 8 9 10"
    occupied=$(bspc query -D --names -d ".occupied")
    focused=$(bspc query -D --names -d ".focused")
    urgent=$(bspc query -D --names -d ".urgent")

    first=true
    buttons=""
    for workspace in $workspaces; do
        ws_occupied=$(bspc query -D --names -d ".occupied" | grep "^$workspace$")
        ws_focused=$(bspc query -D -d ".focused" --names | grep "^$workspace$")
        ws_urgent=$(bspc query -D -d ".urgent" --names | grep "^$workspace$")
        # echo "$workspace $ws_occupied $ws_focused $ws_urgent"

        if [[ "$workspace" == "$ws_urgent" ]]; then
            wc_class="urgent"
        elif [[ "$workspace" == "$ws_focused" ]]; then
            wc_class="focused"
        elif [[ "$workspace" == "$ws_occupied" ]]; then
            wc_class="occupied"
        else
            wc_class="empty"
        fi

        if [ "$first" = true ]; then
            first=false
        else
            # buttons+="'|'"  # eww does not center icons correctly, so including | here looks bad :(
            buttons+="''"
        fi
        buttons+="(button :onclick 'bspc desktop -f $workspace' :class '$wc_class' '$(get_ws_icon $workspace)')"

    done

    widget="(box :class 'workspaces' :spacing '2' :orientation 'h' :halign 'center' :space-evenly 'false' $buttons)"
    echo $widget
}

get_workspaces_widget
bspc subscribe all | while read -r _ ; do
get_workspaces_widget
done
