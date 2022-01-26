#!/bin/sh

LAPTOP="eDP-1"
DOCK_PORTRAIT="DP-2-2"
DOCK_LANDSCAPE="DP-2-1"

case "$1" in
    mirror )
        MIRROR="$(xrandr -q | grep ' connected' | grep -v "$LAPTOP" | cut -d' ' -f1)"
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 0x0 --output "$MIRROR" --mode 1920x1080 --pos 0x0
        ;;
    dock )
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --pos 1440x1440 --rotate normal --output "$DOCK_PORTRAIT" --mode 2560x1440 --pos 0x0 --rotate left --output "$DOCK_LANDSCAPE" --mode 2560x1440 --pos 1440x0 --rotate normal
        ;;
    above )
        xrandr --output DP-1 --auto --above "$LAPTOP" --output DP-2 --auto --above "$LAPTOP"
        ;;
    reset )
        xrandr --output "$LAPTOP" --primary --mode 1920x1080 --output DP-1 --off --output DP-2 --off --output "$DOCK_LANDSCAPE" --off --output "$DOCK_PORTRAIT" --off
        ;;
esac

"$XDG_CONFIG_HOME/polybar/launch.sh"
