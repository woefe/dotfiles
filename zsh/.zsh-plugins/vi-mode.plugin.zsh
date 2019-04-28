# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  VI_KEYMAP=$KEYMAP

  # change cursor depending on mode.
  # Block cursor in "normal" mode, Beam in insert mode.
  if [[ "$VI_KEYMAP" == "vicmd" ]]; then
      echo -ne '\e[1 q'
  else
      echo -ne '\e[5 q'
  fi

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

# Reduce esc delay
export KEYTIMEOUT=1

# This function is used in the prompt.
# For example:
#
#setopt PROMPT_SUBST
#PROMPT='$(vi_mode_status)'
function vi_mode_status() {
  local normal_mode_indicator='%(?.%F{blue}•%f%F{cyan}•%f%F{green}•%f.%F{red}•••%f) '
  local insert_mode_indicator='%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
  if [[ "$VI_KEYMAP" == "vicmd" ]]; then
      echo "$normal_mode_indicator"
  else
      echo "$insert_mode_indicator"
  fi
}
