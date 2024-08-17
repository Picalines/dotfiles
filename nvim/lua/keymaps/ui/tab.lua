local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true }] = {
		['<C-t>e'] = { ':tabnew<CR>', 'Empty tab' },
		['<C-t>c'] = { ':tabclose<CR>', 'Close tab' },
		[']t'] = { ':tabnext<CR>', 'Next tab' },
		['[t'] = { ':tabprev<CR>', 'Prev tab' },
		['>t'] = { ':tabmove +<CR>', 'Move tab right' },
		['<t'] = { ':tabmove -<CR>', 'Move tab left' },
	},
}
