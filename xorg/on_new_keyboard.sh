#!/usr/bin/env bash

# This will script will detect keyboard connect events and set the rate.
set -euo pipefail

echo >&2 "$@"
event=$1 id=$2 type=$3

case "$event $type" in
'XIDeviceEnabled XISlaveKeyboard')
        xset r rate 250 100
        setxkbmap us altgr-intl
esac
