return {
	'j-hui/fidget.nvim',

	lazy = true,
	event = { 'LspAttach' },

	opts = {
		progress = {
			display = {
				done_icon = '',
			},
		},
		notification = {
			window = {
				border = 'rounded',
				winblend = 0,
				x_padding = 0,
				align = 'top',
			},
		},
	},
}
