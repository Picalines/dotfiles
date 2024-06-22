local util = require 'util'
local persist = require 'persist'

local function toggle_fullscreen()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

local function zoom_fn(delta)
	return function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
		persist.save_item('neovide_scale_factor', vim.g.neovide_scale_factor)
	end
end

vim.api.nvim_create_user_command('ZoomIn', zoom_fn(0.1), {})
vim.api.nvim_create_user_command('ZoomOut', zoom_fn(-0.1), {})

util.declare_keymaps {
	[{ 'n', silent = true, nowait = true }] = {
		['<C-+>'] = ':ZoomIn<CR>',
		['<C-_>'] = ':ZoomOut<CR>',

		['<leader><C-f>'] = toggle_fullscreen,
	},
}
