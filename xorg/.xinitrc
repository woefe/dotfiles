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

# Set wallpaper(s) using feh.
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

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Blocking call to amixer. Speeds up polybar startup time and avoids that
# programs don't show up in the system tray
amixer > /dev/null

# finally start a window manager
exec i3
