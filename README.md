# Dotfiles

This repo holds some config files for my favorite GNU/Linux software.

## How to use it

* Clone this repo:
```shell
git clone --recursive https://github.com/popeye123/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
```
* Install GNU Stow:
```shell
# On Arch Linux
sudo pacman -S stow
```
* Uncomment the lines in install.sh of dotfiles you want to install
* Execute `./install.sh`
