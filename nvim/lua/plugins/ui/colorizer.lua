return {
	'catgoose/nvim-colorizer.lua',

	event = 'BufReadPre',

	opts = {
		filetypes = { '*' },

		parsers = {
			names = { enable = false },
		},
	},
}
