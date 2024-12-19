local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true, desc = 'Tab: %s' }] = {
		['<C-t>n'] = { '<Cmd>tabnew<CR>', 'new' },
		['<C-t>c'] = { '<Cmd>tabclose<CR>', 'close' },
		['<C-}>'] = { '<Cmd>tabnext<CR>', 'next' },
		['<C-{>'] = { '<Cmd>tabprev<CR>', 'prev' },
	},
}
