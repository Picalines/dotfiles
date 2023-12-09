local util = require 'util'

local function zoom(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

util.declare_keymaps {
	n = {
		['<C-=>'] = util.curry(zoom, 1.1),
		['<C-->'] = util.curry(zoom, 1 / 1.1),
	},
}
