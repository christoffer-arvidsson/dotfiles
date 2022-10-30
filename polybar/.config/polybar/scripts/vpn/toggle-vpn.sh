#!/bin/bash

VPN=$1

if [ -z "$VPN" ]
then
    exit 1
fi

ACTIVE=`nmcli con show --active | grep "$VPN"`

if [ -z "$ACTIVE" ]
then
    nmcli con up id "$VPN"
else
    nmcli con down id "$VPN"
fi

exit 0
