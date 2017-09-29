source ~/.environment

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
source /usr/bin/virtualenvwrapper_lazy.sh

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# Don't set $PATH here!! Weird behaviour in Arch Linux
# https://wiki.archlinux.org/index.php/Zsh#Global_configuration_files
#export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"

