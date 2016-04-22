#!/bin/bash

# Before executing this script make sure you have GNU Stow installed!!

mkdir -p $HOME/.config

#stow --no-folding autostart
#stow awesomewm
#stow bash
#stow compton
#stow --no-folding fish
#stow i3
#stow --no-folding moc
#stow --no-folding mpd; mkdir ~/.config/mpd/playlists
#stow --no-folding ranger
#stow redshift
#stow tmux
#stow --no-folding vim; mkdir $HOME/.vim/swapfiles; curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#ln -s ~/.vim ~/.config/nvim; ln -s ~/.vimrc ~/.config/nvim/init.vim #Installs nvim config (important: stow vim first)
#stow --no-folding vimperator
#stow xorg
#stow zathura


cat << EOF

There are still things to do if you installed one of the following configs!

VIM:
To complete the vim configuration open vim and execute :PlugInstall

EOF

