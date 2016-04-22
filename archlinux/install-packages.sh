#!/usr/bin/env bash

packages=(
    adwaita-icon-theme
    alsa-utils
    android-tools
    android-udev
    arandr
    autopep8
    awesome
    base-devel
    bc
    breeze-icons
    chromium
    cifs-utils
    clang
    clipit
    cloc
    cmake
    compton
    cryptsetup
    ctags
    cups
    cups-pdf
    curl
    ddrescue
    deja-dup
    desktop-file-utils
    dex
    dia
    easytag
    eog
    evince
    exfat-utils
    feh
    ffmpeg
    figlet
    file-roller
    firefox
    firefox-i18n-en-us
    fish
    gdb
    ghc
    gimp
    git
    gksu
    gnome-clocks
    gnome-disk-utility
    gnome-keyring
    grml-zsh-config
    gsmartcontrol
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-base-libs
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gvfs-mtp
    htop
    hunspell
    hunspell-de
    hunspell-en
    hyphen
    hyphen-de
    hyphen-en
    iftop
    imagemagick
    imlib2
    inetutils
    inkscape
    iotop
    ipython
    jdk7-openjdk
    jdk8-openjdk
    keepassx2
    lame
    libnotify
    libreoffice-fresh
    linux-headers
    livestreamer
    lolcat
    lsof
    lxappearance
    moc
    mpc
    mpd
    mpg123
    mpv
    mythes-de
    mythes-en
    nautilus
    nautilus-open-terminal
    nautilus-sendto
    ncdu
    ncmpcpp
    neovim
    networkmanager
    network-manager-applet
    networkmanager-openvpn
    nfs-utils
    nm-connection-editor
    ntfs-3g
    openssh
    opus
    owncloud-client
    p7zip
    parallel
    pavucontrol
    picard
    pulseaudio
    pulseaudio-alsa
    pv
    python
    python2
    python2-cairo
    python2-crypto
    python2-ecdsa
    python2-gobject2
    python2-lockfile
    python2-nautilus
    python2-neovim
    python2-paramiko
    python-chardet
    python-gobject
    python-neovim
    python-packaging
    python-requests
    python-setuptools
    python-six
    python-urllib3
    python-xdg
    qrencode
    ranger
    redshift
    rsync
    rtmpdump
    rxvt-unicode
    rxvt-unicode-terminfo
    scrot
    simple-scan
    slock
    smartmontools
    smbclient
    sqlite
    stack
    stow
    sudo
    texlive-lang
    texlive-most
    thefuck
    thunderbird
    thunderbird-i18n-de
    thunderbird-i18n-en-us
    tipp10
    tmux
    transmission-gtk
    trash-cli
    tree
    ttf-dejavu
    ttf-droid
    ttf-hack
    ttf-inconsolata
    ttf-liberation
    ttf-symbola
    ttf-ubuntu-font-family
    tzdata
    unclutter
    vlc
    w3m
    weechat
    wget
    whois
    wmname
    wpa_supplicant
    xf86-input-libinput
    xorg-server
    xorg-server-utils
    xorg-xinit
    xorg-xkill
    xorg-xprop
    xsel
    youtube-dl
    zathura
    zathura-pdf-poppler
    zsh
    zsh-completions
)

aur_packages=(
    brother-brgenml1
    brscan4
    fasd
    gtk-theme-arc
    mpdcron-git
    needrestart
    neovim-remote
    telegram-desktop-bin
    urxvt-resize-font-git
    xonsh
)

optional_packages=(
    libva-intel-driver
    libva-vdpau-driver
    libvdpau-va-gl
    mesa-vdpau
    tlp
    xf86-video-ati
    xf86-video-intel
)

sudo pacman --needed -S ${packages[@]}

echo
echo "Installing yaourt..."

curl -o /tmp/yaourt.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
curl -o /tmp/package-query.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
tar -xf /tmp/yaourt.tar.gz --directory /tmp
tar -xf /tmp/package-query.tar.gz --directory /tmp
cd /tmp/package-query
makepkg -sri
cd -
cd /tmp/yaourt
makepkg -sri
cd -
rm -rf /tmp/yaourt /tmp/package-query /tmp/yaourt.tar.gz /tmp/package-query.tar.gz

echo
echo "These AUR packages will be installed:"
echo ${aur_packages[@]}
echo
yaourt -S ${aur_packages[@]}

echo
echo "These optional packages can be installed now:"
echo ${optional_packages[@]}
echo

for p in ${optional_packages[@]}; do
    read -p "Install $p? [Y/n] " choice
    if [[ $choice == "" || $choice == "y" || $choice == "Y" ]]; then
        sudo pacman -S $p
    fi
done

