return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		'saghen/blink.cmp',
	},

	config = function()
		local func = require 'util.func'

		local lspconfig = require 'lspconfig'

		require('mason-lspconfig').setup {
			nsure_installed = {},
			automatic_installation = false,

			handlers = {
				function(server_name)
					local ok, server_config = pcall(require, 'settings.lsp.servers.' .. server_name)
					server_config = ok and server_config or {}

					server_config.on_attach = func.pcalled(server_config.on_attach or func.noop)
					server_config.capabilities = require('blink.cmp').get_lsp_capabilities()

					lspconfig[server_name].setup(server_config)
				end,
			},
		}
	end,
}
