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

# fix Java GUI rendering bugs
wmname Sawfish

# start the urxvt daemon
#urxvtd -q -f -o

# set wallpaper
#feh --bg-fill Pictures/wallpaper/makepkgnotwarpaisley.png &

# Initialize X's resource database
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# spawn compositing manager
compton &

# Removes mouse cursor if it did not move for 5 seconds
unclutter &

# Start the rofi launcher
#rofi -key-run SuperL+p -key-ssh SuperL+i -key-window SuperL+o &

# Autostart
(sleep 2 && dex -a)&

# finally start a window manager
exec awesome #-c /etc/xdg/awesome/rc.lua
#exec i3
