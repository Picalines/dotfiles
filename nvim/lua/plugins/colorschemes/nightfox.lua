return {
	'EdenEast/nightfox.nvim',

	lazy = false,

	priority = 1000,

	opts = {
		specs = {
			all = {
				bg0 = 'bg1',
			},
		},

		groups = {
			all = {
				WinSeparator = { fg = 'palette.fg3' },
			},
		},
	},
}
