#!/usr/bin/env bash

###########################################
# README ##################################
# CHANGE THE PATH TO YOUR OWN ROM FOLDER (lines 13 and 18)
###########################################

######################
# functions
######################

function romList() {
  cd  /mnt/media/games/roms/N64/
  ls  *.*64
}

function startGame() {
  mupen64plus /mnt/media/games/roms/N64/"$1"
}


##############################
# script execution starts here
##############################
LAUNCHER="rofi -dmenu -i -p"
romFileName=$(romList | $LAUNCHER 'Select game:')
if [ -z "$romFileName" ]; then
    exit 1
fi
startGame "$romFileName"
exit 1

