#!/usr/bin/zsh

percentage=$(acpi -b | grep -oP "[0-9]+(?=%)")

if [ $percentage -le 21 ]; then
	notify-send "$(( percentage + 1 ))% battery remaining"
fi
