#!/bin/sh

# Make sure this is before the 'exec' comand or it won'b be sourced
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Escape -> Caps and set swedish keyboard
setxkbmap sv -option caps:swapescape

# Screen resolution
xrandr --output DVI-I-1 --scale 1.25x1.25
xrandr --output DVI-D-0 --scale 1.25x1.25

exec bspwm
