if [ -d "$ZDOTDIR/zprofile.d" ]; then
    for f in "$ZDOTDIR/zprofile.d"/?*.sh ; do
        [ -r "$f" ] && source "$f"
    done
    unset f
fi
