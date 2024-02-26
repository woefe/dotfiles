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
#stow --target "$HOME"              bat
#stow --target "$HOME" --no-folding dunst
#stow --target "$HOME" --no-folding git
#stow --target "$HOME" --no-folding haskell
#stow --target "$HOME"              i3
#stow --target "$HOME"              latex
#stow --target "$HOME" --no-folding moc
#stow --target "$HOME"              mpv
#stow --target "$HOME" --no-folding nvim
#stow --target "$HOME"              python
#stow --target "$HOME" --no-folding ranger
#stow --target "$HOME" --no-folding scripts
#stow --target "$HOME"              sway
#stow --target "$HOME" --no-folding tmux
#stow --target "$HOME"              vimiv
#stow --target "$HOME"              vscode
#stow --target "$HOME"              xdg
#stow --target "$HOME"              ytcc
#stow --target "$HOME"              zathura
#stow --target "$HOME" --no-folding zsh


#stow --target "$HOME" --no-folding vscode;
#cat << EOF | xargs -L1 code --install-extension
#DavidAnson.vscode-markdownlint
#EditorConfig.EditorConfig
#mrworkman.papercolor-vscode-redux
#ms-python.python
#RomanPeshkov.vscode-text-tables
#vscodevim.vim
#EOF
