local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true, desc = 'Tab: %s' }] = {
		['<C-t>n'] = { '<Cmd>tabnew<CR>', 'new' },
		['<C-t>c'] = { '<Cmd>tabclose<CR>', 'close' },
		[']t'] = { '<Cmd>tabnext<CR>', 'next' },
		['[t'] = { '<Cmd>tabprev<CR>', 'prev' },
	},
}
