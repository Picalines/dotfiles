return {
	'crispybaccoon/evergarden',

	lazy = false,

	priority = 1000,

	opts = {
		transparent_background = false,

		contrast_dark = 'hard',

		override_terminal = true,

		style = {
			tabline = { reverse = true, color = 'green' },
			search = { reverse = false, inc_reverse = true },
			types = { italic = true },
			keyword = { italic = true },
			comment = { italic = true },
		},

		overrides = {},
	},

	config = function(_, opts)
		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			pattern = '*',
			command = [[
				if g:colors_name ==# "evergarden"
					hi NoiceCursor gui=inverse
					hi! link NormalFloat Normal
				endif
			]],
		})

		require('evergarden').setup(opts)
	end,
}
