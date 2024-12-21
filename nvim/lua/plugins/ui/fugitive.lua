local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n' }] = {
		['<leader>v'] = '<Cmd>Git<CR>',
	},
}

return {
	'tpope/vim-fugitive',

	cmd = { 'Git', 'G' },

	config = function()
		local autocmd = require 'util.autocmd'

		local augroup = autocmd.group 'fugitive'

		augroup:on('BufEnter', 'fugitive://*', function(event)
			vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })

			keymap.declare {
				[{ 'n', buffer = event.buf, desc = 'Git: %s' }] = {
					['<leader>v'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
					['q'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
				},
			}
		end)
	end,
}
