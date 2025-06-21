local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

vim.o.guifont = 'Iosevka Nerd Font Mono'

local neovide_scale_factor = signal.new(1)
signal.persist(neovide_scale_factor, 'neovide.scale_factor')
signal.watch(function()
	vim.g.neovide_scale_factor = neovide_scale_factor()
end)

local neovide_opacity = signal.new(1)
signal.persist(neovide_opacity, 'neovide.opacity')
signal.watch(function()
	vim.g.neovide_opacity = neovide_opacity()
	vim.g.neovide_window_blurred = true
end)

local function zoom(delta)
	neovide_scale_factor(neovide_scale_factor() + delta)
end

local function toggle_opacity()
	neovide_opacity(neovide_opacity() == 1 and 0.95 or 1)
end

keymap {
	[{ 'n', desc = 'Neovide: %s' }] = {
		['<D-=>'] = { func.curry(zoom, 0.1), 'zoom in' },
		['<D-->'] = { func.curry(zoom, -0.1), 'zoom out' },

		['<leader>ug'] = { toggle_opacity, 'toggle opacity' },

		[{ os = 'macos' }] = {
			['<D-w>'] = { '<Cmd>wa | qa!<CR>', 'write all and quit' },
			['<D-n>'] = { '<Cmd>silent !open --new -b com.neovide.neovide<CR>', 'new window' },
		},
	},
}
