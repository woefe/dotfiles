#!/usr/bin/env bash

# load X11 config
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && source "$f"
    done
    unset f
fi

# load custom config
if [ -d "$HOME/.xinitrc.d" ]; then
    for f in $HOME/.xinitrc.d/?* ; do
        [ -x "$f" ] && source "$f"
    done
    unset f
fi

# Disable beep
xset b off

# Set monitor timeout
xset -dpms
xset s off

# Fix Java GUI rendering bugs (qtile sets the wmname itself)
#wmname Sawfish

# Start the urxvt daemon
#urxvtd -q -f -o

# Set wallpaper using feh
# Different wallpapers on a multi monitor setup can be set via:
# feh --bg-fill path/1.png --bg-fill path/2.png
if [ -x ~/.fehbg ]; then
    ~/.fehbg
elif [ -f ~/.wallpapers/wallpaper ]; then
    feh --bg-fill ~/.wallpapers/wallpaper &
fi

# Initialize X's resource database
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# spawn compositing manager
compton &

# Removes mouse cursor if it did not move for 5 seconds
unclutter &

# Synchronize all clipboards
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# Greenclip clipboard manager
greenclip daemon &

# Workaround: First execution of amixer might take a few second.
# Execute it here so that awesome, which also executes amixer, doesn't
# hang on startup.
#amixer -M sget Master > /dev/null

# Autostart; wait until polybar is available, otherwise systray icons do not show up
(while ! pgrep -u $UID -x polybar >/dev/null; do sleep 1; done; dex -a) &

# finally start a window manager
#exec qtile
#exec awesome #-c /etc/xdg/awesome/rc.lua
exec i3
