return {
	'rachartier/tiny-inline-diagnostic.nvim',

	event = 'VeryLazy',

	opts = {
		preset = 'powerline',

		hi = {
			background = 'None',
		},

		options = {
			throttle = 0,

			enable_on_insert = true,
			enable_on_select = true,

			use_icons_from_diagnostic = true,
			show_all_diags_on_cursorline = true,

			overflow = {
				mode = 'wrap',
				padding = 1,
			},
		},
	},

	init = function()
		vim.diagnostic.config { virtual_text = false }
	end,
}
