config.load_autoconfig()

default_bg = "#F5F6F7"
alt_bg = "#d9dde0"
default_fg = "#444444"
alt_fg = "#888888"
orange = "#F27835"
red = "#F04A50"
cyan = "#2E96C0"
blue = "#5294e2"
green = "#60942C"

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = default_fg

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = default_bg

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = default_bg

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = blue

# Background color of the completion widget category headers.
c.colors.completion.category.bg = alt_bg

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = alt_bg

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = alt_bg

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = default_fg

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = alt_bg

# Top border color of the completion widget category headers.
c.colors.completion.item.selected.border.top = alt_bg

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = alt_bg

# Foreground color of the matched text in the selected completion item
c.colors.completion.item.selected.match.fg = blue

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = blue

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = alt_fg

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = default_bg

# Background color for the download bar.
c.colors.downloads.bar.bg = default_bg

# Color gradient start for download text.
c.colors.downloads.start.fg = default_bg

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = blue

# Color gradient end for download text.
c.colors.downloads.stop.fg = default_bg

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = cyan

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = red

# Font color for hints.
c.colors.hints.fg = default_bg

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = cyan

# Font color for the matched part of hints.
c.colors.hints.match.fg = alt_fg

# Text color for the keyhint widget.
c.colors.keyhint.fg = default_fg

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = blue

# Background color of the keyhint widget.
c.colors.keyhint.bg = default_bg

# Foreground color of an error message.
c.colors.messages.error.fg = default_bg

# Background color of an error message.
c.colors.messages.error.bg = red

# Border color of an error message.
c.colors.messages.error.border = red

# Foreground color of a warning message.
c.colors.messages.warning.fg = default_bg

# Background color of a warning message.
c.colors.messages.warning.bg = orange

# Border color of a warning message.
c.colors.messages.warning.border = orange

# Foreground color of an info message.
c.colors.messages.info.fg = default_fg

# Background color of an info message.
c.colors.messages.info.bg = default_bg

# Border color of an info message.
c.colors.messages.info.border = default_bg

# Foreground color for prompts.
c.colors.prompts.fg = default_fg

# Border used around UI elements in prompts.
c.colors.prompts.border = default_bg

# Background color for prompts.
c.colors.prompts.bg = default_bg

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = green

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = default_fg

# Background color of the statusbar.
c.colors.statusbar.normal.bg = default_bg

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = green

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = default_bg

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = cyan

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = default_bg

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = default_fg

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = orange

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = default_fg

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = default_bg

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = default_fg

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = orange

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = orange

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = default_bg

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = blue

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = default_bg

# Background color of the progress bar.
c.colors.statusbar.progress.bg = blue

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = default_fg

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = red

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = default_fg

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = default_fg

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = green

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = orange

# Background color of the tab bar.
c.colors.tabs.bar.bg = default_bg

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = blue

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = cyan

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = red

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = default_fg

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = alt_bg

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = default_fg

# Background color of unselected even tabs.
c.colors.tabs.even.bg = alt_bg

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = default_bg

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = blue

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = default_bg

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = blue

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = alt_bg

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = default_fg

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = alt_bg

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = default_fg

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = blue

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = default_bg

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = blue

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = default_bg

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = default_bg

c.fonts.monospace = "Hack, DejaVu Sans Mono, Ubuntu Mono, monospace"
c.fonts.prompts = "11pt monospace"
c.fonts.statusbar = "11pt monospace"
c.fonts.tabs = "11pt Noto Sans"

c.statusbar.hide = False
c.statusbar.padding = {"bottom": 3, "left": 5, "right": 5, "top": 3}
c.statusbar.position = "bottom"
c.statusbar.widgets = ["keypress", "url", "history", "scroll", "progress"]

c.scrolling.bar = "when-searching"
c.scrolling.smooth = True

c.hints.border = "1px solid " + cyan

c.content.cookies.accept = "no-3rdparty"
c.content.autoplay = False
c.content.default_encoding = "utf-8"

c.tabs.background = True
c.tabs.close_mouse_button = "middle"
c.tabs.indicator.width = 0
c.tabs.last_close = "close"
c.tabs.max_width = 250
c.tabs.min_width = -1
c.tabs.mousewheel_switching = False
c.tabs.new_position.related = "next"
c.tabs.new_position.unrelated = "last"
c.tabs.padding = {"bottom": 3, "left": 5, "right": 5, "top": 3}
c.tabs.pinned.frozen = False
c.tabs.position = "top"
c.tabs.select_on_remove = "last-used"
c.tabs.show = "always"

config.unbind("<Ctrl-w>", mode="normal")
config.unbind("gr", mode="normal")
config.bind("gl", "tab-move +", mode="normal")
config.bind("gh", "tab-move -", mode="normal")
config.bind("m", "spawn mpv {url}", mode="normal")

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/index.php?search={}",
    "p": "https://de.pons.com/%C3%BCbersetzung?q={}&l=deen&in=&lf=&qnac=",
    "y": "https://www.youtube.com/results?search_query={}",
    "g": "https://www.startpage.com/do/search?query={}",
    "sp": "https://www.startpage.com/do/search?query={}",
    "aur": "https://aur.archlinux.org/packages/?O=0&K={}",
    "h": "https://www.stackage.org/lts/hoogle?q={}",
    "s": "https://scholar.google.de/scholar?q={}"
}

c.auto_save.session = True
c.messages.timeout = 4000
c.session.lazy_restore = True
c.spellcheck.languages = ["en-US"]

