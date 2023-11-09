return {
	'ggandor/leap.nvim',

	dependencies = {
		{
			'ggandor/flit.nvim',
			opts = {},
		},
	},

	config = function()
		local leap = require 'leap'

		leap.add_default_mappings()

		vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
	end,
}
