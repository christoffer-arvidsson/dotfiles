#!/usr/bin/env sh

IFACE=$(ip addr | grep ppp0: | awk '{print $2}')

get_color () {
    xrdb -query | grep "^$1" | awk '{print $2}'
}

color_alert=$(get_color "alert")
color_positive=$(get_color "positive")

if [ "$IFACE" = "ppp0:" ]; then
    _ip=$(ip addr show $IFACE | grep "inet " | awk '{print $2}' | cut -f2 -d ':' | cut -c -13)
    echo "%{F$color_positive} vpn%{u-}"
else
    echo "%{F$color_alert} vpn%{u-}"
fi
