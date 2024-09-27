#!/usr/bin/env bash

STATUS=$(playerctl --player=spotify status 2>/dev/null)

if [ "$STATUS" = "Stopped" ]; then
    echo ""
elif [ "$STATUS" = "Paused"  ]; then
    echo ""
elif [ "$STATUS" = "Playing" ]; then
    echo ""
else
    echo ""
fi
