return {
	'nvim-mini/mini.operators',

	event = 'VeryLazy',

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
			prefix = 'cx',
		},
	},
}
