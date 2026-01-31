config.load_autoconfig()

c.statusbar.position = 'bottom'
c.tabs.position = 'top'

c.fonts.default_size = '18pt'
c.fonts.default_family = 'IosevkaTerm Nerd Font Mono'
c.fonts.tabs.selected = 'bold'

c.tabs.title.format = '{audio}{current_title}'
c.tabs.title.format_pinned = '[P]{audio}{current_title}'

config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur()', mode='insert')

config.source('gruvbox.py')
