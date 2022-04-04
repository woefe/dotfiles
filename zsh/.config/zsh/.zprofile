[[ -z $DISPLAY && $XDG_VTNR -eq 2 ]] \
    && mkdir -p $XDG_DATA_HOME/xorg \
    && exec startx "$XINITRC" -- "$XSERVERRC" > $XDG_DATA_HOME/xorg/startx.log 2> $XDG_DATA_HOME/xorg/startx.err.log

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && export WLR_DRM_NO_MODIFIERS=1 \
    && mkdir -p $XDG_DATA_HOME/sway \
    && exec sway > $XDG_DATA_HOME/sway/sway.log 2> $XDG_DATA_HOME/sway/sway.err.log
