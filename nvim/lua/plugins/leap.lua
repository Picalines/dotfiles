return {
	'ggandor/leap.nvim',

	event = 'VeryLazy',

	dependencies = {
		{
			'ggandor/flit.nvim',
			opts = {},
		},
	},

	config = function()
		local leap = require 'leap'

		leap.add_default_mappings()
	end,
}
