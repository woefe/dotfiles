----------------
-- CPU widget --
----------------
local vicious = require("vicious")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("wwidgets.helpers")
local cpuwidget = {}

function cpuwidget.setup(settings)
    if settings == nil then
        settings = {}
    end
    local color_fg = settings.color_fg or beautiful.fg_normal
    local color_bg = settings.color_bg or beautiful.bg_normal
    local color_high = settings.color_high or beautiful.color.red
    local width = settings.graph_width or 40
    local htop_cmd = settings.htop_cmd or "xterm -e htop"
    local number_of_cores = tonumber(io.popen("nproc"):read())

    txt = wibox.widget.textbox()
    buttons = awful.util.table.join(awful.button({}, 1, function() awful.spawn(htop_cmd) end))
    txt:buttons(buttons)

    graph = wibox.widget.graph()
    graph:buttons(buttons)
    graph:set_width(width)
    graph:set_background_color(color_bg)
    graph:set_max_value(10)
    graph:set_scale(true)
    graph:set_color(color_fg)

    tooltip = awful.tooltip({ objects = { graph, txt }})

    -- function cpuwidget:suspend()
    --     cpuwidget.graph:clear()
    --     cpuwidget.tooltip:set_text("[Suspended]")
    --     cpuwidget.txt:set_text("[x]")
    -- end

    vicious.register(cpuwidget, vicious.widgets.cpu, function(widget, args)
        local text = "\t\ttotal: " .. args[1] .. "%"
        for i = 2, number_of_cores + 1 do
            if i % 2 == 0 then
                text = text .. "\ncpu" .. i - 2 .. ": " .. string.format("%3i", args[i]) .. "%"
            else
                text = text .. " \tcpu" .. i - 2 .. ": " .. string.format("%3i", args[i]) .. "%"
            end
        end
        tooltip:set_text(text)
        cpu_load = args[1]

        if cpu_load > 60 then
            txt:set_markup('<span color="' .. color_high .. '">▦ ' .. cpu_load .. '% </span>')
            graph:set_color(color_high)
        else
            txt:set_markup('<span color="' .. color_fg .. '">▦ ' .. cpu_load .. '% </span>')
            graph:set_color(color_fg)
        end

        graph:add_value(cpu_load)
        return nil
    end, 2)

    container = wibox.layout.fixed.horizontal()
    container:add(txt)
    container:add(graph)
    cpuwidget.widget = helpers.add_background(container, color_fg, color_bg)

    return cpuwidget
end

return setmetatable(cpuwidget, { __call = function(_, ...) return cpuwidget.setup(...) end})
