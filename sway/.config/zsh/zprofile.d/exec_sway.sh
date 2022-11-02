[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] \
    && eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)" \
    && export SSH_AUTH_SOCK \
    && export GRIM_DEFAULT_DIR="$HOME/pictures" \
    && export WLR_DRM_NO_MODIFIERS=1 \
    && export MOZ_ENABLE_WAYLAND=1 \
    && export QT_QPA_PLATFORM=wayland \
    && export QT_WAYLAND_DISABLE_WINDOWDECORATION="1" \
    && mkdir -p "$XDG_DATA_HOME/sway" \
    && exec sway > "$XDG_DATA_HOME/sway/sway.log" 2> "$XDG_DATA_HOME/sway/sway.err.log"
