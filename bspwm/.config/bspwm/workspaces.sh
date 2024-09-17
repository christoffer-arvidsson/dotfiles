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
module_padding=""


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
    workspaces=$(bspc query -D --names | sort -g)

    # Iterate over each workspace
    for workspace in $workspaces; do
        occupied=$(bspc query -D --names -d ".occupied" | grep "$workspace")
        focused=$(bspc query -D -d "$MONITOR:focused" --names | grep "$workspace")
        # Check if the workspace is focused
        if [[ "$workspace" == "$focused" ]]; then
            ws_fg=$ws_focused_fg
        # Check if the workspace is occupied (has windows)
        elif [[ "$workspace" == "$occupied" ]]; then
            ws_fg=$ws_occupied_fg
        # Free workspaces (unfocused and empty)
        else
            ws_fg=$ws_empty_fg
        fi

        ws_icon=$(get_ws_icon "$workspace")

        # Append each workspace with appropriate colors and padding
        if [ "$first" = true ]; then
            desktops+="%{F${ws_fg}}${module_padding}${ws_icon}${module_padding}%{F-} "
            first=false
        else
            desktops+="| %{F${ws_fg}}${module_padding}${ws_icon}${module_padding}%{F-} "
        fi
    done

    # Output the final result to be displayed on Polybar
    echo "$desktops"
}

# Continuously update the Polybar workspace module
while true; do
    echo_workspaces
    sleep 0.05
done
