[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh \
    && export MOZ_ENABLE_WAYLAND=1 \
    && export QT_QPA_PLATFORM=wayland \
    && export QT_WAYLAND_DISABLE_WINDOWDECORATION="1" \
    && mkdir -p "$XDG_DATA_HOME/hyprland" \
    && exec hyprland > "$XDG_DATA_HOME/hyprland/hyprland.log" 2> "$XDG_DATA_HOME/hyprland/hyprland.err.log"
