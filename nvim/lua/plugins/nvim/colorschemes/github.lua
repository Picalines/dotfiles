return {
	'projekt0n/github-nvim-theme',

	lazy = false,

	priority = 1000,

	config = function()
		require('github-theme').setup {
			options = {
				styles = {
					comments = 'italic',
					keywords = 'bold',
				},
			},

			groups = {
				all = {
					NormalFloat = { link = 'Normal' },
					VertSplit = { link = 'WinBar' },
					FloatBorder = { guifg = '#e6edf3' },
				},
			},
		}
	end,
}
