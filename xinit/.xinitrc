#!/bin/sh

# Make sure this is before the 'exec' comand or it won'b be sourced
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Escape -> Caps and set swedish keyboard
setxkbmap se -option caps:swapescape

# Screen resolution
xrandr --output eDP1 --auto

~/.fehbg &
exec bspwm
