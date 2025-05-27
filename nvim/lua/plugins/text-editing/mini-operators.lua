return {
	'echasnovski/mini.operators',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		evaluate = {
			prefix = 'g=',
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

		exchange = {
			prefix = '',
		},
	},
}
