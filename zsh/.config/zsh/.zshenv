typeset -U path
path=(~/.local/bin $path[@])
fpath=(~/.zsh-plugins/zsh-completions/src $fpath)

export EDITOR='nvim'
export PAGER='less'
export BROWSER='firefox'
export TERMCMD='alacritty'
export QT_QPA_PLATFORMTHEME='gtk2'

export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--color=16,hl:4,hl+:4,bg+:15,fg+:8,spinner:5,info:2'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/xorg/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/xorg/xserverrc"

export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ANDROID_AVD_HOME="$XDG_DATA_HOME/android/"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android/"
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME/android"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export GOPATH="$XDG_DATA_HOME/go"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
