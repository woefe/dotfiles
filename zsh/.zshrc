# grml zsh conf
source $HOME/.zsh-plugins/grml-zsh-conf

# Enable syntax highlighting
source $HOME/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable fish-shell like history searching
source $HOME/.zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Enable fish-shell like autosuggestion
source $HOME/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'

# command not found
source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf keybindings and completion
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# vi-mode
#source $HOME/.zsh-plugins/vi-mode.plugin.zsh

# Ctrl+P to edit current command with $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^P" edit-command-line

## bind UP and DOWN arrow keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

## bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Git prompt
prompt off
source $HOME/.zsh-plugins/zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE="haskell"
PROMPT='%B%F{red}%(?..%? )%f%b%B%40<..<%~ %b$(git_super_status)> '

# Enable fasd, a command-line productivity booster
eval "$(fasd --init auto)"

# Enable thefuck. Lazy loading thefuck improves the startup time by almost a second.
fuck() {
    eval $(thefuck --alias)
    eval $(whence fuck)
}

# Setup default aliases
source ~/.aliases

# Set $PATH
export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"

# Gets the nth argument from the last command by pressing Alt+1, Alt+2, ... Alt+5
bindkey -s '\e1' "!:0-0 \t"
bindkey -s '\e2' "!:1-1 \t"
bindkey -s '\e3' "!:2-2 \t"
bindkey -s '\e4' "!:3-3 \t"
bindkey -s '\e5' "!:4-4 \t"

o(){
    fasd -f -e xdg-open $* &
    disown
}

# prevent man from displaying lines wider than 120 characters
man(){
    MANWIDTH=120
    if (( $MANWIDTH > $COLUMNS )); then
        MANWIDTH=$COLUMNS
    fi
    MANWIDTH=$MANWIDTH /usr/bin/man $*
    unset MANWIDTH
}

# print a random string
random-string(){
    if [[ -n $1 ]] && [[ $1 -gt 0 ]]; then
        tr -dc "[:print:]" < /dev/urandom | head -c $1
        echo
    else
        echo -e "Usage:\n$0 <length>"
    fi
}

ls-by-size(){
    du -hd1 $1 | sort -hr
}

rename-date-exiv(){
    if [[ -f $1 ]]; then
        exiv2 rename $*
    else
        echo "Usage:"
        echo "$0 PICTURES"
        echo "Example: $0 Pictures/*.jpg"
    fi
}

