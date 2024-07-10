local util = require 'util'

util.declare_keymaps {
	[{ 'n', silent = true }] = {
		[']q'] = { ':cnext<CR>zz', 'Go to next [q]uickfix item' },
		['[q'] = { ':cprevious<CR>zz', 'Go to previous [q]uickfix item' },
		['<leader>Q'] = { ':copen<CR>', '[O]pen [q]uickfix list' },
	},
}

util.per_filetype('qf', function(opts)
	vim.bo[opts.buf].modifiable = true

	util.declare_keymaps {
		[{ 'n', silent = true, buffer = opts.buf }] = {
			[{ 'q', '<leader>Q' }] = { ':cclose<CR>', '[C]lose [q]uickfix list' },
			['n'] = { ':cnewer<CR>', 'Go to newer [q]uickfix list' },
			['p'] = { ':colder<CR>', 'Go to older [q]uickfix list' },

			['J'] = ':cnext<CR>zz<C-w>w',
			['K'] = ':cprev<CR>zz<C-w>w',

			['<leader>r'] = { ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', 'Begin substitution' },
		},
	}
end)
