return {
	'akinsho/toggleterm.nvim',

	keys = '<leader>t',

	opts = {
		open_mapping = '<leader>t',
		insert_mappings = false,
		terminal_mappings = false,

		hide_numbers = true,
		shade_terminals = false,

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
		local terminal = require 'toggleterm.terminal'

		require('toggleterm').setup(opts)

		local function send_exit_key()
			local current_term = terminal.get_focused_id()
			if current_term == nil then
				return
			end

			terminal.get(current_term):send ''
		end

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
						['<C-[>'] = send_exit_key,
						['<C-p>'] = [[<C-\><C-n>pi]],
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
