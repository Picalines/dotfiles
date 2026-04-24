def setup(c):
    menu = "#fe8827"
    menu_focus = "#fddfcd"

    space_dark, space_light = "#010e1e", "#301d4b"
    ash_dark, ash_light = "#be814e", "#ffb06b"
    strange_dark, strange_light = "#1755a2", "#2c8cff"
    eye_dark, eye_light = "#3b9565", "#6bffb0"
    quantum_dark, quantum_light = "#59439b", "#9a75ff"
    vessel_dark, vessel_light = "#bf5452", "#ff7370"
    other_dark, other_light = "#8a8b85", "#e6e7de"

    space_fg = "#d3d4d6"
    menu_fg = space_dark

    quantum_darker = "#2e3261"

    c.colors.completion.category.bg = quantum_dark
    c.colors.completion.category.border.bottom = quantum_dark
    c.colors.completion.category.border.top = quantum_dark
    c.colors.completion.category.fg = space_fg

    c.colors.completion.even.bg = space_dark
    c.colors.completion.odd.bg = space_dark
    c.colors.completion.fg = space_fg

    c.colors.completion.item.selected.bg = quantum_light
    c.colors.completion.item.selected.border.bottom = quantum_light
    c.colors.completion.item.selected.border.top = quantum_light
    c.colors.completion.item.selected.fg = menu_fg
    c.colors.completion.item.selected.match.fg = space_fg
    c.colors.completion.match.fg = ash_light

    c.colors.completion.scrollbar.bg = space_dark
    c.colors.completion.scrollbar.fg = space_fg

    c.colors.downloads.bar.bg = space_dark
    c.colors.downloads.error.bg = space_dark
    c.colors.downloads.error.fg = vessel_light
    c.colors.downloads.start.bg = space_dark
    c.colors.downloads.start.fg = strange_light
    c.colors.downloads.stop.bg = space_dark
    c.colors.downloads.stop.fg = eye_light
    c.colors.downloads.system.bg = "none"
    c.colors.downloads.system.fg = "none"

    c.colors.hints.bg = menu
    c.colors.hints.fg = menu_fg
    c.hints.border = "1px solid " + space_dark
    c.colors.hints.match.fg = menu_focus

    c.colors.keyhint.bg = space_dark
    c.colors.keyhint.fg = space_fg
    c.colors.keyhint.suffix.fg = eye_light

    c.colors.messages.error.bg = space_dark
    c.colors.messages.info.bg = space_dark
    c.colors.messages.warning.bg = space_dark
    c.colors.messages.error.border = space_dark
    c.colors.messages.info.border = space_dark
    c.colors.messages.warning.border = space_dark
    c.colors.messages.error.fg = vessel_light
    c.colors.messages.info.fg = space_fg
    c.colors.messages.warning.fg = ash_light

    c.colors.prompts.bg = space_dark
    c.colors.prompts.border = "1px solid " + space_dark
    c.colors.prompts.fg = space_fg
    c.colors.prompts.selected.bg = quantum_light
    c.colors.prompts.selected.fg = menu_fg

    c.colors.statusbar.normal.bg = space_light
    c.colors.statusbar.insert.bg = space_dark
    c.colors.statusbar.command.bg = space_light
    c.colors.statusbar.caret.bg = space_light
    c.colors.statusbar.caret.selection.bg = space_light
    c.colors.statusbar.progress.bg = strange_light
    c.colors.statusbar.passthrough.bg = space_dark

    c.colors.statusbar.normal.fg = ash_light
    c.colors.statusbar.insert.fg = ash_light
    c.colors.statusbar.command.fg = ash_light
    c.colors.statusbar.passthrough.fg = ash_light
    c.colors.statusbar.caret.fg = ash_light
    c.colors.statusbar.caret.selection.fg = ash_light

    c.colors.statusbar.url.error.fg = vessel_light
    c.colors.statusbar.url.fg = space_fg
    c.colors.statusbar.url.hover.fg = strange_light
    c.colors.statusbar.url.success.http.fg = eye_light
    c.colors.statusbar.url.success.https.fg = eye_light
    c.colors.statusbar.url.warn.fg = ash_light

    c.colors.statusbar.private.bg = space_dark
    c.colors.statusbar.private.fg = space_fg
    c.colors.statusbar.command.private.bg = space_light
    c.colors.statusbar.command.private.fg = space_fg

    c.colors.tabs.bar.bg = space_dark
    c.colors.tabs.even.bg = quantum_darker
    c.colors.tabs.odd.bg = quantum_darker
    c.colors.tabs.even.fg = space_fg
    c.colors.tabs.odd.fg = space_fg

    c.colors.tabs.indicator.system = "none"
    c.colors.tabs.indicator.error = vessel_light
    c.colors.tabs.selected.even.bg = quantum_light
    c.colors.tabs.selected.odd.bg = quantum_light
    c.colors.tabs.selected.even.fg = menu_fg
    c.colors.tabs.selected.odd.fg = menu_fg

    c.colors.contextmenu.menu.bg = space_light
    c.colors.contextmenu.menu.fg = space_fg
    c.colors.contextmenu.disabled.bg = space_light
    c.colors.contextmenu.disabled.fg = other_dark
    c.colors.contextmenu.selected.bg = quantum_light
    c.colors.contextmenu.selected.fg = menu_fg
