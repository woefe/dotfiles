import atexit
import os
import readline
import rlcompleter
import sys

PY_DIR = os.path.expanduser("~/.local/share/python/")
HISTFILE = os.path.join(PY_DIR, "history")

def on_exit():
    os.makedirs(PY_DIR, mode=0o755, exist_ok=True)
    readline.write_history_file(HISTFILE)

try:
    readline.read_history_file(HISTFILE)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(100000)
except FileNotFoundError:
    pass

readline.parse_and_bind("tab: complete")
sys.ps1 = "\n\033[38;5;4m 🠪 \033[0m"
sys.ps2 = "\033[38;5;8m … \033[0m"

atexit.register(on_exit)
