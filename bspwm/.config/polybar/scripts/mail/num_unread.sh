#!/usr/bin/env bash
set -euo pipefail

NUM_UNREAD=$(mu msgs-count --query='flag:unread')

# echo "No unread mails"
if [ "$NUM_UNREAD" = "0" ]; then
    echo "%{F#55BFA89E}"
else
    echo "%{F#E75D5D} %{F#CAfff9e8}$NUM_UNREAD"
fi
