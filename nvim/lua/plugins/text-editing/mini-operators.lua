return {
	'echasnovski/mini.operators',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		evaluate = {
			prefix = 'g=',
		},

		exchange = {
			prefix = 'gx',
			reindent_linewise = true,
		},

		multiply = {
			prefix = 'gm',
		},

		replace = {
			prefix = 'gr',
			reindent_linewise = true,
		},

		sort = {
			prefix = 'go',
		},
	},
}
