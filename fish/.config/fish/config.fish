alias ...='cd ../..'
alias cdt='cd /tmp'
alias cpstat='rsync -haP'
alias datea='date +%F'
alias g='git'
alias grep='grep --color=auto'
alias ip='ip -c'
alias lah='ls -lah'
alias l='ls'
alias mkqrcode='qrencode -t ansiutf8 -o -'
alias pacclean='sudo bash -c "paccache -vr && paccache -vruk0"'
alias pacu='sudo pacman -Syu'
alias :q='exit'
alias rm='trash'
alias ssh-public-key='cat ~/.ssh/id_rsa.pub'
alias T='urxvt &'
alias vim='nvim'
alias whoneeds='pacman -Qi'

eval (thefuck --alias | tr '\n' ';')

set --export --global EDITOR 'nvim'
set --export --global BROWSER 'firefox'
set --export --global _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
set --export --global QT_STYLE_OVERRIDE 'GTK+'

# Colorscheme
set fish_color_autosuggestion white
set fish_color_command blue --bold
set fish_color_comment white
set fish_color_cwd black --bold
set fish_color_cwd_root red
set fish_color_end green
set fish_color_escape cyan
set fish_color_history_current cyan
set fish_color_host -o cyan
set fish_color_match cyan
set fish_color_normal normal
set fish_color_operator cyan
set fish_color_param black
set fish_color_quote green
set fish_color_redirection brown
set fish_color_search_match --background=white
set fish_color_status red
set fish_color_user -o green
set fish_color_valid_path --underline
set fish_color_error red --bold

# Colored manpages
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1
set -g __fish_git_prompt_color_branch magenta --bold
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red --bold
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green --bold

set -g fish_color_cwd black --bold

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    if not test $last_status -eq 0
        set_color $fish_color_error
        printf "%s " $last_status
        set_color normal
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    # PWD
    set_color $fish_color_cwd
    printf (prompt_pwd)
    set_color normal

    printf '%s ' (__fish_git_prompt)

    echo -n '> '
end


# fasd hook into fish preexec event
function __fasd_run -e fish_preexec
    command fasd --proc (command fasd --sanitize "$argv") > "/dev/null" 2>&1 &
end

function fasd_cd
    if test (count $argv) -le 1
        fasd "$argv"
    else
        set _fasd_ret (fasd -e 'printf %s' $argv)
        test -z "$_fasd_ret"; and return
        test -d "$_fasd_ret"; and cd "$_fasd_ret"; or printf "%s\n" "$_fasd_ret"
    end
end

# fasd aliases
function a; command fasd -a $argv; end
function s; command fasd -si $argv; end
function d; command fasd -d $argv; end
function f; command fasd -f $argv; end
function e; command fasd -e $EDITOR $argv;end
function sd; command fasd -sid $argv; end
function sf; command fasd -sif $argv; end
function z; fasd_cd -d $argv; end
function zz; fasd_cd -di $argv; end

function reset-kbd
    ~/.xinitrc.d/keyboard_settings
end

# prevent man from displaying lines wider than 120 characters
function man
    set man_cmd (command -s man)
    set MANWIDTH 120
    if test $MANWIDTH -gt $COLUMNS
        set MANWIDTH $COLUMNS
    end
    env MANWIDTH=$MANWIDTH $man_cmd $argv
end

function random-string
    if test -n "$argv" -a $argv[1] -gt 0
        tr -dc "[:print:]" < /dev/urandom  | head -c $argv[1]
        echo
    else
        echo -e "Usage:\nrandom-string <length>"
    end
end

function rename-date-exiv
    if test (count $argv) -gt 0
        exiv2 rename $argv
    else
        echo "Usage:"
        echo "raname-date-exiv PICTURES"
        echo "Example: raname-date-exiv Pictures/*.jpg"
    end
end

# start X at login
if status --is-login
    set PATH $PATH ~/.bin
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty -nolisten tcp > ~/.startx.log ^&1
    end
end

function fish_greeting
    #sysinfo --short
end

