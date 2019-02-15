#!/usr/bin/env bash

###################### Boilerplate and preparation ######################
function check_prog() {
    if ! hash "$1" > /dev/null 2>&1; then
        echo "Command not found: $1. Aborting..."
        exit 1
    fi
}

check_prog stow
check_prog curl

mkdir -p "$HOME/.config"
#########################################################################



############################# How to use it #############################
#                                                                       #
# Uncomment the lines of the configs you want to install below.         #
# Then run this script from within the dotfiles directory.              #
# E.g. `cd ~/.dotfiles; ./install.sh`                                   #
#                                                                       #
# To uninstall the config later, run stow -D in the dotfiles directory. #
# E.g. `cd ~/.dotfiles; stow -D vim`                                    #
#                                                                       #
#########################################################################

#stow --target "$HOME"              alacritty
#stow --target "$HOME" --no-folding autostart
#stow --target "$HOME"              compton
#stow --target "$HOME"              dunst
#stow --target "$HOME"              environment
#stow --target "$HOME" --no-folding fish
#stow --target "$HOME"              greenclip
#stow --target "$HOME"              i3
#stow --target "$HOME" --no-folding moc
#stow --target "$HOME" --no-folding ranger
#stow --target "$HOME"              redshift
#stow --target "$HOME"              rofi
#stow --target "$HOME"              scripts
#stow --target "$HOME"              termite
#stow --target "$HOME"              tmux
#stow --target "$HOME" --no-folding vim
#stow --target "$HOME"              xorg
#stow --target "$HOME"              ytcc
#stow --target "$HOME"              zathura
#stow --target "$HOME"              zsh
