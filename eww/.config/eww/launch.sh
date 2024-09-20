#!/usr/bin/env bash

# Wait until the processes have been shut down
while pgrep -u $(id -u) -x eww >/dev/null
do
    killall eww
    sleep 0.1
done

# determine if this is a laptop
acpi | grep Battery > /dev/null 2> /dev/null
is_laptop=$?

xrandr | grep ' connected' | while read -r line
do
    if [[ $line = *' primary '* ]]
    then
        if [ $is_laptop -eq 0 ]
        then
            bar="work-topbar"
        else
            bar="station-topbar"
        fi

    else
        bar="external"
    fi

    monitor=$(echo $line | awk '{print $1}')

    # Give bspwm time to set the monitors
    echo "$monitor $bar"
    eww open --screen $monitor "${bar}" > /tmp/eww.log 2>&1 &
done

echo "Bars launched..."
