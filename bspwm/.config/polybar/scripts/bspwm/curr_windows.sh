#!/bin/sh

nodes=$(bspc query -N -n .window -d focused)
titles=$(xtitle $nodes)

current=$(bspc query -N -n focused)

echo $titles
