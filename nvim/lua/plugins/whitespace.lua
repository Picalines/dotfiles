return {
	'johnfrankmorgan/whitespace.nvim',
	opts = {
		highlight = 'DiffDelete',

		ignore_terminal = true,
		ignored_filetypes = {
			'TelescopePrompt',
			'help',
			'mason',
			'neo-tree',
			'noice',
			'toggleterm',
		},
	},
}
