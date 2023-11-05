return {
	'akinsho/toggleterm.nvim',

	config = function()
		require('toggleterm').setup {
			open_mapping = '<C-t>',
			insert_mappings = false,

			hide_numbers = true,

			persist_mode = false,
			close_on_exit = true,

			direction = 'float',
			auto_scroll = true,

			float_opts = {
				border = 'rounded',
			},
		}

		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = { 'term://*' },
			callback = function()
				vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = 0 })
			end,
		})

		vim.keymap.set('n', '<leader>ft', vim.cmd.TermSelect, { desc = '[S]earch [T]erminals' })
	end,
}
