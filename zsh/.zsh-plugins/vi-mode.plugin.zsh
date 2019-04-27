# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  VI_KEYMAP=$KEYMAP

  zle reset-prompt
  zle -R
}

function zle-line-init() {
    zle -K viins;
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N edit-command-line


bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl+p, ctrl+n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl+h, ctrl+w, ctrl+? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# allow ctrl+a and ctrl+e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# alt+q to push current line and fetch again on next line
bindkey '\eq' push-line

# show man page of current command with alt+h
bindkey '\eh' run-help

# grml config overrides ctrl+r
bindkey -M vicmd '^r' redo


# This function is used in the prompt.
# For example:
#
#setopt PROMPT_SUBST
#PROMPT='$(vi_mode_status)'
function vi_mode_status() {
  local VI_NORMAL_MODE_INDICATOR='%(?.%F{blue}•%f%F{cyan}•%f%F{green}•%f.%F{red}•••%f) '
  local VI_INSERT_MODE_INDICATOR='%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
  if [[ "$VI_KEYMAP" == "vicmd" ]]; then
      echo "$VI_NORMAL_MODE_INDICATOR"
  else
      echo "$VI_INSERT_MODE_INDICATOR"
  fi
}
