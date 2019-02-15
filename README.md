<h1 align="center">⚫⚫⚫dotfiles⚫⚫⚫</h1>

![laptop setup](https://i.imgur.com/g5fTXnu.png)
Wallpaper based on [Low Poly Wolf by zelda-Freak91](https://zelda-freak91.deviantart.com/art/Low-Poly-Art-Wolf-537626838)


## How to use it

1. Clone this repo:

    ```shell
    git clone --recursive https://github.com/woefe/dotfiles.git $HOME/.dotfiles-woefe
    cd $HOME/.dotfiles-woefe
    ```
2. Install GNU Stow:

    ```shell
    # On Arch Linux
    sudo pacman -S stow
    ```
3. Uncomment the lines in [`install.sh`](./install.sh) of dotfiles you want to install
4. Execute `./install.sh`.
    Make sure that you run the script in the main dotfiles directory.
    I.e change directory to `.dotfiles-woefe` first.
