#!/bin/bash

# needs wmctrl xte and xsel
# dnf install wmctrl xdotool xautomation
# to get them run

# get current window id
winid=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')

# check for stata window, if found active else execute
if [ "$(pgrep stata)" ]
then
	wmctrl -a 'Stata/SE 14.2'
else
	#xstata-se &
        xstata-se
	sleep .1
fi

# delay depends on window manager etc
# .1 ok with xmonad in 10.04
sleep .1

# swich to command line and select existing text via ctrl-a
xte 'keydown Control_L' 'key 1' 'key A' 'usleep 100' 'key BackSpace' 'usleep 100' 'keyup Control_L'
sleep .1
setxkbmap de
string="do $1/sublime2stata.do"
xdotool type --delay 1 "${string}"
sleep .1
xte 'key Return'
sleep .3

# go back to editor window
wmctrl -i -a $winid
