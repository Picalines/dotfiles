local util = require 'util'

util.declare_keymaps {
	opts = {
		silent = true,
	},

	n = {
		['[d'] = { vim.diagnostic.goto_prev, 'Go to previous [d]iagnostic' },
		[']d'] = { vim.diagnostic.goto_next, 'Go to next [d]iagnostic' },
	},
}
