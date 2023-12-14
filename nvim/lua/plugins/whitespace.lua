return {
	'johnfrankmorgan/whitespace.nvim',

	event = 'VeryLazy',

	opts = {
		highlight = 'DiffDelete',

		ignore_terminal = true,
		ignored_filetypes = {
			'TelescopePrompt',
			'help',
			'lazy',
			'lspinfo',
			'mason',
			'neo-tree',
			'noice',
			'toggleterm',
		},
	},
}
