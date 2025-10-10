return {
	'willothy/flatten.nvim',

	lazy = false,
	priority = 9999,

	opts = {
		window = {
			open = 'smart',
			focus = 'last',
		},

		hooks = {
			post_open = function(args)
				local autocmd = require 'util.autocmd'
				local keymap = require 'util.keymap'

				vim.api.nvim_set_current_win(args.winnr)

				if args.is_blocking then
					autocmd.buffer(args.bufnr):on(
						'BufWritePost',
						vim.schedule_wrap(function()
							require('snacks').bufdelete.delete(args.bufnr)
						end)
					)

					keymap {
						[{ 'n', buffer = args.bufnr }] = {
							['<CR>'] = { '<Cmd>w<CR>' },
						},
					}
				end
			end,

			block_end = vim.schedule_wrap(function()
				vim.cmd.wincmd 'p'
			end),
		},
	},
}
