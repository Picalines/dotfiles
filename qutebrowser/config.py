from pathlib import Path

from themes import brittle_hollow

c.input.forward_unbound_keys = "none"
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.tabs.mode_on_change = "persist"

c.keyhint.delay = 2000

c.statusbar.position = "top"
c.statusbar.widgets = ["search_match", "progress", "url", "history"]
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.width = "12%"

c.fonts.default_family = "IosevkaTerm Nerd Font Mono"
c.fonts.default_size = "18pt"
c.fonts.hints = "16pt default_family"
c.fonts.tabs.selected = "bold"

c.tabs.title.format = "{audio}{current_title}"
c.tabs.title.format_pinned = c.tabs.title.format

config.load_autoconfig()

c.content.blocking.enabled = False

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
c.bindings.default["passthrough"].clear()
c.bindings.default["normal"].clear()
c.bindings.default["insert"].clear()
c.bindings.default["hint"].clear()


def bind_keymaps(keymaps, prefix="", mode=None):
    for keys, value in keymaps.items():
        keys = (keys,) if isinstance(keys, str) else keys
        for key in keys:
            if key.startswith("[") and key.endswith("]"):
                modes = key[1:-1].split("+")
                for mode in modes:
                    bind_keymaps(value, prefix, mode)
            elif isinstance(value, dict):
                bind_keymaps(value, prefix + key, mode)
            else:
                config.bind(prefix + key, value, mode=mode)


then_default = lambda cmd: cmd + " ;; cmd-later 5 mode-enter insert"
to_default = then_default("nop")

switch_to_us_layout = (
    f"spawn -d -- python3 {Path('~/bin/keyboard-layout').expanduser().as_posix()} us"
)

keymaps = {
    "[passthrough]": {
        "<Alt-Shift-z>": to_default,
    },
    "[command+prompt+yesno+register+hint]": {
        "<Escape>": then_default("mode-leave"),
    },
    "[insert]": {
        "<Alt-z>": f"mode-enter normal ;; {switch_to_us_layout}",
        "<Alt-я>": f"mode-enter normal ;; {switch_to_us_layout}",
        "<Alt-o>": "cmd-set-text -s :open -t",
        "<Alt-Shift-o>": "cmd-set-text -s :open",
        "<Alt-s>": "cmd-set-text -s :tab-select",
        "<Alt-h>": "tab-prev",
        "<Alt-j>": "tab-next",
        "<Alt-k>": "tab-prev",
        "<Alt-l>": "tab-next",
        "<Alt-q>": "tab-close",
        "<Alt-r>": then_default("reload"),
        "<Alt-Shift-r>": then_default("reload -f"),
        "<Alt-f>": "cmd-set-text /",
        "<Alt-n>": "search-next",
        "<Alt-Shift-n>": "search-prev",
    },
    "[normal+insert]": {
        "<Alt-Shift-z>": "mode-enter passthrough",
        "<Ctrl-d>": "scroll-page 0 0.5",
        "<Ctrl-u>": "scroll-page 0 -0.5",
        "<Ctrl-i>": "forward",
        "<Ctrl-o>": "back",
        "<back>": "back",
        "<forward>": "forward",
    },
    "[command]": {
        "<Ctrl-n>": "fake-key -g <Down>",
        "<Ctrl-Shift-n>": "fake-key -g <Up>",
        "<Return>": then_default("command-accept"),
    },
    "[normal]": {
        "<Escape>": to_default,
        (":", ";"): "cmd-set-text :",
        ("h", "<Ctrl-h>"): then_default("tab-prev"),
        ("j", "<Ctrl-j>"): then_default("tab-next"),
        ("k", "<Ctrl-k>"): then_default("tab-prev"),
        ("l", "<Ctrl-l>"): then_default("tab-next"),
        ("r", "<Ctrl-r>"): then_default("reload"),
        "R": then_default("reload -f"),
        "o": "cmd-set-text -s :open",
        "O": "cmd-set-text -s :open -t",
        "x": then_default("tab-close"),
        "X": then_default("tab-close -p"),
        "u": then_default("undo"),
        "/": "cmd-set-text /",
        "?": "cmd-set-text ?",
        "n": "search-next",
        "N": "search-prev",
        "G": then_default("scroll bottom"),
        ("+", "="): "zoom-in",
        ("-", "_"): "zoom-out",
        "m": "quickmark-save",
        "s": "cmd-set-text -s :set",
        "f": "cmd-set-text -s :tab-select",
        "t": {
            "<Escape>": to_default,
            "p": then_default("config-cycle tabs.position left top"),
            "o": then_default("tab-only"),
            "h": "tab-prev ;; mode-enter normal ;; fake-key -g t",
            "j": "tab-next ;; mode-enter normal ;; fake-key -g t",
            "k": "tab-prev ;; mode-enter normal ;; fake-key -g t",
            "l": "tab-next ;; mode-enter normal ;; fake-key -g t",
            "H": "tab-move - ;; mode-enter normal ;; fake-key -g t",
            "J": "tab-move + ;; mode-enter normal ;; fake-key -g t",
            "K": "tab-move - ;; mode-enter normal ;; fake-key -g t",
            "L": "tab-move + ;; mode-enter normal ;; fake-key -g t",
            "x": "tab-close ;; mode-enter normal ;; fake-key -g t",
            "X": "tab-close -p ;; mode-enter normal ;; fake-key -g t",
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
                ("y", "yank"),
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
        "d": {
            "o": then_default("download-open"),
            "c": then_default("download-clear"),
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

brittle_hollow.setup(c)
