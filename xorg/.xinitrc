#!/bin/sh

# load X11 config
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# load custom config
if [ -d $HOME/.xinitrc.d ]; then
    for f in $HOME/.xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Disable beep
xset b off

# Set monitor timeout
xset -dpms
xset s off

# fix Java GUI rendering bugs (qtile sets the wmname itself)
mname Sawfish

# start the urxvt daemon
#urxvtd -q -f -o

# set wallpaper
if [ -f ~/.wallpaper ]; then
    feh --bg-fill ~/.wallpaper &
fi

# Initialize X's resource database
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# spawn compositing manager
compton &

# Removes mouse cursor if it did not move for 5 seconds
unclutter &

# Workaround: First execution of amixer might take a few second.
# Execute it here so that awesome, which also executes amixer, doesn't
# hang on startup.
amixer -M sget Master > /dev/null

# Autostart
dex -a &

# finally start a window manager
#exec qtile
exec awesome #-c /etc/xdg/awesome/rc.lua
#exec i3
