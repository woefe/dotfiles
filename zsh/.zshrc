#{{{ Base config, Plugins, modules, programs config
source $HOME/.aliases
source $HOME/.environment
source $HOME/.zsh-plugins/wbase.zsh

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export VIRTUAL_ENV_DISABLE_PROMPT=1  # Tell virtualenv to leave my prompt alone
maybe_source /usr/bin/virtualenvwrapper_lazy.sh \
    || maybe_source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh \
    || maybe_source "$(which virtualenvwrapper_lazy.sh)"

# Some useful zsh modules
zmodload -i zsh/parameter # access to internal hash tables like builtins, commands, functions
zmodload -i zsh/mathfunc  # Math functions like sin or sqrt

# vi-mode
source $HOME/.zsh-plugins/vi-mode.plugin.zsh  # To disable vi mode, comment out this line and uncomment the lines below.
#bindkey -e
#function vi_mode_status() {
#    echo "%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) "
#}

# Enable fish-shell like autosuggestion
source $HOME/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

# command not found
maybe_source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf keybindings and completion
if check_prog fzf; then
    source $HOME/.zsh-plugins/fzf/completion.zsh
    source $HOME/.zsh-plugins/fzf/key-bindings.zsh
fi

# Enable syntax highlighting. Must be loaded after all `zle -N` calls (see
# https://github.com/zsh-users/zsh-syntax-highlighting#faq)
source $HOME/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# Enable fish-shell like history searching. Must be loaded after zsh-syntax-highlighting.
source $HOME/.zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
#}}}

#{{{ Prompt
# Prompt: git status, hostname for ssh sessions, vi mode indicator
source $HOME/.zsh-plugins/zsh-git-prompt/git-prompt.zsh

# Set $psvar[12] to the current Python virtualenv
function _prompt_update_venv() {
    psvar[12]=
    if [[ -n $VIRTUAL_ENV ]] && [[ -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
        psvar[12]="${VIRTUAL_ENV:t}"
    fi
}

add-zsh-hook precmd _prompt_update_venv

# Draw a newline between every prompt
function _prompt_newline(){
    if [[ -z "$_PROMPT_NEWLINE" ]]; then
        _PROMPT_NEWLINE=1
    elif [[ -n "$_PROMPT_NEWLINE" ]]; then
        echo
    fi
}
add-zsh-hook precmd _prompt_newline

# To avoid glitching with fzf's alt+c binding we override the fzf-redraw-prompt widget.
# The widget by default reruns all precmd hooks, which prints the newline again.
# We unset _PROMPT_NEWLINE before running the widget to avoid this.
# We therefore run all precmd hooks except _prompt_newline.
function fzf-redraw-prompt() {
    local precmd
    for precmd in ${precmd_functions:#_prompt_newline}; do
        $precmd
    done
    zle reset-prompt
}

ZSH_GIT_PROMPT_FORCE_BLANK=1
ZSH_THEME_GIT_PROMPT_PREFIX=" · "
ZSH_THEME_GIT_PROMPT_SUFFIX="›"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" ‹"
ZSH_THEME_GIT_PROMPT_BRANCH="⎇ %{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_DETACHED="@%{$fg_no_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_no_bold[blue]%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[blue]%}↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

PROMPT=$'┏╸'
[ -n "$SSH_CLIENT" ] \
    && [ -n "$SSH_TTY" ] \
    && PROMPT+='%B%F{blue}@%m:%f%b · '  # Hostname, if in SSH session
PROMPT+='%B%30<..<%~%b%<<'              # Path truncated to 30 characters
PROMPT+='%(12V. · %F{244} %12v%f.)'    # Python virtualenv name
PROMPT+='$(gitprompt)'                  # Git status
PROMPT+=$'\n┗╸'                         # Newline
PROMPT+='$(vi_mode_status)'             # Vi mode indicator
#}}}

#{{{ Keybindings
# substring search plugin
bindkey -M main '^[[A' history-substring-search-up
bindkey -M main '^[[B' history-substring-search-down
bindkey -M vicmd '^k' history-substring-search-up
bindkey -M vicmd '^j' history-substring-search-down
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down

# autosuggest plugin
bindkey '^ ' autosuggest-accept
bindkey '^f' autosuggest-accept

# edit-command-line module
bindkey -M vicmd 'V' edit-command-line
#}}}

# vim:foldmethod=marker
