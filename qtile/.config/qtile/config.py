# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import os


def to_urgent(qtile):
    cg = qtile.currentGroup
    for group in qtile.groupMap.values():
        if group == cg:
            continue
        if len([w for w in group.windows if w.urgent]) > 0:
            qtile.currentScreen.setGroup(group)
            return


def get_interface():
    def filter_ethernet(iface):
        with open("/sys/class/net/" + iface + "/type") as f:
            return f.readline() == "1\n"

    def filter_up(iface):
        with open("/sys/class/net/" + iface + "/carrier") as f:
            return f.readline() == "1\n"

    return next(filter(filter_up,
                       filter(filter_ethernet,
                              os.listdir("/sys/class/net"))), "wlp2s0")


mod = "mod4"
alt = "mod1"
homedir = os.getenv("HOME")
terminal = os.getenv("TERMCMD")
dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"

colorscheme = {
    "blue": "#5294E2",
    "black": "#000000",
    "white": "#FFFFFF",
    "red": "#F46067",
    "green": "#00C43E",
    "gray": "#858C98",
    "arc_darker": "#2F343F",
    "arc_dark": "#3E424D",
}

screenlock = "i3lock -S 0 -f -c '" + colorscheme["arc_dark"] + "'" \
    " --insidevercolor=00000000" \
    " --insidewrongcolor=00000000" \
    " --insidecolor=00000000" \
    " --ringvercolor='" + colorscheme["blue"] + "ff'" \
    " --ringwrongcolor='" + colorscheme["red"] + "ff'" \
    " --ringcolor='" + colorscheme["arc_darker"] + "ff'" \
    " --linecolor=00000000" \
    " --separatorcolor=00000000" \
    " --textcolor='" + colorscheme["white"] + "ff'" \
    " --keyhlcolor='" + colorscheme["blue"] + "ff'" \
    " --bshlcolor='" + colorscheme["blue"] + "ff'" \

rofi = "rofi -show %%s -terminal %s -ssh-command '{terminal} -e \"{ssh-client} {host}\"'" % terminal

keys = [
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod], "s", lazy.layout.toggle_split()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "Escape", lazy.screen.toggle_group()),
    Key([mod], "Right", lazy.screen.next_group()),
    Key([mod], "Left", lazy.screen.prev_group()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "m", lazy.layout.maximize()),
    Key([mod, "control"], "space", lazy.window.toggle_floating()),
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "c", lazy.window.kill()),
    Key([mod], "Tab", lazy.layout.next()),
    Key([mod, "shift"], "Tab", lazy.layout.previous()),
    Key([mod], "1", lazy.to_screen(0)),
    Key([mod], "2", lazy.to_screen(1)),
    Key([mod], "3", lazy.to_screen(2)),
    Key([mod], "space", lazy.next_layout()),
    Key([mod, "shift"], "space", lazy.prev_layout()),
    Key([mod], "c", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod, "shift"], "period", lazy.spawncmd()),
    Key([mod], "udiaeresis", lazy.function(to_urgent)),

    # Multimedia/Function keys
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 1 -steps 1")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 1 -steps 1")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 2%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 2%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),
    Key([], "XF86Display", lazy.spawn("arandr")),
    Key([], "XF86WebCam", lazy.spawn("guvcview")),
    Key([], "XF86AudioNext", lazy.spawn("mocp --next")),
    Key([], "XF86AudioPrev", lazy.spawn("mocp --previous")),
    Key([], "XF86AudioPlay", lazy.spawn(homedir + "/.moc/mocp_toggle")),
    Key([], "KP_Right", lazy.spawn("mocp --next")),
    Key([], "KP_Left", lazy.spawn("mocp --previous")),
    Key([], "KP_Begin", lazy.spawn(homedir + "/.moc/mocp_toggle")),

    # Programs
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod, alt], "Return", lazy.spawn("termite --class drop  -e 'tmux new-session -A -s drop'")),
    Key([], "Print", lazy.spawn("xfce4-screenshooter")),
    Key([mod, "control"], "n", lazy.spawn("xrandr --output LVDS1 --mode 1366x768 --output HDMI1 --off --output VGA1 --off")),
    Key([mod, alt], "f", lazy.spawn("nautilus --no-desktop")),
    Key([mod, alt], "r", lazy.spawn([terminal, "-e", "ranger"])),
    Key([mod, alt], "m", lazy.spawn([terminal, "-e", "mocp"])),
    Key([mod, alt], "n", lazy.spawn('gvim note:Notes')),
    Key([mod, alt], "b", lazy.spawn("firefox")),
    Key([mod, alt], "c", lazy.spawn("chromium --incognito")),
    Key([mod, alt], "p", lazy.spawn(["keepassx2", homedir + "/sync/passwords.kdbx"])),
    Key([mod, "control"], "s", lazy.spawn(screenlock)),

    # rofi launcher
    Key([mod], "x", lazy.spawn(rofi % "run")),
    Key([mod], "d", lazy.spawn(rofi % "drun")),
    Key([mod], "a", lazy.spawn(rofi % "window")),
    Key([mod], "y", lazy.spawn(rofi % "ssh")),
]

groups = [Group(i) for i in "qwertzuiop"]

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
    )

border = {
    "border_focus": colorscheme["blue"],
    "border_normal": colorscheme["black"],
    "border_width": 4
}

layouts = [
    # TODO bordercolor, width
    layout.Columns(name="col", num_columns=2, **border),
    layout.VerticalTile(name="vert", **border),
    layout.Max(),
]

floating_layout = layout.Floating(**border)

widget_defaults = dict(
    font='Arial',
    fontsize=12,
    padding=1,
)

graph_config = {
    "width": 70,
    "background": None,
    "border_color": colorscheme["blue"],
    "border_width": 0,
    "fill_color": colorscheme["white"],
    "frequency": 2,
    "graph_color": colorscheme["white"],
    "line_width": 1,
    "margin_x": 3,
    "margin_y": 3,
    "samples": 50,
    "start_pos": 'bottom',
    "type": 'linefill'
}

sep_config = {
    "linewidth": 4,
    "padding": 10,
    "foreground": colorscheme["blue"],
}

group_box_config = {
    "highlight_method": "border",
    "inactive": colorscheme["gray"],
    "rounded": False,
    "borderwidth": 4,
    "active": colorscheme["white"],
    "this_current_screen_border": colorscheme["blue"],
    "this_screen_border": colorscheme["blue"],
    "other_screen_border": colorscheme["gray"],
    "urgent_border": colorscheme["red"],
    "urgent_text": colorscheme["red"],
}

task_list_config = {
    "highlight_method": "border",
    "border": colorscheme["blue"],
    "borderwidth": 4,
    "rounded": False,
    "max_title_width": 200,
    "urgent_border": colorscheme["red"],
}

widgets = [
    widget.GroupBox(**group_box_config),
    widget.Prompt(),
    widget.TaskList(**task_list_config),
    # widget.TextBox("default config", name="default"),
    widget.Sep(**sep_config),
    widget.Systray(),
    widget.Sep(**sep_config),
    widget.Net(interface=get_interface(), update_interval=2),
    widget.NetGraph(bandwidth_type="down", interface=get_interface(), **graph_config),
    widget.Sep(**sep_config),
    widget.TextBox("CPU:"),
    widget.CPUGraph(core='all', **graph_config),
    widget.Sep(**sep_config),
    widget.TextBox("🔊"),
    widget.Volume(update_interval=1),
]

if os.path.exists("/sys/class/power_supply/BAT0/present"):
    widgets.extend([
        widget.Sep(**sep_config),
        widget.Battery(low_foreground=colorscheme["red"],
                       discharge_char="🗲",
                       charge_char="🔌")
    ])

widgets.extend([
    widget.Sep(**sep_config),
    widget.Clock(format='%H:%M %a %d', update_interval=5),
    widget.Sep(**sep_config),
    widget.CurrentLayout(),
    widget.Sep(**sep_config),
])

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            22,
            background=colorscheme["arc_darker"]
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(**group_box_config),
                widget.Prompt(),
                widget.TaskList(**task_list_config),
                widget.Sep(**sep_config),
                widget.Clock(format='%H:%M %a %d', update_interval=5),
                widget.Sep(**sep_config),
                widget.CurrentLayout(),
                widget.Sep(**sep_config),
            ],
            22,
            background=colorscheme["arc_darker"]
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


@hook.subscribe.client_new
def floating_windows(window):
    floaters = ["mpv", "quake", "Gcr-prompter", "Keepassx"]
    if window.window.get_wm_class()[1] in floaters:
        window.floating = True


@hook.subscribe.client_managed
def drop(window):
    if window.window.get_wm_class()[1] == "drop":
        window.fullscreen = True
        #window.place(100, 200, 400, 200, 3, None, above=True, force=True, margin=None)


@hook.subscribe.startup
def set_wallpaper():
    import subprocess
    subprocess.run(["feh", "--bg-fill",  homedir + "/.wallpaper"])

