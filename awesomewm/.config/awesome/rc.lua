-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Widget library
local drop = require("scratchdrop")
local simpletab = require("simpletab")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local wwidgets = require("wwidgets")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Initialization and default applications
homedir = os.getenv("HOME")
confdir = homedir .. "/.config/awesome"
themefile = confdir .. "/themes/Arc/theme.lua"
hostname = io.popen("hostname"):read()

terminal = os.getenv("TERMCMD") or "xterm"
editor = terminal .. " -e nvim"
htop = terminal .. " -e htop"
browser = "firefox"
mail = {}
mail.cmd = "thunderbird"
mail.class = "Thunderbird"

filemanager = terminal .. " -e ranger"
netstat = terminal .. " -e \"sh -c 'ss -tupr | column -t | less'\""
music = terminal .. " --name Music -e mocp"
--notes = "gvim note:Notes"
notes = terminal .. " -e 'nvim note:Notes'"

modkey = "Mod4"
altkey = "Mod1"

beautiful.init(themefile)
-- }}}

-- {{{ Override naughty defaults
naughty.config.defaults = {
    timeout = 10,
    text = "",
    screen = 1,
    ontop = true,
    margin = "5",
    opacity = beautiful.naughty_opacity,
    border_width = beautiful.naughty_border_width,
    border_color = beautiful.naughty_border_color,
    fg = beautiful.naughty_fg_color,
    bg = beautiful.naughty_bg_color,
    position = "top_right"
}
naughty.config.presets = {
    normal = {},
    low = {
        timeout = 10
    },
    critical = {
        bg = beautiful.color.red,
        border_color = beautiful.color.red,
        fg = beautiful.naughty_fg_color,
        timeout = 0,
    }
}
-- }}}

-- {{{ Wallpaper
-- Determine screen orientation
local function get_screen_orientation(s)
    if s.geometry.height > s.geometry.width then
        return "portrait"
    end
    return "landscape"
end

local function set_wallpaper(s)
    wallpaper = beautiful.wallpaper[get_screen_orientation(s)]
    if wallpaper then
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.magnifier
}
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "edit config", terminal .. " -e 'nvim " .. awesome.conffile .. "'" },
    { "edit theme", terminal .. " -e 'nvim " .. themefile .. "'" },
    { "hotkeys", function() return false, hotkeys_popup.show_help end},
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

myshutdownmenu = {
    { "suspend", "systemctl suspend", beautiful.suspend_icon },
    { "hibernate", "systemctl hibernate", beautiful.suspend_icon },
    { "poweroff", "systemctl poweroff", beautiful.shutdown_icon },
    { "reboot", "systemctl reboot", beautiful.reboot_icon }
}

mymainmenu = awful.menu({ items = {
    { "shutdown", myshutdownmenu, beautiful.shutdown_icon },
    { "awesome", myawesomemenu, beautiful.awesome_icon }
}})

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
-- }}}

-- {{{ Widgets
widget_bg_toggle = 1
function widget_background()
    widget_bg_toggle = (widget_bg_toggle + 1) % 2
    return beautiful.widget_bg[widget_bg_toggle]
end

interfaces = {"eth0"}
if hostname == "glados" then
    interfaces = {"enp2s0"}
elseif hostname == "wheatley" then
    interfaces = {"enp8s0", "wlp2s0"}
end

netwidget = wwidgets.netwidget({
    interfaces = interfaces,
    netstat_cmd = netstat,
    color_bg = widget_background()
})

cpuwidget = wwidgets.cpuwidget({
    color_bg = widget_background(),
    color_high = beautiful.color.red,
    htop_cmd = htop
})

alsawidget = wwidgets.alsawidget({
    color_bg = widget_background()
})

-- No battery widget for desktop computers
batterywidget = {}
if awful.util.file_readable("/sys/class/power_supply/BAT0/present") then
    batterywidget = wwidgets.batterywidget({
        color_bg = widget_background(),
        color_low = beautiful.color.red
    })
end

clock = wwidgets.clock({
    mail = mail,
    color_bg = widget_background()
})

layout_box_color = widget_background()
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)


awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    local layout = layouts[1]
    if get_screen_orientation(s) == "landscape" then
        layout = awful.layout.suit.tile
    else
        layout = awful.layout.suit.tile.top
    end

    local tagnames = {}
    tagnames[1] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    tagnames[2] = { "Q", "W", "E", "R", "T", "Z", "U", "I", "O" }
    tagnames[3] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

    -- Each screen has its own tag table.
    awful.tag(tagnames[s.index], s, layout)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
    ))
    s.mylayoutbox = wwidgets.helpers.add_background(s.mylayoutbox, beautiful.fg_normal, layout_box_color)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist= awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    systray = nil
    if s.index == 1 then
        systray = wwidgets.helpers.add_background(wibox.widget.systray(), beautiful.fg_normal, beautiful.bg_systray)
    end

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal(),
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            netwidget.widget,
            cpuwidget.widget,
            alsawidget.widget,
            batterywidget.widget,
            clock.widget,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Fn and multimedia keys
    awful.key({ }, "XF86MonBrightnessDown",
        function () awful.spawn("xbacklight -dec 1 -steps 1", false) end,
        {description = "Decrease screen brightness"}),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 1 -steps 1", false) end),
    awful.key({ }, "XF86AudioRaiseVolume", function () alsawidget.increase_vol() end),
    awful.key({ }, "XF86AudioLowerVolume", function () alsawidget.decrease_vol() end),
    awful.key({ }, "XF86AudioMute", function () alsawidget.toggle_mute() end),
    awful.key({ }, "XF86Display", function () awful.spawn("arandr") end),
    awful.key({ }, "XF86WebCam", function () awful.spawn("guvcview") end),
    awful.key({ }, "XF86AudioNext", function () awful.spawn("mocp --next", false) end),
    awful.key({ }, "XF86AudioPrev", function () awful.spawn("mocp --previous", false) end),
    awful.key({ }, "XF86AudioPlay", function () awful.spawn(homedir .. "/.moc/mocp_toggle", false) end),
    awful.key({ }, "KP_Right", function() awful.spawn("mocp --next", false) end),
    awful.key({ }, "KP_Left", function() awful.spawn("mocp --previous", false) end),
    awful.key({ }, "KP_Begin", function() awful.spawn(homedir .. "/.moc/mocp_toggle", false) end),

    -- Layout manipulation
    awful.key({ modkey, altkey }, "l", function() awful.tag.incncol(1) end),
    awful.key({ modkey, altkey }, "h", function() awful.tag.incncol(-1) end),
    awful.key({ modkey, altkey }, "j", function() awful.tag.incnmaster(1) end),
    awful.key({ modkey, altkey }, "k", function() awful.tag.incnmaster(-1) end),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({ modkey, "Control" }, "k", function() awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Control" }, "j", function() awful.client.incwfact(0.05) end),
    awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(layouts, -1) end),

    -- Tags switching
    awful.key({ modkey, }, "Left", function() awful.tag.viewprev() end ),
    awful.key({ modkey, }, "Right", function() awful.tag.viewnext() end ),
    awful.key({ modkey, }, "Escape", function() awful.tag.history.restore() end ),

    -- selecting and moving clients
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.global_bydirection("down") end),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.global_bydirection("up") end),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.global_bydirection("right") end),
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.global_bydirection("left") end),
    awful.key({ modkey, "Shift" }, "n", function() awful.client.restore() end ),
    awful.key({ modkey, }, "#34", function() awful.client.urgent.jumpto() end),

    awful.key({ modkey, }, "j", function()
        awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "k", function()
        awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "h", function()
        awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "l", function()
        awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end
    end),

    -- keycode 49 refers to the key under escape on my keyboard
    awful.key({ modkey }, "#49", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey, }, "Tab", function()
        simpletab.switch(1, "Super_L", "Tab", "ISO_Left_Tab")
    end),

    awful.key({ modkey, "Shift" }, "Tab", function()
        simpletab.switch(-1, "Super_L", "Tab", "ISO_Left_Tab")
    end),

    -- miscellaneous
    awful.key({ modkey, "Control" }, "x", function() awesome.restart() end),
    awful.key({ modkey, "Shift" }, ".", function() mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Shift" }, "x", function() awesome.quit() end ),
    awful.key({ modkey, "Shift" }, "y", function() mymainmenu:show() end),
    -- awful.key({ modkey, }, "p", function() menubar.show() end),
    awful.key({ modkey, altkey }, "Return", function() drop(terminal .. " -e 'tmux new-session -A -s drop'", "top", "center", 1, 1, true, 1) end),

    awful.key({ modkey }, "XF86AudioMute", function()
        text = "Notifications disabled"
        icon = beautiful.icon_notify_disabled
        if naughty.is_suspended() then
            text = "Notifications enabled"
        icon = beautiful.icon_notify_enabled
        end

        naughty.notify({
            title = text,
            screen = mouse.screen,
            timeout = 2,
            icon = icon
        })
        naughty.toggle()
    end),

    awful.key({ modkey, "Control" }, "b", function()
        local screen = awful.screen.focused()
        screen.mywibox.visible = not screen.mywibox.visible
    end),

    awful.key({ modkey }, ".", function()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),

    awful.key({ modkey, "Control" }, "s", function()
        lockcmd = "i3lock -S 0 -f -c '" .. beautiful.bg_normal .. "'"
            .. " --insidevercolor=00000000"
            .. " --insidewrongcolor=00000000"
            .. " --insidecolor=00000000"
            .. " --ringvercolor='" .. beautiful.color.blue .. "ff'"
            .. " --ringwrongcolor='" .. beautiful.color.red  .. "ff'"
            .. " --ringcolor='" .. beautiful.color.arc_darker .. "ff'"
            .. " --linecolor=00000000"
            .. " --separatorcolor=00000000"
            .. " --textcolor='" .. beautiful.color.white .. "ff'"
            .. " --keyhlcolor='" .. beautiful.color.blue .. "ff'"
            .. " --bshlcolor='" .. beautiful.color.blue .. "ff'"
        awful.spawn(lockcmd, false)
    end),

    -- Take a screenshot
    awful.key({ modkey }, "Print", function()
        local filename = homedir .. "/Pictures/Screenshots/screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
        awful.spawn("scrot " .. filename, false)
        naughty.notify({
            title = "Screenshot taken",
            text = "The screenshot was saved as \n" .. filename,
            screen = mouse.screen,
            timeout = 5,
            icon = beautiful.screenshot_icon
        })
    end),

    -- Start xfce screenshooter
    awful.key({ }, "Print", function()
        awful.spawn("xfce4-screenshooter", false)
    end),

    -- Touchpad on/off
    awful.key({ modkey, "Control" }, "t", function ()
        awful.spawn.with_shell("synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')")
    end),

    -- Restore default screen layout
    awful.key({ modkey, "Control" }, "n", function ()
        awful.spawn("xrandr --output LVDS1 --mode 1366x768 --output HDMI1 --off --output VGA1 --off", false)
    end),

    -------------------------------------
    -- Shortcuts for favorite programs --
    -------------------------------------

    awful.key({ modkey, altkey }, "e", function()
        local matcher = function(c)
            return awful.rules.match(c, { class = mail.class })
        end
        awful.client.run_or_raise(mail.cmd, matcher)
    end),

    awful.key({ modkey, altkey }, "m", function()
        local matcher = function(c)
            return awful.rules.match(c, { instance = "Music" })
        end
        awful.client.run_or_raise(music, matcher)
    end),

    awful.key({ modkey, altkey }, "r", function() awful.spawn(filemanager) end),
    awful.key({ modkey, altkey }, "f", function() awful.spawn("nautilus --no-desktop") end),
    awful.key({ modkey, altkey }, "t", function() awful.spawn("telegram") end),
    awful.key({ modkey, altkey }, "b", function() awful.spawn(browser) end),
    awful.key({ modkey, altkey }, "c", function() awful.spawn("chromium --incognito") end),
    awful.key({ modkey, altkey }, "p", function() awful.spawn("keepassx2 '/home/popeye/sync/passwords.kdbx'") end),
    awful.key({ modkey, altkey }, "n", function() drop(notes, "top", "right", 500, 1, true, 1) end),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end)
)


-- Rofi keys
function spawn_rofi(mode)
    awful.spawn( "rofi -show " .. mode .. " -terminal " .. terminal .. " -rsh-command '{terminal} -e \"{ssh-client} {host}\"'", false)
end

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "x", function() spawn_rofi("run") end),
    awful.key({ modkey }, "p", function() spawn_rofi("drun") end),
    awful.key({ modkey }, "y", function() spawn_rofi("ssh") end),
    awful.key({ modkey }, "a", function() spawn_rofi("window") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey, }, "c", function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, }, "<", awful.client.movetoscreen ),
    awful.key({ modkey, }, "d", function(c) c.ontop = not c.ontop end),
    awful.key({ modkey, }, "s", function(c) c.sticky = not c.sticky end),
    awful.key({ modkey, }, "n", function(c) c.minimized = true end),
    awful.key({ modkey, }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical = not c.maximized_vertical
    end)
)


-- Bind keys to tags.
-- Be careful: we use keycodes here. E.g. keycode #10 is usually "1" on your keyboard.
-- You can find out the keycodes with the "xev" command.
--
-- This maps tags on screen 1 to your numberrow ,
-- tags on screen 2 to the row above the homerow (on a qwertz layout)
local screen_keys = {}
screen_keys[1] = { "#10", "#11", "#12", "#13", "#14", "#15", "#16", "#17", "#18" }
screen_keys[2] = { "q", "w", "e", "r", "t", "z", "u", "i", "o" }
screen_keys[3] = { "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9"}
for s in screen do
    for i,_ in pairs(screen_keys[s.index]) do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, screen_keys[s.index][i], function()
                awful.screen.focus(s)
                local tag = s.tags[i]
                if tag then
                    tag:view_only()
                end
            end),

            awful.key({ modkey, "Shift" }, screen_keys[s.index][i], function()
                if client.focus then
                    local tag = s.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        -- awful.screen.focus(screen)
                    end
                end
            end)
        )
    end
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            keys = clientkeys,
            raise = true,
            size_hints_honor = false,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        }
    },
     -- Force the first Firefox window to tag 1 on screen 1
    { rule = { class = "Firefox"},
        callback = function(c)
            local filter = function(c)
                return awful.rules.match(c, {class = "Firefox"})
            end
            local ff_windows = 0
            for _ in awful.client.iterate(filter) do
                ff_windows = ff_windows + 1
            end
            if ff_windows <= 1 then
                c:tags({screen[1].tags[1]})
            end
        end
    },
    { rule = { class = "VirtualBox" },
        except = { name = "Oracle VM VirtualBox Manager" },
        properties = { floating = true, size_hints_honor = true }
    },
    { rule = { class = "Firefox" },
        except = { instance = "Navigator" },
        properties = { floating = true, size_hints_honor = true }
    },
    { rule = { class = "Steam" },
        except = { name = "Steam" },
        properties = { floating = true, size_hints_honor = true }
    },
    { rule_any = {
            class = {
                "mpv",
                "feh",
                "pinentry",
                "Gimp-2.8",
                "Guvcview",
                "Vlc",
                "Plugin-container",
                "Telegram",
                "Cutegram",
                "Pavucontrol",
                "Keepassx"
            }
        },
        properties = { floating = true, size_hints_honor = true }
    },
    { rule = { class = mail.class },
        properties = { screen = 1, tag = "9" }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then

        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
        --client.focus:raise()
    end
end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("focus", function(c)
    if c.sticky then
        c.border_color = beautiful.border_marked
    else
        c.border_color = beautiful.border_focus
    end
end)
client.connect_signal("property::sticky", function(c)
    if c.sticky then
        c.border_color = beautiful.border_marked
    else
        if client.focus then
            c.border_color = beautiful.border_focus
        else
            c.border_color = beautiful.border_normal
        end
    end
end)
-- }}}

-- vim: set foldmethod=marker tabstop=4 shiftwidth=4 expandtab:
