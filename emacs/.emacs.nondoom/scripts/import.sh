#!/bin/bash
export FILETAGS=work

# customize these
WGET=wget
ICS2ORG=./ical2org.awk
ICSFILE=./test.ics
ORGFILE=./test.org
URL=https://outlook.office365.com/owa/calendar/f63aaf79ff554ae79b80595a576995f8@zenseact.com/c9dc46005e094eaa8dd2425b0e678be1389213827165747739/calendar.ics

# no customization needed below

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
