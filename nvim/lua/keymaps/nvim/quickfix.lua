local util = require 'util'

util.declare_keymaps {
	opts = {
		silent = true,
	},
	n = {
		[']q'] = { ':cnext<CR>', 'Go to next [q]uickfix item' },
		['[q'] = { ':cprevious<CR>', 'Go to previous [q]uickfix item' },
		['<leader>qo'] = { ':copen<CR>', '[O]pen [q]uickfix list' },
		['<leader>qc'] = { ':cclose<CR>', '[C]lose [q]uickfix list' },
		['<leader>qn'] = { ':cnewer<CR>', 'Go to newer [q]uickfix list' },
		['<leader>qp'] = { ':colder<CR>', 'Go to older [q]uickfix list' },
	},
}

vim.api.nvim_create_autocmd('BufWinEnter', {
	group = vim.api.nvim_create_augroup('quickfix_group', { clear = true }),
	callback = function(opts)
		if vim.bo[opts.buf].filetype ~= 'qf' then
			return
		end

		vim.bo[opts.buf].modifiable = true

		util.declare_keymaps {
			opts = {
				silent = true,
				buffer = opts.buf,
			},
			n = {
				['J'] = ':cnext<CR>zz<C-w>w',
				['K'] = ':cprev<CR>zz<C-w>w',

				['<leader>r'] = { ':cdo s/// | update<C-Left><C-Left><Left><Left><Left>', 'Begin substitution' },
			},
		}
	end,
})
