[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx > ~/.startx.log 2> ~/.startx.err.log
