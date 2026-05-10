from pathlib import Path

from themes import brittle_hollow

c.input.forward_unbound_keys = "none"
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.tabs.mode_on_change = "persist"

c.keyhint.delay = 500

c.statusbar.position = "top"
c.statusbar.widgets = ["search_match", "progress", "url", "history"]
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.width = "12%"

c.fonts.default_family = "Iosevka Nerd Font"
c.fonts.default_size = "18pt"
c.fonts.hints = "18pt default_family"
c.fonts.tabs.selected = "bold"

c.tabs.title.format = "{audio}{current_title}"
c.tabs.title.format_pinned = c.tabs.title.format

config.load_autoconfig()

c.content.blocking.enabled = False

c.hints.auto_follow = "always"
c.hints.selectors["buttons"] = [
    "select",
    "button",
    "details > summary",
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

c.input.mode_override = "normal"
c.bindings.default["passthrough"].clear()
c.bindings.default["normal"].clear()
c.bindings.default["insert"].clear()
c.bindings.default["hint"].clear()

c.aliases["js-unfocus"] = "jseval -q document.activeElement.blur()"
c.aliases["keyboard-layout-us"] = (
    f"spawn -d -- python3 {Path('~/bin/keyboard-layout').expanduser().as_posix()} us"
)
c.aliases["mode-leave-reset"] = (
    f"mode-leave ;; {c.aliases["keyboard-layout-us"]} ;; {c.aliases["js-unfocus"]}"
)


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


keymaps = {
    "[command+prompt+yesno+register+hint]": {
        "<Escape>": "mode-leave",
    },
    "[passthrough]": {
        "<Shift-Escape>": c.aliases["mode-leave-reset"],
    },
    "[insert]": {
        "<Escape>": c.aliases["mode-leave-reset"],
    },
    "[normal+insert]": {
        "<Ctrl-d>": "scroll page-down",
        "<Ctrl-u>": "scroll page-up",
        "<Ctrl-i>": "tab-focus stack-next",
        "<Ctrl-o>": "tab-focus stack-prev",
        "<Ctrl-j>": "forward",
        "<Ctrl-k>": "back",
        "<Ctrl-n>": "search-next",
        "<Ctrl-Shift-n>": "search-prev",
    },
    "[command]": {
        "<Ctrl-n>": "fake-key -g <Down>",
        "<Ctrl-Shift-n>": "fake-key -g <Up>",
        "<Return>": "command-accept",
    },
    "[normal]": {
        "<Shift-Return>": "mode-enter passthrough",
        "<Escape>": "search ;; fake-key <Escape>",
        "<Return>": "mode-enter insert",
        "<Space>": "fake-key <Space>",
        ("<Meta-c>", "<Ctrl-c>"): "yank -q selection",
        (":", ";"): "cmd-set-text :",
        "f": "cmd-set-text -s :tab-select",
        "H": "tab-prev",
        "J": "tab-next",
        "K": "tab-prev",
        "L": "tab-next",
        "h": "scroll left",
        "j": "scroll down",
        "k": "scroll up",
        "l": "scroll right",
        "r": "reload",
        "R": "reload -f",
        "o": "cmd-set-text -s :open",
        "O": "cmd-set-text -s :open -t",
        "e": "cmd-set-text :open {url:pretty}",
        "x": "tab-close",
        "X": "tab-close -p",
        "u": "undo",
        "/": "cmd-set-text /",
        "?": "cmd-set-text ?",
        "n": "search-next",
        "N": "search-prev",
        "g": "scroll top",
        "G": "scroll bottom",
        ("+", "="): "zoom-in",
        ("-", "_"): "zoom-out",
        "m": "quickmark-save",
        "t": {
            "<Escape>": "clear-keychain",
            "o": "tab-only",
            "h": "tab-move -",
            "j": "tab-move +",
            "k": "tab-move -",
            "l": "tab-move +",
        },
        "y": {
            "<Escape>": "clear-keychain",
            "y": "yank",
            "s": "yank selection",
            "t": "yank title",
            "d": "yank domain",
            "p": "yank inline {url:port}",
        },
        "w": {
            "<Escape>": "clear-keychain",
            "o": "window-only",
            "d": "devtools right",
            "D": "devtools window",
            "n": "tab-give",
            "t": "cmd-set-text -s :tab-take",
        },
        "s": {
            "<Escape>": "clear-keychain",
            "o": "cmd-set-text -s :session-load -c",
            "O": "cmd-set-text -s :session-load",
            "s": "cmd-set-text -s :session-save",
            "d": "cmd-set-text -s :session-delete",
        },
        "d": {
            "<Escape>": "clear-keychain",
            "o": "download-open",
            "c": "download-clear",
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
    },
}

bind_keymaps(keymaps)

brittle_hollow.setup(c)
