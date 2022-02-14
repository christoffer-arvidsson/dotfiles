#!/bin/sh

name=`bluetoothctl info | grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`

if [ $onoff = "yes" ]
then
    if [ ! "$name" ]
    then
        echo "on"
    else
        level=`~/.config/polybar/scripts/bluetooth/battery_level/bluetooth_battery.py $(bluetoothctl info | awk '/^Device/ {print $2}')`
        level=`echo ${level} | awk '{print $6}'`
        echo "${name} [${level}]"
    fi
else
    echo ""
fi
