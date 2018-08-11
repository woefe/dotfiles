maybe_source() {
    if test -r "$1"; then
        source "$1"
        return 0
    fi
    return 1
}

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
maybe_source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf keybindings and completion
maybe_source /usr/share/fzf/completion.zsh
maybe_source /usr/share/fzf/key-bindings.zsh

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
if test -r /usr/bin/virtualenvwrapper.sh; then
    export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
elif test -r /usr/share/virtualenvwrapper/virtualenvwrapper.sh; then
    export VIRTUALENVWRAPPER_SCRIPT=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi
maybe_source /usr/bin/virtualenvwrapper_lazy.sh || maybe_source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh

# vi-mode
#source $HOME/.zsh-plugins/vi-mode.plugin.zsh

#History settings
HISTSIZE=70000
SAVEHIST=70000
setopt append_history         # append history instead of replacing
setopt hist_expire_dups_first # when cleaning the history, remove duplicates first
setopt hist_ignore_dups       # ignore duplication command history list
setopt hist_ignore_space      # ignore commands that start with a space
setopt hist_verify            # don't execute command from history directly but edit it first
setopt share_history          # share history between simultaneously running shells

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

# Set $PATH
export PATH="$PATH:$HOME/.bin:$HOME/.local/bin:$HOME/.gem/ruby/2.5.0/bin"

# Prompt: git status and hostname for ssh sessions
prompt off
source ~/.zsh-plugins/zsh-git-prompt/git-prompt.zsh
if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
    PROMPT='%B%F{blue}@%m:%f%b %B%40<..<%~ %b$(gitprompt)%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
else
    PROMPT='%B%40<..<%~ %b$(gitprompt)%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
fi

# Setup default aliases
source ~/.aliases

# Gets the nth argument from the last command by pressing Alt+1, Alt+2, ... Alt+5
bindkey -s '\e1' "!:0-0 \t"
bindkey -s '\e2' "!:1-1 \t"
bindkey -s '\e3' "!:2-2 \t"
bindkey -s '\e4' "!:3-3 \t"
bindkey -s '\e5' "!:4-4 \t"

# prevent man from displaying lines wider than 120 characters
man(){
    MANWIDTH=120
    if (( $MANWIDTH > $COLUMNS )); then
        MANWIDTH=$COLUMNS
    fi
    MANWIDTH=$MANWIDTH /usr/bin/man $*
    unset MANWIDTH
}

ls-by-size(){
    du -hd1 $1 | sort -hr
}
