#!/usr/bin/env bash
set -euo pipefail

API="https://pdupc-pcmetrics.sero.wh.rnd.internal.ericsson.com/org/R_D_Operation/lsvAvailabilityInput/traffic_light.php"
STATUS=$(curl -s $API | jq -r '.traffic_light')

case "$STATUS" in
    "red")
        COLOR="%{F#E75D5D}"
        ;;
    "green")
        COLOR="%{F#8fc99f}"
        ;;
    "yellow")
        COLOR="%{F#78A1BB}"
        ;;
    *)
        COLOR="%{F#55BFA89E}"
        ;;
esac

echo "$COLOR"
