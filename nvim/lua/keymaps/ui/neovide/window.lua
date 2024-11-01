local keymap = require 'util.keymap'
local signal = require 'util.signal'

local neovide_transparency = signal.new(1)
signal.persist(neovide_transparency, 'neovide.transparency')
signal.watch(function()
	vim.g.neovide_transparency = neovide_transparency()
	vim.g.neovide_window_blurred = true
end)

local function toggle_transparency()
	neovide_transparency(neovide_transparency() == 1 and 0.75 or 1)
end

keymap.declare {
	[{ 'n', nowait = true }] = {
		['<leader><leader>t'] = { toggle_transparency, 'Neovide: Toggle transparency' },
	},
}
