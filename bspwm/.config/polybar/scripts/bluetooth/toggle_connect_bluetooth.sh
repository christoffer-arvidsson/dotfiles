#!/bin/sh

name=`bluetoothctl info | grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`
connected=`bluetoothctl info | grep "Connected" | sed 's/^.*: //'`
paired=`bluetoothctl paired-devices | grep "Device"`
controllers=`bluetoothctl list`

read -ra DEV <<< "$paired"
read -ra CON <<< "$controllers"

if [ $onoff == "no" ]
then
    bluetoothctl power on
fi

if [ "$connected" == "yes" ]
then
    bluetoothctl disconnect
else
    bluetoothctl connect ${ARR[1]}
fi
