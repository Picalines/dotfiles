return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
	},

	config = function()
		require('mason-lspconfig').setup {
			ensure_installed = {},
			automatic_installation = false,

			handlers = {
				function(server_name)
					vim.lsp.enable(server_name)
				end,
			},
		}
	end,
}
