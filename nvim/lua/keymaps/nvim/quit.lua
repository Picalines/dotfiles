local util = require 'util'

util.declare_keymaps {
	[{ 'n', silent = true }] = {
		['<leader>wa'] = { ':wa! | :qa!<CR>', '[W]rite [a]ll and quit' },
	},
}
