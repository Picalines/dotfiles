return {
	'folke/lazydev.nvim',

	ft = 'lua',

	dependencies = {
		'mason-org/mason.nvim',
	},

	opts = {
		library = {
			'LazyVim',
			{ path = '${3rd}/luv/library' },
		},
	},
}
