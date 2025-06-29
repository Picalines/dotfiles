return {
	'MeanderingProgrammer/render-markdown.nvim',

	ft = { 'markdown', 'codecompanion' },

	opts = {
		file_types = { 'markdown', 'codecompanion' },

		render_modes = true,

		heading = {
			position = 'inline',
			signs = {},
			icons = {},
			width = { 'full', 'block' },
			left_pad = 1,
			right_pad = 1,
		},

		code = {
			sign = false,
			style = 'normal',
			border = 'thin',
			left_pad = 1,
		},

		checkbox = {
			bullet = true,
			right_pad = 0,
		},

		bullet = {
			icons = { '', '', '󰨐', '󰜌' },
			left_pad = 1,
		},
	},
}
