----------------------
-- Textclock widget --
----------------------
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("wwidgets.helpers")
local clock = {}

function clock.setup(settings)
    if settings == nil then
        settings = {}
    end
    local color_fg = settings.color_fg or beautiful.fg_normal
    local color_bg = settings.color_bg or beautiful.bg_normal
    local mail_class = settings.mail.class or "Thunderbird"
    local mail_cmd = settings.mail.cmd or "thunderbird"

    local txt = wibox.widget.textclock("%H:%M  %a %d")
    local tooltip = awful.tooltip({ objects = { txt } })

    clock.month = math.floor(os.date("%m"))
    clock.year = math.floor(os.date("%Y"))

    function set_tooltip_async(tooltip, cmd)
        awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
            tooltip:set_markup('<span font="Ubuntu Mono 12">' .. stdout .. '</span>')
        end)
    end

    set_tooltip_async(tooltip, "cal -m")
    txt:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            local matcher = function(c)
                return awful.rules.match(c, { class = mail_class })
            end
            awful.client.run_or_raise(mail_cmd, matcher)
        end),
        awful.button({}, 2, function()
            set_tooltip_async(tooltip, "cal -m")
        end),
        awful.button({}, 4, function()
            clock.month = clock.month + 1
            if clock.month > 12 then
                clock.month = 1
                clock.year = clock.year + 1
            end
            set_tooltip_async(tooltip, "cal -m " .. clock.month .. " " .. clock.year)
        end),
        awful.button({}, 5, function()
            clock.month = clock.month - 1
            if clock.month < 1 then
                clock.month = 12
                clock.year = clock.year - 1
            end
            set_tooltip_async(tooltip, "cal -m " .. clock.month .. " " .. clock.year)
        end)
    ))

    clock.widget = helpers.add_background(txt, color_fg, color_bg)

    return clock
end

return setmetatable(clock, { __call = function(_, ...) return clock.setup(...) end})
