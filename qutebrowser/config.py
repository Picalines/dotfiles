from themes import catppuccin

config.load_autoconfig()

c.input.forward_unbound_keys = "none"
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.tabs.mode_on_change = "persist"
c.input.mode_override = ""

c.statusbar.position = "bottom"
c.statusbar.widgets = ["search_match", "progress", "url", "history"]
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.width = "17%"

c.fonts.default_family = "IosevkaTerm Nerd Font Mono"
c.fonts.default_size = "18pt"
c.fonts.hints = "16pt default_family"
c.fonts.tabs.selected = "bold"

c.tabs.title.format = "{audio}{current_title}"
c.tabs.title.format_pinned = c.tabs.title.format

c.hints.selectors["buttons"] = [
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


def bind_keymaps(keymaps, prefix="", mode=None):
    for key, value in keymaps.items():
        if key.startswith("[") and key.endswith("]"):
            modes = key[1:-1].split("+")
            for mode in modes:
                bind_keymaps(value, prefix, mode)
        elif isinstance(value, dict):
            bind_keymaps(value, prefix + key, mode)
        else:
            config.bind(prefix + key, value, mode=mode)


then_default = lambda cmd: cmd + " ;; mode-enter insert"
to_default = then_default("nop")

keymaps = {
    "[insert]": {
        "<Ctrl-z>": "mode-enter normal",
    },
    "[passthrough]": {
        "<Shift+Escape>": to_default,
    },
    "[command+prompt+yesno+register+hint]": {
        "<Escape>": then_default("mode-leave"),
    },
    "[normal+insert]": {
        "<Ctrl-d>": "scroll-page 0 0.5",
        "<Ctrl-u>": "scroll-page 0 -0.5",
        "<Ctrl-i>": "forward",
        "<Ctrl-o>": "back",
        "<back>": "back",
        "<forward>": "forward",
    },
    "[normal]": {
        "<Escape>": to_default,
        "<Ctrl-z>": then_default("fake-key <Ctrl-z>"),
        "<Ctrl-v>": "mode-enter passthrough",
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
        "=": "zoom-in",
        "-": "zoom-out",
        "_": "zoom-out",
        "m": "quickmark-save",
        "s": "cmd-set-text -s :set",
        "T": "cmd-set-text -s :tab-select",
        "t": {
            "<Escape>": to_default,
            "p": then_default("config-cycle tabs.position left top"),
            "o": then_default("tab-only"),
            "h": "tab-move - ;; mode-enter normal ;; fake-key -g t",
            "j": "tab-move + ;; mode-enter normal ;; fake-key -g t",
            "k": "tab-move - ;; mode-enter normal ;; fake-key -g t",
            "l": "tab-move + ;; mode-enter normal ;; fake-key -g t",
            "w": then_default("tab-give"),
            "W": "cmd-set-text -s :tab-take",
            "m": then_default("tab-mute"),
        },
        **{
            f"{g}{a}": f"hint {group} {action}"
            for g, group in (
                ("a", "links"),
                ("i", "inputs"),
                ("b", "buttons"),
                ("p", "images"),
            )
            for a, action in (
                ("f", "normal"),
                ("c", "normal"),
                ("O", "tab-fg"),
                ("d", "download"),
                ("r", "right-click"),
                ("h", "hover"),
            )
        },
        "g": {
            "<Escape>": to_default,
            "o": "cmd-set-text :open {url:pretty}",
            "g": then_default("scroll top"),
            "h": "cmd-set-text -s :help -t",
            "c": then_default("config-source"),
        },
        "y": {
            "<Escape>": to_default,
            "y": then_default("yank"),
            "t": then_default("yank title"),
            "d": then_default("yank domain"),
            "p": then_default("yank inline {url:port}"),
        },
        "w": {
            "<Escape>": to_default,
            "d": then_default("devtools right"),
            "D": then_default("devtools window"),
        },
    },
    "[hint]": {
        "<Return>": "hint-follow",
    },
}

bind_keymaps(keymaps)

catppuccin.setup(c, "macchiato", samecolorrows=False)
