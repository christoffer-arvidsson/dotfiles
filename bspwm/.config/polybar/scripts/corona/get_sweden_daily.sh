#!/bin/sh

COUNTRY="SE"
API="https://corona-stats.online"
MINIMAL="true"
JSON="false"
SOURCE=2

aqi=$(curl -sf "$API/$COUNTRY?minimal=$MINIMAL&json=$JSON&source=$Source" | grep Sweden)
COLORLESS=$(sed 's/\x1b\[[0-9;]*m//g' <<< $aqi)

FIELDS=(${COLORLESS})
ACTIVE=${FIELDS[10]}
INCREASE=${FIELDS[4]}

if [ "$INCREASE" -gt 0 ]; then
    ICON="%{F#e60053}"
else
    ICON="%{F#4fb069}"
    INCREASE=$((INCREASE * -1))
fi

echo " $COUNTRY $ACTIVE ${ICON}${INCREASE}"
