local keymap = require 'util.keymap'

keymap {
	[{ 'n', silent = true, desc = 'Buffer: %s' }] = {
		[']b'] = { '<Cmd>bn<CR>', 'next' },
		['[b'] = { '<Cmd>bp<CR>', 'previous' },
		['<ledaer>b]'] = { '<Cmd>bn<CR>', 'next' },
		['<leader>b['] = { '<Cmd>bp<CR>', 'previous' },

		['<leader>bn'] = { '<Cmd>enew<CR>', 'new' },
		['<leader>br'] = { '<Cmd>e<CR>', 'reload' },
	},
}
