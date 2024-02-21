local util = require 'util'

local function zoom(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local function toggle_fullscreen()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

util.declare_keymaps {
	n = {
		['<C-=>'] = util.curry(zoom, 1.1),
		['<C-->'] = util.curry(zoom, 1 / 1.1),

		['<leader><C-f>'] = toggle_fullscreen,
	},
}
