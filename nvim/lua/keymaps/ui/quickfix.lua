local keymap = require 'util.keymap'
local autocmd = require 'util.autocmd'

keymap.declare {
	[{ 'n', silent = true }] = {
		[']q'] = { ':cnext<CR>zz', 'Go to next quickfix item' },
		['[q'] = { ':cprevious<CR>zz', 'Go to previous quickfix item' },
		['<leader>Q'] = { ':copen<CR>', 'Open quickfix list' },
	},
}

autocmd.per_filetype('qf', function(opts)
	vim.bo[opts.buf].modifiable = true

	keymap.declare {
		[{ 'n', silent = true, buffer = opts.buf }] = {
			[{ 'q', '<leader>Q' }] = { ':cclose<CR>', 'Close quickfix list' },
			['n'] = { ':cnewer<CR>', 'Go to newer quickfix list' },
			['p'] = { ':colder<CR>', 'Go to older quickfix list' },

			['J'] = ':cnext<CR>zz<C-w>w',
			['K'] = ':cprev<CR>zz<C-w>w',

			['<leader>r'] = { ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', 'Begin substitution' },
		},
	}
end)
