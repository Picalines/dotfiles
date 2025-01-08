local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', desc = 'Git: %s' }] = {
		['<leader>v'] = { '<Cmd>Git<CR>', 'status' },
		['<leader>V'] = { ':Git ', 'command' },
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

		augroup:on('FileType', { 'gitcommit', 'gitrebase' }, function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf, nowait = true, desc = 'Git: %s' }] = {
					['<leader>y'] = { '<Cmd>w | bd<CR>', 'accept' },
					['<leader>n'] = { 'ggdG<Cmd>w | bd<CR>', 'cancel' },
				},
			}
		end)

		augroup:on('FileType', 'fugitive', function(event)
			autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L', { once = true })
		end)
	end,
}
