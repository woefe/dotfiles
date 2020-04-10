#!/bin/sh

LAPTOP="eDP-1"
DOCK_LARGE="DP-2-2"
DOCK_SMALL="DP-2-1"

case "$1" in
    mirror )
        MIRROR="$(xrandr -q | grep ' connected' | grep -v "$LAPTOP" | cut -d' ' -f1)"
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 0x0 --output "$MIRROR" --mode 1920x1080 --pos 0x0
        ;;
    dock )
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 1080x1440 --rotate normal --output "$DOCK_SMALL" --mode 1920x1080 --pos 0x0 --rotate left --output "$DOCK_LARGE" --mode 2560x1440 --pos 1080x0 --rotate normal
        ;;
    above )
        xrandr --output DP-1 --auto --above "$LAPTOP" --output DP-2 --auto --above "$LAPTOP"
        ;;
    reset )
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --output DP-1 --off --output DP-2 --off --output "$DOCK_SMALL" --off --output "$DOCK_LARGE" --off
        ;;
esac

"$XDG_CONFIG_HOME/polybar/launch.sh"
