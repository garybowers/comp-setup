#!/usr/bin/env bash

if grep open /proc/acpi/button/lid/LID/state; then
	hyprctl dispatch dpms on
	hyprctl keyword monitor "eDP-1,preffered,auto,1"
else
	if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
		echo "More than one monitor"
		hyprctl keyword monitor "eDP-1, disable"
	fi
fi
