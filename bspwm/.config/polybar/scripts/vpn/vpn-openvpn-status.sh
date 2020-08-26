#!/bin/sh


IFACE=$(ip addr | grep tun0: | awk '{print $2}')

if [ "$IFACE" = "tun0:" ]; then
    echo " %{F#4fb069} $(ip addr show tun0 | grep inet | awk '{print $2}' | cut -f2 -d ':' | cut -c -12)%{u-}"
else
    echo "%{F#E75D5D} no vpn"
fi
