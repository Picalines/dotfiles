local util = require 'util'

util.declare_keymaps {
	opts = {
		silent = true,
	},
	n = {
		['<leader>wa'] = { ':wa! | :qa!<CR>', '[W]rite [a]ll and quit' },
	},
}
