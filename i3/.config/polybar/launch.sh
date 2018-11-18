#!/usr/bin/env bash

# Launches the `mirrored` configuration if two monitors are connected which have the same resolution and position.
# Otherwise, launches the `primary` bar on the primary monitor and the `secondary` bar on all secondary monitors.

killall polybar

if ! type "xrandr"; then
    polybar --reload primary &
    exit 0
fi

readarray -t mirrors < <(xrandr --query | grep " connected" | grep -Eo '[0-9]+x[0-9]+\+[0-9]+\+[0-9]')
if (( ${#mirrors[@]} == 2 )) && [[ "${mirrors[0]}" != "" && "${mirrors[1]}" == "${mirrors[1]}" ]]; then
    polybar --reload mirrored &
    exit 0
fi

primary_monitor=$(xrandr --query | grep " connected primary" | cut -d" "  -f1)
secondary_monitors=$(xrandr --query | grep " connected" | grep -v " primary" | cut -d" "  -f1)

if [ -n "${primary_monitor}" ]; then
    MONITOR=${primary_monitor} polybar --reload primary &
fi

for m in $secondary_monitors; do
    MONITOR=$m polybar --reload secondary &
done
