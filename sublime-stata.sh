#!/bin/bash

# Packages: wmctrl, xdotool, xautomation
# e.g. Fedora: dnf install wmctrl xdotool xautomation

# get current window id
winid=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')

# check for Stata window, if found active else execute
if [ "$(pgrep stata)" ]
then
  # Stata Flavor?
	wmctrl -a 'Stata/SE 14.2'
else
	# If not already open start it
  xstata-se
	sleep .1
fi

# delay depends on window manager etc
# .1 ok with xmonad in 10.04
sleep .1

# swich to command line and select existing text via ctrl-a
xte 'keydown Control_L' 'key 1' 'key A' 'usleep 100' 'key BackSpace' 'usleep 100' 'keyup Control_L'
sleep .1
# Enter do command
setxkbmap de
string='do ''"'$1'/sublime2stata.do''"'
xdotool type --delay 1 "${string}"
sleep .1
# Execute
xte 'key Return'
sleep .3

# go back to editor window
wmctrl -i -a $winid
