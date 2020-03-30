export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

tmux() {
    command tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf "$@"
}
