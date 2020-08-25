#!/bin/sh


IFACE=$(ip addr | grep tun0 | awk '{print $1}')

if [ "$IFACE" = "tun0:" ]; then
    echo " %{F#4fb069} $(ifconfig tun0 | grep inet | awk '{print $2}' | cut -f2 -d ':')%{u-}"
else
    echo "%{F#E75D5D} no vpn"
fi
