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
local vicious = require("vicious")
local revelation = require("revelation")
local drop = require("scratchdrop")
local simpletab = require("simpletab")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = err
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Initialization and default applications
homedir = os.getenv("HOME")
confdir = homedir .. "/.config/awesome"
themefile = confdir .. "/themes/Arc/theme.lua"

terminal = os.getenv("TERMCMD") or "xterm"
editor = terminal .. " -e nvim"
htop = terminal .. " -e htop"
browser = "firefox"
mail = {}
mail.prog = "thunderbird"
mail.class = "Thunderbird"

filemanager = terminal .. " -e ranger"
netstat = terminal .. " -e \"sh -c 'ss -tupr | column -t | less'\""
music = terminal .. " --name Music -e ncmpcpp"
--notes = "gvim note:Notes"
notes = terminal .. " -e 'nvim note:Notes'"

modkey = "Mod4"
altkey = "Mod1"

beautiful.init(themefile)
revelation.init()
-- }}}

-- {{{ Override naughty defaults
naughty.config.defaults = {
    timeout = 5,
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
        timeout = 5
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
screen_orientation = {}
for s = 1, screen.count() do
    geometry = screen[s].geometry
    if geometry.height > geometry.width then
        screen_orientation[s] = "portrait"
    else
        screen_orientation[s] = "landscape"
    end
end

-- Set different wallpapers depending on the screen orientation
if beautiful.wallpaper_horizontal and beautiful.wallpaper_vertical then
    for s = 1, screen.count() do
        if screen_orientation[s] == "landscape" then
            gears.wallpaper.maximized(beautiful.wallpaper_horizontal[s], s, false)
        else
            gears.wallpaper.maximized(beautiful.wallpaper_vertical[s], s, false)
        end
    end
end
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

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
local tagnames = {}
tagnames[1] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
tagnames[2] = { "Q", "W", "E", "R", "T", "Z", "U", "I", "O" }
tagnames[3] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

for s = 1, screen.count() do
    local layout = layouts[1]
    if screen_orientation[s] == "landscape" then
        layout = awful.layout.suit.tile
    else
        layout = awful.layout.suit.tile.top
    end
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tagnames[s], s, layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "edit config", terminal .. " -e 'nvim " .. awesome.conffile .. "'" },
    { "edit theme", terminal .. " -e 'nvim " .. themefile .. "'" },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
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
-- Adds a background and separator to the given widget and sets the foreground color
local function add_background(widget, color)
    container = wibox.layout.fixed.horizontal()
    spacer = wibox.widget.textbox()
    --spacer:set_text(" ")
    spacer:set_markup('<span font="17"> </span>')
    container:add(spacer)
    container:add(widget)
    container:add(spacer)

    bg = wibox.widget.background(container, color)
    bg:set_fg(beautiful.widget_text_fg)
    return bg
end

-- Holds all widgets that are drawn on every screen. Note that the systray and
-- the layoutbox are not included in this table!
widgets = {}

--reserve widget_pos = 1 for the systray which is added later
widget_pos = 2

local function add_widget(widget)
    widgets[widget_pos] = widget
    widget_pos = widget_pos + 1
end

--------------------
-- Network widget --
--------------------
-- Settings
netwidget = {
    color_background = beautiful.widget_bg[widget_pos],
    color_rx = beautiful.widget_graph_fg,
    color_tx = beautiful.widget_graph_fg,
    width = 40,
}

netwidget.interfaces = {}
function netwidget:update_interfaces()
    netwidget.interfaces = {}
    for interface in string.gmatch(awful.util.pread("ls --ignore={lo,tun0,virbr*} /sys/class/net/"), "%S+") do
       netwidget.interfaces = awful.util.table.join(netwidget.interfaces, { interface })
    end
end
netwidget:update_interfaces()

netwidget.buttons = awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn(netstat)
    end)
)

netwidget.txt_tx = wibox.widget.textbox()
netwidget.txt_tx:buttons(netwidget.buttons)

netwidget.txt_rx = wibox.widget.textbox()
netwidget.txt_rx:buttons(netwidget.buttons)

netwidget.graph_tx = awful.widget.graph()
netwidget.graph_tx:set_width(netwidget.width)
netwidget.graph_tx:set_background_color(netwidget.color_background)
netwidget.graph_tx:set_color(netwidget.color_tx)
netwidget.graph_tx:set_max_value(20)
netwidget.graph_tx:set_scale(true)
netwidget.graph_tx:buttons(netwidget.buttons)

netwidget.graph_rx = awful.widget.graph()
netwidget.graph_rx:set_width(netwidget.width)
netwidget.graph_rx:set_background_color(netwidget.color_background)
netwidget.graph_rx:set_color(netwidget.color_rx)
netwidget.graph_rx:set_max_value(70)
netwidget.graph_rx:set_scale(true)
netwidget.graph_rx:buttons(netwidget.buttons)

netwidget.tooltip = awful.tooltip({ objects = {
    netwidget.txt_tx,
    netwidget.txt_rx,
    netwidget.graph_tx,
    netwidget.graph_rx
}})

function netwidget:suspend()
    netwidget.graph_rx:clear()
    netwidget.graph_tx:clear()
    netwidget.tooltip:set_text("[Suspended]")
    netwidget.txt_tx:set_text("[x]")
    netwidget.txt_rx:set_text("[x]")
end

vicious.register(netwidget, vicious.widgets.net, function(widget, args)
    local sum_rx = 0
    local sum_tx = 0
    local text = ""

    netwidget:update_interfaces()
    for _, iface in pairs(netwidget.interfaces) do
        local tx = args["{" .. iface .. " up_kb}"]
        local rx = args["{" .. iface .. " down_kb}"]
        sum_tx = sum_tx + tx
        sum_rx = sum_rx + rx
        text = text .. "\n" .. iface .. ":\nTX: " .. tx .. "kB/s\tRX: " .. rx .. "kB/s\n"
    end
    netwidget.graph_tx:add_value(sum_tx)
    netwidget.graph_rx:add_value(sum_rx)
    netwidget.tooltip:set_text(text)

    if sum_tx > 100 then
        sum_tx = sum_tx / 1000
        sum_tx = string.format("%.1f", sum_tx) .. "M "
    else
        sum_tx = string.format("%.1f", sum_tx) .. "K "
    end

    if sum_rx > 100 then
        sum_rx = sum_rx / 1000
        sum_rx = string.format("%.1f", sum_rx) .. "M "
    else
        sum_rx = string.format("%.1f", sum_rx) .. "K "
    end

    netwidget.txt_tx:set_text("↑ " .. sum_tx)
    netwidget.txt_rx:set_text(" ↓ " .. sum_rx)

    return nil
end, 2)

netwidget_container = wibox.layout.fixed.horizontal()
netwidget_container:add(netwidget.txt_tx)
netwidget_container:add(netwidget.graph_tx)
netwidget_container:add(netwidget.txt_rx)
netwidget_container:add(netwidget.graph_rx)
netwidget_container = add_background(netwidget_container, netwidget.color_background)

add_widget(netwidget_container)

----------------
-- CPU widget --
----------------
-- Color settings
cpuwidget = {
    color_graph = beautiful.widget_graph_fg,
    color_background = beautiful.widget_bg[widget_pos],
    number_of_cores = awful.util.pread("nproc")
}

cpuwidget.high_load = false
cpuwidget.buttons = awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn(htop)
    end)
)

local function cpu_notification(cpu_load)
    if cpu_load > 60 then
        cpuwidget.high_load = true
        cpuwidget.txt:set_markup('<span color="' .. beautiful.color.red .. '">▦ ' .. cpu_load .. '% </span>')
        cpuwidget.graph:set_color(beautiful.color.red)
    else
        cpuwidget.high_load = false
        cpuwidget.txt:set_markup('<span color="' .. beautiful.widget_text_fg .. '">▦ ' .. cpu_load .. '% </span>')
        cpuwidget.graph:set_color(cpuwidget.color_graph)
    end
end

cpuwidget.txt = wibox.widget.textbox()
cpuwidget.txt:buttons(cpuwidget.buttons)

cpuwidget.graph = awful.widget.graph()
cpuwidget.graph:buttons(cpuwidget.buttons)
cpuwidget.graph:set_width(40)
cpuwidget.graph:set_background_color(cpuwidget.color_background)
cpuwidget.graph:set_max_value(10)
cpuwidget.graph:set_scale(true)
cpuwidget.graph:set_color(cpuwidget.color_graph)

cpuwidget.tooltip = awful.tooltip({ objects = { cpuwidget.graph, cpuwidget.txt }})

function cpuwidget:suspend()
    cpuwidget.graph:clear()
    cpuwidget.tooltip:set_text("[Suspended]")
    cpuwidget.txt:set_text("[x]")
end

vicious.register(cpuwidget, vicious.widgets.cpu, function(widget, args)
    local text = "\t\ttotal: " .. args[1] .. "%"
    for i = 2, cpuwidget.number_of_cores + 1 do
        if i % 2 == 0 then
            text = text .. "\ncpu" .. i - 2 .. ": " .. string.format("%3i", args[i]) .. "%"
        else
            text = text .. " \tcpu" .. i - 2 .. ": " .. string.format("%3i", args[i]) .. "%"
        end
    end
    cpuwidget.tooltip:set_text(text)
    cpu_notification(args[1])
    cpuwidget.graph:add_value(args[1])
return nil
end, 2)

cpu_widget = wibox.layout.fixed.horizontal()
cpu_widget:add(cpuwidget.txt)
cpu_widget:add(cpuwidget.graph)
cpu_widget = add_background(cpu_widget, cpuwidget.color_background)

add_widget(cpu_widget)


-----------------
-- ALSA widget --
-----------------
-- Settings
local alsawidget = {
    channel = "Master",
    step = "2%",
    mixer = "pavucontrol" --or terminal .. " -e alsamixer"
}

alsawidget.toggle_mute = function()
    awful.util.pread("amixer sset " .. alsawidget.channel .. " toggle", false)
    vicious.force({ alsawidget.txt })
end

alsawidget.increase_vol = function()
    awful.util.pread("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+", false)
    vicious.force({ alsawidget.txt })
end

alsawidget.decrease_vol = function()
    awful.util.pread("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-", false)
    vicious.force({ alsawidget.txt })
end

alsawidget.txt = wibox.widget.textbox()
alsawidget.txt:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn(alsawidget.mixer)
    end),
    awful.button({}, 3, function()
        alsawidget.toggle_mute()
    end),
    awful.button({}, 4, function()
        alsawidget.increase_vol()
    end),
    awful.button({}, 5, function()
        alsawidget.decrease_vol()
    end)
))

alsawidget.txt_bg = add_background(alsawidget.txt, beautiful.widget_bg[widget_pos])

alsawidget.tooltip = awful.tooltip({ objects = { alsawidget.txt } })

vicious.register(alsawidget.txt, vicious.widgets.volume, function(widget, args)
    if args[2] == "♩" then
        alsawidget.tooltip:set_text("[Muted]")
        return "🔇"
    end
    alsawidget.tooltip:set_text(" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
    return "🔊 " .. args[1] .. "%"
end, 10, alsawidget.channel)

add_widget(alsawidget.txt_bg)

--------------------
-- Battery widget --
--------------------
-- No battery widget for desktop computers
if awful.util.file_readable("/sys/class/power_supply/BAT0/present") then

    -- Color settings
    local batwidget = {
        color_default = beautiful.widget_text_fg,
        color_low = beautiful.color.red,
        color_powersave = beautiful.color.green,
    }

    batwidget.powersave_enabled = false
    batwidget.low_bat = false
    batwidget.backlight_brightness = 0
    batwidget.color = batwidget.color_default

    local function toggle_powersave()
        if batwidget.powersave_enabled then
            vicious.activate()
            awful.util.spawn("xbacklight -set " .. batwidget.backlight_brightness, false)
            batwidget.powersave_enabled = false
            batwidget.color = batwidget.color_default
            vicious.force(batwidget)
        else
            vicious.suspend()
            vicious.activate(batwidget.txt)
            batwidget.powersave_enabled = true
            batwidget.color = batwidget.color_powersave
            netwidget:suspend()
            cpuwidget:suspend()
            batwidget.backlight_brightness = math.floor(awful.util.pread("xbacklight -get") + 1)
            awful.util.spawn("xbacklight -set 8", false)
            vicious.force(batwidget)
        end
    end

    batwidget.txt = wibox.widget.textbox()
    batwidget.tooltip = awful.tooltip({ objects = { batwidget.txt }})

    batwidget.txt:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            toggle_powersave()
        end),
        awful.button({}, 2, function()
            awful.util.spawn("xbacklight -set 100", false)
        end),
        awful.button({}, 3, function()
            awful.util.spawn_with_shell("sleep .3; xset dpms force off")
        end),
        awful.button({}, 4, function()
            awful.util.spawn("xbacklight -inc 1 -steps 1", false)
        end),
        awful.button({}, 5, function()
            awful.util.spawn("xbacklight -dec 1 -steps 1", false)
        end)
    ))

    vicious.register(batwidget.txt, vicious.widgets.bat, function(widget, args)
        batwidget.tooltip:set_text(args[1].. "," .. args[3])
        local capacity = args[2]
        local loading = args[1]
        if capacity < 8 and loading == "−" then
            naughty.notify({
                screen = mouse.screen,
                title = "Warning",
                text = "Low Battery: " .. capacity .. "%",
                bg = beautiful.color.red,
                border_color = beautiful.color.red,
                fg = beautiful.color.black,
                timeout = 17,
                icon = beautiful.low_battery_icon
            })
            batwidget.low_bat = true
            return '<span color="' .. batwidget.color_low .. '">⛽ ' .. capacity .. '%</span>'
        else
            batwidget.low_bat = false
            return '<span color="' .. batwidget.color .. '">⛽ ' .. capacity .. '%</span>'
        end
    end, 61, "BAT0")

    batwidget_container = add_background(batwidget.txt, beautiful.widget_bg[widget_pos])

    add_widget(batwidget_container)
end

----------------------
-- Textclock widget --
----------------------
clock = {}
clock.txt = awful.widget.textclock("%H:%M  %a %d")
clock.txt = add_background(clock.txt, beautiful.widget_bg[widget_pos])
clock.tooltip = awful.tooltip({ objects = { clock.txt } })
clock.month = math.floor(os.date("%m"))
clock.year = math.floor(os.date("%Y"))
clock.tooltip:set_markup('<span font="Ubuntu Mono 12">' .. awful.util.pread("cal -m") .. '</span>')
clock.txt:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        local matcher = function(c)
            return awful.rules.match(c, { class = mail.class })
        end
        awful.client.run_or_raise(mail.prog, matcher)
    end),
    awful.button({}, 2, function()
        clock.tooltip:set_markup('<span font="Ubuntu Mono 12">' .. awful.util.pread("cal -m") .. '</span>')
    end),
    awful.button({}, 4, function()
        clock.month = clock.month + 1
        if clock.month > 12 then
            clock.month = 1
            clock.year = clock.year + 1
        end
        clock.tooltip:set_markup('<span font="Ubuntu Mono 12">' .. awful.util.pread("cal -m " .. clock.month .. " " .. clock.year) .. '</span>')
    end),
    awful.button({}, 5, function()
        clock.month = clock.month - 1
        if clock.month < 1 then
            clock.month = 12
            clock.year = clock.year - 1
        end
        clock.tooltip:set_markup('<span font="Ubuntu Mono 12">' .. awful.util.pread("cal -m " .. clock.month .. " " .. clock.year) .. '</span>')
    end)
    ))
add_widget(clock.txt)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
    ))
    mylayoutbox[s] = add_background(mylayoutbox[s], beautiful.widget_bg[widget_pos])

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(add_background(wibox.widget.systray(), beautiful.widget_bg[1]))
    end
    for pos, widget in pairs(widgets) do
        right_layout:add(widget)
    end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
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
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 1 -steps 1", false) end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 1 -steps 1", false) end),
    awful.key({ }, "XF86AudioRaiseVolume", function () alsawidget.increase_vol() end),
    awful.key({ }, "XF86AudioLowerVolume", function () alsawidget.decrease_vol() end),
    awful.key({ }, "XF86AudioMute", function () alsawidget.toggle_mute() end),
    awful.key({ }, "XF86Display", function () awful.util.spawn("arandr") end),
    awful.key({ }, "XF86WebCam", function () awful.util.spawn("guvcview") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mpc next", false) end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mpc prev", false) end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle", false) end),
    awful.key({ }, "KP_Right", function() awful.util.spawn("mpc next", false) end),
    awful.key({ }, "KP_Left", function() awful.util.spawn("mpc prev", false) end),
    awful.key({ }, "KP_Begin", function() awful.util.spawn("mpc toggle", false) end),

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
    awful.key({ modkey, }, "a", function() revelation() end),

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
        simpletab.switch(-2, "Super_L", "Tab", "ISO_Left_Tab")
    end),

    -- miscellaneous
    awful.key({ modkey, "Control" }, "x", function() awesome.restart() end),
    awful.key({ modkey, "Shift" }, ".", function() mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Shift" }, "x", function() awesome.quit() end ),
    awful.key({ modkey, }, "y", function() mymainmenu:show() end),
    awful.key({ modkey, }, "p", function() menubar.show() end),
    awful.key({ modkey, altkey }, "Return", function() drop(terminal .. " -e 'tmux new-session -A -s drop'", "top", "center", 1, 1, true, 1) end),

    awful.key({ modkey }, "XF86AudioMute", function()
        naughty.notify({
            title = "Notifications disabled",
            screen = mouse.screen,
            timeout = 2,
            icon = beautiful.icon_notify_disabled
        })
        naughty.suspend()
    end),

    awful.key({ modkey, "Shift" }, "XF86AudioMute", function()
        naughty.resume()
        naughty.notify({
            title = "Notifications enabled",
            screen = mouse.screen,
            timeout = 2,
            icon = beautiful.icon_notify_enabled
        })
    end),

    awful.key({ modkey, "Control" }, "b", function()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    awful.key({ modkey }, ".", function()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),

    awful.key({ modkey, "Control" }, "s", function()
        awful.util.spawn_with_shell( "sh -c 'slock && xset -dpms' & ; xset dpms 0 0 2; xset dpms force off" )
    end),

    -- Take a screenshot
    awful.key({ modkey }, "Print", function()
        local filename = homedir .. "/Pictures/Screenshots/screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
        awful.util.spawn("scrot " .. filename, false)
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
        awful.util.spawn("xfce4-screenshooter", false)
    end),

    -- Touchpad on/off
    awful.key({ modkey, "Control" }, "t",
         function ()
             awful.util.spawn_with_shell("synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')")
         end),

    -- Restore default screen layout
    awful.key({ modkey, "Control" }, "n",
        function ()
            awful.util.spawn("xrandr --output LVDS1 --mode 1366x768 --output HDMI1 --off --output VGA1 --off", false)
        end),

    -- External dual Monitor setup
    awful.key({ modkey, "Control" }, "d",
        function ()
            awful.util.spawn("xrandr --output LVDS1 --off --output HDMI1 --mode 1920x1080 --primary --output VGA1 --mode 1920x1080 --right-of HDMI1", false)
        end),

    -- Rotate Monitor
    awful.key({ modkey, "Control" }, "v", function()
        local orientation = awful.util.pread("xrandr -q --verbose | grep DisplayPort-0 | cut -d ' ' -f5 | tr -d ' \n'")
        if orientation == "normal" then
            awful.util.spawn("xrandr --output DisplayPort-0 --rotate left", false)
        else
            awful.util.spawn("xrandr --output DisplayPort-0 --rotate normal", false)
        end
    end),


    -------------------------------------
    -- Shortcuts for favorite programs --
    -------------------------------------

    awful.key({ modkey, altkey }, "e", function()
        local matcher = function(c)
            return awful.rules.match(c, { class = mail.class })
        end
        awful.client.run_or_raise(mail.prog, matcher)
    end),

    awful.key({ modkey, altkey }, "m", function()
        local matcher = function(c)
            return awful.rules.match(c, { instance = "Music" })
        end
        awful.client.run_or_raise(music, matcher)
    end),

    awful.key({ modkey, altkey }, "r", function() awful.util.spawn(filemanager) end),
    awful.key({ modkey, altkey }, "f", function() awful.util.spawn("nautilus --no-desktop") end),
    awful.key({ modkey, altkey }, "t", function() awful.util.spawn("telegram") end),
    awful.key({ modkey, altkey }, "b", function() awful.util.spawn(browser) end),
    awful.key({ modkey, altkey }, "c", function() awful.util.spawn("chromium --incognito") end),
    awful.key({ modkey, altkey }, "p", function() awful.util.spawn("keepassx2 '/home/popeye/sync/passwords.kdbx'") end),
    awful.key({ modkey, altkey }, "n", function() drop(notes, "top", "right", 500, 1, true, 1) end),
    awful.key({ modkey, }, "Return", function() awful.util.spawn(terminal) end)
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
for s = 1, screen.count() do
    for i,_ in pairs(screen_keys[s]) do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, screen_keys[s][i], function()
                local tag = awful.tag.gettags(s)[i]
                if tag then
                    awful.screen.focus(s)
                    awful.tag.viewonly(tag)
                end
            end),

            awful.key({ modkey, "Shift" }, screen_keys[s][i], function()
                if client.focus then
                    local screen = client.focus.screen
                    local tag = awful.tag.gettags(s)[i]
                    if tag then
                        awful.client.movetotag(tag)
                        awful.screen.focus(screen)
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
            buttons = clientbuttons
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
                c.screen = 1
                local first_tag = awful.tag.gettags(1)[1]
                c:tags({first_tag})
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
        properties = { tag = tags[1][9] }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
            --client.focus:raise()
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they do not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position and c.size_hints_honor then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
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
