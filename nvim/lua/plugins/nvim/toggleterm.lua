return {
	'akinsho/toggleterm.nvim',

	keys = '<leader>t',

	opts = {
		open_mapping = '<leader>t',
		insert_mappings = false,
		terminal_mappings = false,

		hide_numbers = true,

		persist_mode = false,
		close_on_exit = true,

		direction = 'float',
		auto_scroll = true,

		float_opts = {
			border = 'rounded',
		},

		shell = function()
			if vim.fn.has 'win32' == 1 then
				return 'powershell'
			end

			return vim.o.shell
		end,
	},

	config = function(_, opts)
		local util = require 'util'

		require('toggleterm').setup(opts)

		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = { 'term://*' },
			callback = function(event)
				util.declare_keymaps {
					opts = {
						silent = true,
						buffer = event.buf,
						remap = true,
					},
					t = {
						['<Esc>'] = [[<C-\><C-n>]],
					},
					n = {
						['<Esc>'] = '<leader>t',
					},
				}
			end,
		})

		-- vim.keymap.set('n', '<leader>ft', vim.cmd.TermSelect, { desc = '[S]earch [T]erminals' })
	end,
}
