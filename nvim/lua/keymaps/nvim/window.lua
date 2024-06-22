local util = require 'util'

util.declare_keymaps {
	[{ 'n', silent = true }] = {
		['<C-j>'] = { '<C-W>j', 'Move to bottom window' },
		['<C-k>'] = { '<C-W>k', 'Move to upper window' },
		['<C-h>'] = { '<C-W>h', 'Move to left window' },
		['<C-l>'] = { '<C-W>l', 'Move to right window' },

		['<S-Down>'] = { '<C-W>-', 'Decrease window height' },
		['<S-Up>'] = { '<C-W>+', 'Increase window height' },
		['<S-Left>'] = { '<C-W><', 'Decrease window width' },
		['<S-Right>'] = { '<C-W>>', 'Increase window width' },

		['<C-W>nx'] = { ':NoiceDismiss<CR>', 'Dismiss [N]otifications' },
		['<C-W>nf'] = { ':NoicePick<CR>', '[F]ind [N]otification' },
	},
}
