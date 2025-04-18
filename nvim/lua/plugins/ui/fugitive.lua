local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', desc = 'Git: %s' }] = {
		['<leader>gg'] = { '<Cmd>vert botright Git<CR>', 'status' },
		['<leader>G'] = { ':Git ', 'command' },

		['<leader>gS'] = { '<Cmd>Git add %<CR>', 'stage file' },
		['<leader>gU'] = { '<Cmd>Git restore --staged %<CR>', 'unstage file' },
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
			vim.api.nvim_set_option_value('number', false, { win = vim.fn.bufwinid(event.buf) })
			vim.api.nvim_set_option_value('relativenumber', false, { win = vim.fn.bufwinid(event.buf) })

			keymap.declare {
				[{ 'n', buffer = event.buf, desc = 'Git: %s' }] = {
					['<leader>gg'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
					['q'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
				},
			}
		end)

		augroup:on('FileType', { 'gitcommit', 'gitrebase' }, function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf, nowait = true, desc = 'Git: %s' }] = {
					['<leader>w'] = { '<Cmd>w | bd<CR>', 'accept' },
					['q'] = { 'ggdG<Cmd>w | bd<CR>', 'cancel' },
				},
			}
		end)
	end,
}
