local keymap = require 'util.keymap'
local signal = require 'util.signal'

local neovide_opacity = signal.new(1)
signal.persist(neovide_opacity, 'neovide.opacity')
signal.watch(function()
	vim.g.neovide_opacity = neovide_opacity()
	vim.g.neovide_window_blurred = true
end)

local function toggle_opacity()
	neovide_opacity(neovide_opacity() == 1 and 0.75 or 1)
end

keymap {
	[{ 'n', nowait = true, desc = 'UI: %s' }] = {
		['<leader>ug'] = { toggle_opacity, 'Neovide: Toggle opacity' },
	},
}
