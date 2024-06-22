local util = require 'util'

util.declare_keymaps {
	[{ 'n', silent = true }] = {
		['<C-t>e'] = { ':tabnew<CR>', '[E]empty [t]ab' },
		['<C-t>c'] = { ':tabclose<CR>', 'Close [t]ab' },
		[']t'] = { ':tabnext<CR>', 'Next [t]ab' },
		['[t'] = { ':tabprev<CR>', 'Prev [t]ab' },
		['>t'] = { ':tabmove +<CR>', 'Move [t]ab right' },
		['<t'] = { ':tabmove -<CR>', 'Move [t]ab left' },
	},
}
