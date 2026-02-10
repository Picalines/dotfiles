from themes import catppuccin

config.load_autoconfig()

c.input.forward_unbound_keys = "none"
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.tabs.mode_on_change = "persist"
c.input.mode_override = ""

c.statusbar.position = "bottom"
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.width = "17%"

c.fonts.default_family = "IosevkaTerm Nerd Font Mono"
c.fonts.default_size = "18pt"
c.fonts.hints = "16pt default_family"
c.fonts.tabs.selected = "bold"

c.tabs.title.format = "{audio}{current_title}"
c.tabs.title.format_pinned = c.tabs.title.format

c.hints.selectors["button"] = [
    "select",
    "button",
    "[onclick]",
    "[onmousedown]",
    '[role="option"]',
    '[role="button"]',
    '[role="tab"]',
    '[role="checkbox"]',
    '[role="switch"]',
    '[role="menuitem"]',
    '[role="menuitemcheckbox"]',
    '[role="menuitemradio"]',
    '[role="treeitem"]',
    "[ng-click]",
    "[ngClick]",
    "[data-ng-click]",
]

c.input.mode_override = "insert"
c.bindings.default["normal"].clear()
c.bindings.default["insert"].clear()
c.bindings.default["hint"].clear()


then_default = lambda cmd: cmd + " ;; mode-enter insert"
to_default = then_default("nop")

keymaps = {
    "insert": {
        "<Ctrl-z>": "mode-enter normal",
    },
    "passthrough": {
        "<Shift+Escape>": to_default,
    },
    "command+prompt+yesno+register+hint": {
        "<Escape>": then_default("mode-leave"),
    },
    "normal+insert": {
        "<Ctrl-d>": "scroll-page 0 0.5",
        "<Ctrl-u>": "scroll-page 0 -0.5",
        "<Ctrl-i>": "forward",
        "<Ctrl-o>": "back",
        "<back>": "back",
        "<forward>": "forward",
    },
    "normal": {
        "<Escape>": to_default,
        "<Ctrl-z>": then_default("fake-key <Ctrl-z>"),
        "p": "mode-enter passthrough",
        ":": "cmd-set-text :",
        ";": "cmd-set-text :",
        "h": then_default("tab-prev"),
        "j": then_default("tab-next"),
        "k": then_default("tab-prev"),
        "l": then_default("tab-next"),
        "r": then_default("reload"),
        "R": then_default("reload -f"),
        "o": "cmd-set-text -s :open",
        "O": "cmd-set-text -s :open -t",
        "x": then_default("tab-close -p"),
        "u": then_default("undo"),
        "/": "cmd-set-text /",
        "?": "cmd-set-text ?",
        "n": "search-next",
        "N": "search-prev",
        "G": then_default("scroll bottom"),
        "+": "zoom-in",
        "-": "zoom-out",
        "m": "quickmark-save",
        "d": then_default("devtools right"),
        "D": then_default("devtools window"),
        "s": "cmd-set-text -s :set",
        "i": then_default("hint inputs --first"),
        "t<Escape>": to_default,
        "tp": then_default("config-cycle tabs.position left top"),
        "to": then_default("tab-only"),
        "th": "tab-move - ;; mode-enter normal ;; fake-key -g t",
        "tj": "tab-move + ;; mode-enter normal ;; fake-key -g t",
        "tk": "tab-move - ;; mode-enter normal ;; fake-key -g t",
        "tl": "tab-move + ;; mode-enter normal ;; fake-key -g t",
        "tw": then_default("tab-give"),
        "tW": "cmd-set-text -s :tab-take",
        "tm": then_default("tab-mute"),
        "T": "cmd-set-text -s :tab-select",
        "f<Escape>": to_default,
        **{
            f"f{g}{a}": f"hint {group} {action}"
            for g, group in (
                ("", "links"),
                ("b", "button"),
                ("i", "images"),
                ("t", "inputs"),
            )
            for a, action in (
                ("c", "normal"),
                ("o", "current"),
                ("O", "tab-fg"),
                ("d", "download"),
                ("r", "right-click"),
                ("h", "hover"),
            )
        },
        "g<Escape>": to_default,
        "go": "cmd-set-text :open {url:pretty}",
        "gg": then_default("scroll top"),
        "gh": "cmd-set-text -s :help -t",
        "gc": then_default("config-source"),
        "y<Escape>": to_default,
        "yy": then_default("yank"),
        "yt": then_default("yank title"),
        "yd": then_default("yank domain"),
        "yp": then_default("yank inline {url:port}"),
    },
    "hint": {
        "<Return>": "hint-follow",
    },
}


for modes, mode_keymaps in keymaps.items():
    for mode in modes.split("+"):
        for keys, command in mode_keymaps.items():
            config.bind(keys, command, mode=mode)


catppuccin.setup(c, "macchiato", samecolorrows=False)
