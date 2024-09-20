local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true }] = {
		['<C-t>o'] = { '<Cmd>tabnew<CR>', 'Empty tab' },
		['<C-t>c'] = { '<Cmd>tabclose<CR>', 'Close tab' },
		['<C-}>'] = { '<Cmd>tabnext<CR>', 'Next tab' },
		['<C-{>'] = { '<Cmd>tabprev<CR>', 'Prev tab' },
	},
}
