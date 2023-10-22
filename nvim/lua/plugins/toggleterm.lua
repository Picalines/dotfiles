return {
	'akinsho/toggleterm.nvim',

	config = function()
		require('toggleterm').setup {
			open_mapping = '<C-\\>',

			hide_numbers = true,

			persist_mode = false,
			close_on_exit = true,

			direction = 'float',
			auto_scroll = true,

			float_opts = {
				border = 'rounded',
			},
		}

		local function on_open()
			local function map_key(mode, key, cmd)
				return vim.keymap.set(mode, key, cmd, { buffer = 0 })
			end

			map_key('t', '<Esc>', [[<C-\><C-n>]])
		end

		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = { 'term://*' },
			callback = on_open,
		})

		vim.keymap.set('n', '<leader>ft', vim.cmd.TermSelect, { desc = '[S]earch [T]erminals' })
	end,
}
