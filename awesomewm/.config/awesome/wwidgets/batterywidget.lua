--------------------
-- Battery widget --
--------------------
local vicious = require("vicious")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("wwidgets.helpers")
local batterywidget = {}

function batterywidget.setup(settings)
    if settings == nil then
        settings = {}
    end
    local color_fg = settings.color_fg or beautiful.fg_normal
    local color_bg = settings.color_bg or beautiful.bg_normal
    local color_low = settings.color_low or beautiful.color.red
    local color_powersave = settings.color_powersave or beautiful.color.green

    -- batwidget.powersave_enabled = false
    -- batwidget.backlight_brightness = 0
    -- batwidget.color = color_default

    -- local function toggle_powersave()
    --     if batwidget.powersave_enabled then
    --         vicious.activate()
    --         awful.spawn("xbacklight -set " .. batwidget.backlight_brightness, false)
    --         batwidget.powersave_enabled = false
    --         batwidget.color = color_default
    --         vicious.force(batwidget)
    --     else
    --         vicious.suspend()
    --         vicious.activate(batwidget.txt)
    --         batwidget.powersave_enabled = true
    --         batwidget.color = batwidget.color_powersave
    --         netwidget:suspend()
    --         cpuwidget:suspend()
    --         batwidget.backlight_brightness = math.floor(awful.util.pread("xbacklight -get") + 1)
    --         awful.spawn("xbacklight -set 8", false)
    --         vicious.force(batwidget)
    --     end
    -- end

    local txt = wibox.widget.textbox()
    txt:set_text("test")
    local tooltip = awful.tooltip({ objects = { txt }})

    txt:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            -- toggle_powersave()
        end),
        awful.button({}, 2, function()
            awful.spawn("xbacklight -set 100", false)
        end),
        awful.button({}, 3, function()
            awful.spawn.with_shell("sleep .3; xset dpms force off")
        end),
        awful.button({}, 4, function()
            awful.spawn("xbacklight -inc 1 -steps 1", false)
        end),
        awful.button({}, 5, function()
            awful.spawn("xbacklight -dec 1 -steps 1", false)
        end)
    ))

    vicious.register(txt, vicious.widgets.bat, function(widget, args)
        tooltip:set_text(args[1].. "," .. args[3])
        local capacity = args[2]
        local loading = args[1]
        if capacity < 8 and loading == "−" then
            naughty.notify({
                screen = mouse.screen,
                title = "Warning",
                text = "Low Battery: " .. capacity .. "%",
                bg = color_low,
                border_color = beautiful.color.red,
                fg = beautiful.color.black,
                timeout = 17,
                icon = beautiful.low_battery_icon
            })
            return '<span color="' .. color_low .. '">⛽ ' .. capacity .. '%</span>'
        else
            return '<span color="' .. color_fg .. '">⛽ ' .. capacity .. '%</span>'
        end
    end, 61, "BAT0")

    batterywidget.widget = helpers.add_background(txt, color_fg, color_bg)

    return batterywidget
end

return setmetatable(batterywidget, { __call = function(_, ...) return batterywidget.setup(...) end})
