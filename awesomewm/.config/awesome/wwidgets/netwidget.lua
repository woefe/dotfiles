--------------------
-- Network widget --
--------------------
local vicious = require("vicious")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("wwidgets.helpers")
local netwidget = {}

function netwidget.setup(settings)
    if settings == nil then
        settings = {}
    end
    local color_fg = settings.color_fg or beautiful.fg_normal
    local color_bg = settings.color_bg or beautiful.bg_normal
    local interfaces = settings.interfaces or { "enp8s0" }
    local width = settings.graph_width or 40
    local netstat_cmd = settings.netstat_cmd or "xterm -e netstat"

    buttons = awful.util.table.join(awful.button({}, 1, function() awful.spawn(netstat_cmd) end))

    txt_tx = wibox.widget.textbox()
    txt_tx:buttons(buttons)

    txt_rx = wibox.widget.textbox()
    txt_rx:buttons(buttons)

    graph_tx = wibox.widget.graph()
    graph_tx:set_width(width)
    graph_tx:set_background_color(color_bg)
    graph_tx:set_color(color_fg)
    graph_tx:set_max_value(20)
    graph_tx:set_scale(true)
    graph_tx:buttons(buttons)

    graph_rx = wibox.widget.graph()
    graph_rx:set_width(width)
    graph_rx:set_background_color(color_bg)
    graph_rx:set_color(color_fg)
    graph_rx:set_max_value(70)
    graph_rx:set_scale(true)
    graph_rx:buttons(buttons)

    tooltip = awful.tooltip({ objects = { txt_tx, txt_rx, graph_tx, graph_rx }})

    -- function netwidget:suspend()
    --     netwidget.graph_rx:clear()
    --     netwidget.graph_tx:clear()
    --     netwidget.tooltip:set_text("[Suspended]")
    --     netwidget.txt_tx:set_text("[x]")
    --     netwidget.txt_rx:set_text("[x]")
    -- end

    vicious.register(netwidget, vicious.widgets.net, function(widget, args)
        local sum_rx = 0
        local sum_tx = 0
        local text = ""

        for _, iface in pairs(interfaces) do
            local tx = args["{" .. iface .. " up_kb}"]
            local rx = args["{" .. iface .. " down_kb}"]
            sum_tx = sum_tx + tx
            sum_rx = sum_rx + rx
            text = text .. "\n" .. iface .. ":\nTX: " .. tx .. "kB/s\tRX: " .. rx .. "kB/s\n"
        end
        graph_tx:add_value(sum_tx)
        graph_rx:add_value(sum_rx)
        tooltip:set_text(text)

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

        txt_tx:set_text("↑ " .. sum_tx)
        txt_rx:set_text(" ↓ " .. sum_rx)

        return nil
    end, 2)

    container = wibox.layout.fixed.horizontal()
    container:add(txt_tx)
    container:add(graph_tx)
    container:add(txt_rx)
    container:add(graph_rx)
    netwidget.widget = helpers.add_background(container, color_fg, color_bg)

    return netwidget
end

return setmetatable(netwidget, { __call = function(_, ...) return netwidget.setup(...) end})
