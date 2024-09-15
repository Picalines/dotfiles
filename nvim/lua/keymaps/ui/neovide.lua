local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

local neovide_scale_factor = signal.new(1)
signal.persist(neovide_scale_factor, 'neovide_scale_factor')
signal.watch(function()
	vim.g.neovide_scale_factor = neovide_scale_factor()
end)

local neovide_transparency = signal.new(1)
signal.persist(neovide_transparency, 'neovide_transparency')
signal.watch(function()
	vim.g.neovide_transparency = neovide_transparency()
	vim.g.neovide_window_blurred = true
end)

local function toggle_fullscreen()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

local function toggle_transparency()
	neovide_transparency(neovide_transparency() == 1 and 0.75 or 1)
end

local function zoom(delta)
	neovide_scale_factor(neovide_scale_factor() + delta)
end

vim.api.nvim_create_user_command('ZoomIn', func.curry(zoom, 0.1), {})
vim.api.nvim_create_user_command('ZoomOut', func.curry(zoom, -0.1), {})

keymap.declare {
	[{ 'n', silent = true, nowait = true }] = {
		['<C-+>'] = { '<Cmd>ZoomIn<CR>', 'Neovide: Increase font size' },
		['<C-_>'] = { '<Cmd>ZoomOut<CR>', 'Neovide: Decrease font size' },

		['<leader><leader>f'] = { toggle_fullscreen, 'Neovide: Toggle Fullscreen' },
		['<leader><leader>t'] = { toggle_transparency, 'Neovide: toggle transparency' },
	},
}
