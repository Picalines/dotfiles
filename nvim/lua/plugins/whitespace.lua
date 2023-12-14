return {
	'johnfrankmorgan/whitespace.nvim',
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
