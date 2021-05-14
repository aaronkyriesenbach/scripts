#!/usr/bin/zsh

while true; do
    echo $(playerctl metadata --format "$( [ $(playerctl status) = Playing ] && echo ▶ || echo ⏸) {{artist}} - {{title}}")
    sleep 0.1
done
