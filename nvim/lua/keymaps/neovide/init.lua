local util = require 'util'

local function toggle_fullscreen()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

util.declare_keymaps {
	opts = {
		silent = true,
	},
	n = {
		['<C-+>'] = ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>',
		['<C-_>'] = ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>',

		['<leader><C-f>'] = toggle_fullscreen,
	},
}
