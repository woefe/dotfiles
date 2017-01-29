-----------------
-- ALSA widget --
-----------------
-- Settings
--
local vicious = require("vicious")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("wwidgets.helpers")
local alsawidget = {}

function alsawidget.setup(settings)
    if settings == nil then
        settings = {}
    end
    local channel = settings.channel or "Master"
    local step = settings.step or "2%"
    local mixer = settings.mixer or "pavucontrol"
    local color_fg = settings.color_fg or beautiful.color_fg
    local color_bg = settings.color_bg or beautiful.color_bg

    local txt = wibox.widget.textbox()
    txt:set_text("test")

    alsawidget.toggle_mute = function()
        awful.spawn.easy_async("amixer sset " .. channel .. " toggle", function(stdout, stderr, reason, code)
            vicious.force({ txt })
        end)
    end

    alsawidget.increase_vol = function()
        awful.spawn.easy_async("amixer sset " .. channel .. " " .. step .. "+", function(stdout, stderr, reason, code)
            vicious.force({ txt })
        end)
    end

    alsawidget.decrease_vol = function()
        awful.spawn.easy_async("amixer sset " .. channel .. " " .. step .. "-", function(stdout, stderr, reason, code)
            vicious.force({ txt })
        end)
    end

    txt:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            awful.spawn(mixer)
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

    local tooltip = awful.tooltip({ objects = { txt } })

    vicious.register(txt, vicious.widgets.volume, function(widget, args)
        if args[2] == "♩" then
            tooltip:set_text("[Muted]")
            return "🔇"
        end
        tooltip:set_text(" " .. channel .. ": " .. args[1] .. "% ")
        return "🔊 " .. args[1] .. "%"
    end, 10, channel)

    alsawidget.widget = helpers.add_background(txt, color_fg, color_bg)

    return alsawidget
end

return setmetatable(alsawidget, { __call = function(_, ...) return alsawidget.setup(...) end})

