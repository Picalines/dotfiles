return {
	{
		'neovim/nvim-lspconfig',

		event = 'VeryLazy',
	},

	{
		'williamboman/mason-lspconfig.nvim',

		event = 'VeryLazy',

		dependencies = {
			'neovim/nvim-lspconfig',
			'mason-org/mason.nvim',
		},

		opts = {
			ensure_installed = {},
			automatic_installation = false,
			automatic_enable = true,
		},
	},
}
