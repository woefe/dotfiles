---------------------------
-- Default awesome theme --
---------------------------

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua

theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/wblue/"
theme = {}
theme.font          = "sans 8"

-- Default colors
theme.color = {}
theme.color.blue      = "#4a90d9"
theme.color.black     = "#000000"
theme.color.white     = "#FFFFFF"
theme.color.red       = "#FF0000"
theme.color.green     = "#00c43e"

-- Widget colors
-- Background colors of widgets
theme.widget_bg = {
    "#57a9ff",
    "#4c94e0",
    "#3f79b7",
    "#346698",
    "#274c74",
    "#1a324d",
    "#0c1825"
}

theme.widget_graph_fg = "#afd1ff"
theme.widget_text_fg = "#d0e4ff"

-- Common theme settings
theme.bg_normal     = "#92aed5"
theme.bg_focus      = "#d0e4ff" or "#afd1ff"
theme.bg_urgent     = theme.color.red
theme.bg_minimize   = "#92aed5"
theme.bg_systray    = theme.widget_bg[1]

theme.fg_normal     = theme.color.black
theme.fg_focus      = theme.color.black
theme.fg_urgent     = theme.color.black
theme.fg_minimize   = "#346698"

theme.border_width  = 4
theme.border_normal = theme.color.black
theme.border_focus  = "#57a9ff"
theme.border_marked = theme.color.red

-- Tooltip settings
theme.tooltip_opacity      = 1
theme.tooltip_border_width = theme.border_width
theme.tooltip_border_color = theme.bg_focus
theme.tooltip_bg_color     = theme.bg_focus
theme.tooltip_fg_color     = theme.fg_focus

-- Notification settings
theme.tooltip_opacity      = 1
theme.naughty_opacity      = 1
theme.naughty_border_width = theme.border_width
theme.naughty_border_color = theme.bg_focus
theme.naughty_bg_color     = theme.bg_focus
theme.naughty_fg_color     = theme.fg_focus

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_dir .. "taglist/squarefw.png"
theme.taglist_squares_unsel = theme_dir .. "taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_dir .. "submenu.png"
theme.menu_height = 15
theme.menu_width  = 100
theme.menu_border_width = 0 or theme.border_width

-- Different wallpaper for horizontal and vertical screen orientation
theme.wallpaper_horizontal = {
    theme_dir .. "portal_blue.png",
    theme_dir .. "portal_orange.png"
}

theme.wallpaper_vertical = {
    theme_dir .. "background_vertical.png"
}

-- You can use your own layout icons like this:
theme.layout_fairh      = theme_dir .. "layouts/fairhw.png"
theme.layout_fairv      = theme_dir .. "layouts/fairvw.png"
theme.layout_centerfair = theme_dir .. "layouts/centerfair.png"
theme.layout_floating   = theme_dir .. "layouts/floatingw.png"
theme.layout_magnifier  = theme_dir .. "layouts/magnifierw.png"
theme.layout_max        = theme_dir .. "layouts/maxw.png"
theme.layout_fullscreen = theme_dir .. "layouts/fullscreenw.png"
theme.layout_tilebottom = theme_dir .. "layouts/tilebottomw.png"
theme.layout_tileleft   = theme_dir .. "layouts/tileleftw.png"
theme.layout_tile       = theme_dir .. "layouts/tilew.png"
theme.layout_tiletop    = theme_dir .. "layouts/tiletopw.png"
theme.layout_spiral     = theme_dir .. "layouts/spiralw.png"
theme.layout_dwindle    = theme_dir .. "layouts/dwindlew.png"

-- lain useless gap width
theme.useless_gap_width = 1

-- icons for launcher widget
theme.awesome_icon     = theme_dir .. "icons/awesome16.png"
theme.reboot_icon      = theme_dir .. "icons/reboot.png"
theme.shutdown_icon    = theme_dir .. "icons/shutdown.png"
theme.suspend_icon     = theme_dir .. "icons/suspend.png"

-- Notification icons
theme.low_battery_icon = theme_dir .. "icons/battery-warning.svg"
theme.screenshot_icon  = theme_dir .. "icons/screenshooter.svg"

-- Define the icon theme for application icons. If not set then the icons
-- in /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Paper"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:foldmethod=marker
