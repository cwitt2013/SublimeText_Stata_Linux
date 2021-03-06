#!/bin/bash

# Packages: wmctrl, xdotool, xclip, xautomation
# e.g. Fedora: dnf install wmctrl xdotool xclip xautomation

# Copy 'do filename' to clipboard
string='do ''"'$1'"'
echo "${string}" | xclip -selection clipboard

# get current window id
winid=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')

# check for Stata window, if found active else execute
if [ "$(pgrep stata)" ]
then
  # Stata Flavor?
	wmctrl -a 'Stata/SE 14.2'
  test="1"
else
	# If not already open start it
  xstata-se
  test="2"
	sleep .1
fi

# swich to command line and select existing text via ctrl-a and paste clipboard
sleep .1
xdotool key --clearmodifiers --delay 50 ctrl+a ctrl+v Return
sleep .3

if [ "$test" -eq "2" ]
  then
  xdotool key --clearmodifiers Return
fi

# go back to editor window
wmctrl -i -a $winid
