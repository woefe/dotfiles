#!/bin/sh

case "$1" in
    duplicate )
        PRIMARY="eDP-1"
        MIRROR="$(xrandr -q | grep ' connected' | grep -v $PRIMARY | cut -d' ' -f1)"
        xrandr --output "$PRIMARY" --primary --mode 1920x1080 --pos 0x0 --output "$MIRROR" --mode 1920x1080 --pos 0x0
        ;;
    above )
        xrandr --output DP-1 --auto --above eDP-1 --output DP-2 --auto --above eDP-1
        ;;
    reset )
        xrandr --output eDP-1 --primary --mode 1920x1080 --output DP-1 --off --output DP-2 --off
        ;;
esac
