return {
	'crispybaccoon/evergarden',

	lazy = false,

	priority = 1000,

	opts = {
		theme = {
			variant = 'winter',
		},

		editor = {
			transparent_background = false,
			override_terminal = true,
		},

		style = {
			tabline = { reverse = true, color = 'green' },
			search = { reverse = false, inc_reverse = true },
			types = { italic = true },
			keyword = { italic = true },
			comment = { italic = true },
			sign = {},
		},
	},
}
