#!/usr/bin/env bash

killall polybar

if ! type "xrandr"; then
    polybar --reload main &
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
