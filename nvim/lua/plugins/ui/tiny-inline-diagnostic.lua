return {
	'rachartier/tiny-inline-diagnostic.nvim',

	event = 'VeryLazy',

	opts = {
		preset = 'powerline',

		hi = {
			background = 'None',
		},

		options = {
			use_icons_from_diagnostic = true,
			show_all_diags_on_cursorline = true,

			overflow = {
				mode = 'wrap',
				padding = 1,
			},
		},
	},

	config = function(_, opts)
		require('tiny-inline-diagnostic').setup(opts)

		vim.diagnostic.config { virtual_text = false }
	end,
}
