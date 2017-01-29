local wibox = require("wibox")

local helpers = {}

function helpers.add_background(widget, color_fg, color_bg)
    container = wibox.layout.fixed.horizontal()
    spacer = wibox.widget.textbox()
    --spacer:set_text(" ")
    spacer:set_markup('<span font="17"> </span>')
    container:add(spacer)
    container:add(widget)
    container:add(spacer)

    bg = wibox.container.background(container, color_bg)
    bg.fg = color_fg
    return bg
end

return helpers
