#!/bin/bash
export FILETAGS=work

# customize these
WGET=wget
ICS2ORG=./ical2org.awk
ICSFILE=./test.ics
ORGFILE=./test.org
URL=https://cloud.timeedit.net/chalmers/web/public/ri6Y73QQZ65Zn1Q14853Q6Z75640y.ics

# no customization needed below

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
