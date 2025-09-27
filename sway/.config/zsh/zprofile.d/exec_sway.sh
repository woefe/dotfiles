[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh \
    && export GRIM_DEFAULT_DIR="$HOME/pictures" \
    && export MOZ_ENABLE_WAYLAND=1 \
    && export QT_QPA_PLATFORM=wayland \
    && export QT_WAYLAND_DISABLE_WINDOWDECORATION="1" \
    && mkdir -p "$XDG_DATA_HOME/sway" \
    && exec sway > "$XDG_DATA_HOME/sway/sway.log" 2> "$XDG_DATA_HOME/sway/sway.err.log"
