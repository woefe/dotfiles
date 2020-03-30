[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && mkdir -p $XDG_DATA_HOME/xorg \
    && exec startx "$XINITRC" -- "$XSERVERRC" > $XDG_DATA_HOME/xorg/startx.log 2> $XDG_DATA_HOME/xorg/startx.err.log
