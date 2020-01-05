#!/bin/sh

name=`bluetoothctl info | grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`
connected=`bluetoothctl info | grep "Connected" | sed 's/^.*: //'`
paired=`bluetoothctl paired-devices | grep "Device"`

read -ra ARR <<< "$paired"

if [ "$onoff" = "off" ]
then
    `bluetoothctl power on`
fi

if [ "$connected" == "yes" ]
then
    `bluetoothctl disconnect`
else
    `bluetoothctl connect ${ARR[1]}`
fi
