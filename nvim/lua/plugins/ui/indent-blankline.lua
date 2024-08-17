return {
	'lukas-reineke/indent-blankline.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	priority = 1001,

	main = 'ibl',

	opts = {
		indent = {
			char = '┊',
			highlight = { 'FoldColumn' },
		},

		scope = {
			enabled = false,
		},

		whitespace = {
			remove_blankline_trail = true,
		},
	},
}
