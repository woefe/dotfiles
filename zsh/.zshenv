source ~/.environment

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# Don't set $PATH here!! Weird behaviour in Arch Linux
# https://wiki.archlinux.org/index.php/Zsh#Global_configuration_files
#export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"

