local keymap = require 'util.keymap'
local func = require 'util.func'
local persist = require 'util.persist'

local function toggle_fullscreen()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

local function zoom(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
	persist.save_item('neovide_scale_factor', vim.g.neovide_scale_factor)
end

vim.api.nvim_create_user_command('ZoomIn', func.curry(zoom, 0.1), {})
vim.api.nvim_create_user_command('ZoomOut', func.curry(zoom, -0.1), {})

keymap.declare {
	[{ 'n', silent = true, nowait = true }] = {
		['<C-+>'] = { '<Cmd>ZoomIn<CR>', 'Increase font size' },
		['<C-_>'] = { '<Cmd>ZoomOut<CR>', 'Decrease font size' },

		['<leader><leader>f'] = { toggle_fullscreen, 'Toggle Fullscreen' },
	},
}
