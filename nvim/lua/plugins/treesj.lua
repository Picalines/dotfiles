return {
	'Wansmer/treesj',

	dependencies = { 'nvim-treesitter/nvim-treesitter' },

	keys = { '<leader>m' },

	config = function()
		local treesj = require 'treesj'

		treesj.setup {
			use_default_keymaps = false,
		}

		vim.keymap.set('n', '<leader>m', treesj.toggle, { desc = 'Split/Join node' })
	end,
}
