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

# enable vi keymap
bindkey -v

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
