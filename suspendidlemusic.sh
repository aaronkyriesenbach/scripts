#!/usr/bin/zsh

# This script stops swayidle while music is playing and resumes it when the music stops. It does nothing if swayidle was stopped when the music started.

pgrep swayidle &> /dev/null && idle_was_running=true || idle_was_running=false

while true; do
    if [ $(playerctl status) = "Playing" ]; then
        if pgrep swayidle &> /dev/null; then
            idle_was_running=true
            echo "Detected music playing w/ swayidle running, stopping swayidle"
            systemctl --user stop swayidle
        fi
    else
        if $idle_was_running; then
            echo "Music stopped and swayidle was running when music started, starting swayidle"
            systemctl --user start swayidle
            idle_was_running=false
        fi
    fi
    sleep 0.1
done
