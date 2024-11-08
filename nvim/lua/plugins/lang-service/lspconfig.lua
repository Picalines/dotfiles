return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		{ 'folke/neodev.nvim', config = true },

		{
			'davidosomething/format-ts-errors.nvim',
			opts = {
				add_markdown = true,
			},
		},
	},

	config = function()
		local func = require 'util.func'
		local tbl = require 'util.table'

		local lspconfig = require 'lspconfig'
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {}

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()
		default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

		local function setup_server(server_name)
			local server_config_ok, server_config = pcall(require, 'settings.lsp.servers.' .. server_name)

			if not server_config_ok then
				server_config = {}
			end

			local custom_on_attach = server_config.on_attach or func.noop

			local function on_attach(client, bufnr)
				pcall(custom_on_attach, client, bufnr)
			end

			local default_server_config = {
				capabilities = tbl.override_deep(default_capabilities, {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				}),
			}

			lspconfig[server_name].setup(tbl.override_deep(default_server_config, server_config, { on_attach = on_attach }))
		end

		mason_lspconfig.setup_handlers { setup_server }
	end,
}
