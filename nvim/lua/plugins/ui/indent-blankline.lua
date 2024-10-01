return {
	'lukas-reineke/indent-blankline.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	priority = 1001,

	main = 'ibl',

	opts = {
		indent = {
			char = '┊',
			tab_char = '┊',
			highlight = { 'Whitespace' },
		},

		scope = {
			enabled = false,
		},

		whitespace = {
			remove_blankline_trail = true,
		},
	},
}
