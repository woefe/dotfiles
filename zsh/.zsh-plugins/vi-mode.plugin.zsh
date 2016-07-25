# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
    # The terminal must be in application mode when ZLE is active for $terminfo
    # values to be valid.
    if (( ${+terminfo[smkx]} )); then
        printf '%s' ${terminfo[smkx]}
    fi
    if (( ${+terminfo[rmkx]} )); then
        printf '%s' ${terminfo[rmkx]}
    fi

    INSERT_MODE_INDICATOR="%{$fg_bold[green]%}-- INSERT --%{$reset_color%}"
    NORMAL_MODE_INDICATOR="%{$fg_bold[red]%}%{$fg[red]%}-- NORMAL --%{$reset_color%}"

    RPS1="${${KEYMAP/vicmd/$NORMAL_MODE_INDICATOR}/(main|viins)/$INSERT_MODE_INDICATOR}"

    zle reset-prompt
    zle -R
}

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
    zle && { zle reset-prompt; zle -R }
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line


bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# if mode indicator wasn't setup by theme, define default
if [[ "$NORMAL_MODE_INDICATOR" == "" ]]; then
    NORMAL_MODE_INDICATOR="%{$fg_bold[red]%}%{$fg[red]%}-- NORMAL --%{$reset_color%}"
fi
if [[ "$INSERT_MODE_INDICATOR" == "" ]]; then
    INSERT_MODE_INDICATOR="%{$fg_bold[green]%}-- INSERT --%{$reset_color%}"
fi

function vi_mode_prompt_info() {
    echo "${${KEYMAP/vicmd/$NORMAL_MODE_INDICATOR}/(main|viins)/$INSERT_MODE_INDICATOR}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
    RPS1='$(vi_mode_prompt_info)'
fi
