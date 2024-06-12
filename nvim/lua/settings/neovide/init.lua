local persist = require 'persist'

vim.g.neovide_refresh_rate = 90

vim.o.guifont = 'Hack Nerd Font Mono'

vim.g.neovide_scale_factor = persist.get_item('neovide_scale_factor', 0.9)

vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_position_animation_length = 0.1
