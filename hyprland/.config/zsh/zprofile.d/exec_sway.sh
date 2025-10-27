[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh \
    && mkdir -p "$XDG_DATA_HOME/hyprland" \
    && exec hyprland > "$XDG_DATA_HOME/hyprland/hyprland.log" 2> "$XDG_DATA_HOME/hyprland/hyprland.err.log"
