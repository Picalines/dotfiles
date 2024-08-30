local autocmd = require 'util.autocmd'
local persist = require 'util.persist'

vim.g.neovide_refresh_rate = 90

vim.g.neovide_show_border = true

vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_floating_blur_amount_x = 0
vim.g.neovide_floating_blur_amount_y = 0

vim.o.guifont = 'Hack Nerd Font Mono'

vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_position_animation_length = 0.1

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

vim.g.neovide_scale_factor = persist.get_item('neovide_scale_factor', 1)

autocmd.on('VimResized', '*', function()
	persist.save_item('neovide_scale_factor', vim.g.neovide_scale_factor)
end)
