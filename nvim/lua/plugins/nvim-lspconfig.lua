return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		'j-hui/fidget.nvim',

		{ 'folke/neodev.nvim', config = true },
		'numToStr/Comment.nvim',
	},

	config = function()
		local util = require 'util'

		local function declare_lsp_keymaps(_, bufnr)
			util.declare_keymaps {
				opts = {
					buffer = bufnr,
					silent = true,
				},
				n = {
					['<leader>R'] = { vim.lsp.buf.rename, 'LSP: [R]ename' },
					['<leader>A'] = { vim.lsp.buf.code_action, 'LSP: Code [A]ction' },
					['<leader>F'] = { vim.cmd.Format, 'LSP: [F]ormat current buffer' },

					['gD'] = { ':Glance definitions<CR>', 'LSP: [G]o to [D]efinition' },
					['gR'] = { ':Glance references<CR>', 'LSP: [G]o to [R]eferences' },
					['gI'] = { ':Glance implementations<CR>', 'LSP: [G]o to [I]mplementation' },
					['gT'] = { ':Glance type_definitions<CR>', 'LSP: [G]o to [T]ype definition' },
					-- ['gC'] = { vim.lsp.buf.declaration, 'LSP: [G]o to to De[c]laration' },
					-- ['<leader>fSd'] = { ts_builtin.lsp_document_symbols, '[F]ind [D]ocument [S]ymbols' },
					-- ['<leader>fSw'] = { ts_builtin.lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace [S]ymbols' },

					['K'] = { vim.lsp.buf.hover, 'LSP: Hover' },
				},
			}
		end

		local lspconfig = require 'lspconfig'
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {}

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()
		default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

		local ignored_servers = {}

		local default_handlers = {}

		local function setup_server(server_name)
			if util.contains_value(ignored_servers, server_name) then
				return
			end

			local server_config_ok, server_config = pcall(require, 'lsp.servers.' .. server_name)

			if not server_config_ok then
				server_config = {}
			end

			local function on_server_attach(client, bufnr)
				declare_lsp_keymaps(client, bufnr)
				pcall(server_config.on_attach, client, bufnr)
			end

			server_config = util.override_deep(server_config, {
				capabilities = server_config.capabilities or default_capabilities,
				settings = server_config.settings,
				init_options = server_config.init_options,
				filetypes = server_config.filetypes,
				handlers = vim.tbl_extend('force', default_handlers, server_config.handlers or {}),
				on_attach = on_server_attach,
			})

			lspconfig[server_name].setup(server_config)
		end

		mason_lspconfig.setup_handlers { setup_server }
	end,
}
