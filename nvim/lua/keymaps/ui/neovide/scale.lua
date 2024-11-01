local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

local neovide_scale_factor = signal.new(1)
signal.persist(neovide_scale_factor, 'neovide.scale_factor')
signal.watch(function()
	vim.g.neovide_scale_factor = neovide_scale_factor()
end)

local function zoom(delta)
	neovide_scale_factor(neovide_scale_factor() + delta)
end

vim.api.nvim_create_user_command('ZoomIn', func.curry(zoom, 0.1), {})
vim.api.nvim_create_user_command('ZoomOut', func.curry(zoom, -0.1), {})

keymap.declare {
	[{ 'n', nowait = true }] = {
		['<C-+>'] = { '<Cmd>ZoomIn<CR>', 'Neovide: Increase font size' },
		['<C-_>'] = { '<Cmd>ZoomOut<CR>', 'Neovide: Decrease font size' },
	},
}
