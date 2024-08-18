local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true }] = {
		['<C-t>e'] = { '<Cmd>tabnew<CR>', 'Empty tab' },
		['<C-t>c'] = { '<Cmd>tabclose<CR>', 'Close tab' },
		[']t'] = { '<Cmd>tabnext<CR>', 'Next tab' },
		['[t'] = { '<Cmd>tabprev<CR>', 'Prev tab' },
		['>t'] = { '<Cmd>tabmove +<CR>', 'Move tab right' },
		['<t'] = { '<Cmd>tabmove -<CR>', 'Move tab left' },
	},
}
