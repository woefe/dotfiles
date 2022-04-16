<h1 align="center">dotfiles</h1>

![laptop setup](https://i.imgur.com/y5yAxSd.png)


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

## Updating
To update the dotfiles pull this repo including its submodules.

```
git pull --recurse-submodules
```
