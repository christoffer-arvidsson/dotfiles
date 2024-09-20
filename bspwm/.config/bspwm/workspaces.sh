#!/bin/bash

# Declare an associative array to map workspace indices to icons
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

function get_color {
    xrdb -query | grep "^$1" | awk '{print $2}'
}

# Define color variables for different workspace states
ws_focused_fg=$(get_color "highlight")
ws_occupied_fg="CAfff9e8"
ws_empty_fg=$(get_color "inactive")
ws_urgent_fg=$(get_color "alert")
module_padding=" "


# Function to get the icon for a given workspace index
get_ws_icon() {
    local ws_index=$1
    # Check if the index exists in the map, otherwise return the default icon
    echo "${ws_icon_map[$ws_index]:-${ws_icon_map[default]}}"
}

# Function to generate Polybar workspace display
echo_workspaces() {
    local desktops=""
    local ws_fg name
    local first=true

    # Get the list of workspace names and sort them numerically
    workspaces="1 2 3 4 5 6 7 8 9 10"

    # Iterate over each workspace
    for workspace in $workspaces; do
        occupied=$(bspc query -D --names -d ".occupied" | grep "^$workspace$")
        focused=$(bspc query -D -d "$MONITOR:focused" --names | grep "^$workspace$")
        urgent=$(bspc query -D -d ".urgent" --names | grep "^$workspace$")
        if [[ "$workspace" == "$urgent" ]]; then
            ws_fg=$ws_urgent_fg
        elif [[ "$workspace" == "$focused" ]]; then
            ws_fg=$ws_focused_fg
        elif [[ "$workspace" == "$occupied" ]]; then
            ws_fg=$ws_occupied_fg
        else
            ws_fg=$ws_empty_fg
        fi

        ws_icon=$(get_ws_icon "$workspace")

        # Append each workspace with appropriate colors and padding
        if [ "$first" = true ]; then
            first=false
        else
            desktops+="|"
        fi
        desktops+="%{F${ws_fg}}${module_padding}${ws_icon}${module_padding}%{F-}"
    done

    # Output the final result to be displayed on Polybar
    echo "$desktops"
}

# Continuously update the Polybar workspace module
while true; do
    echo_workspaces
    sleep 0.05
done
