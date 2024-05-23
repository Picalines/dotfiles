return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		'j-hui/fidget.nvim',

		{ 'folke/neodev.nvim', config = true },
		'numToStr/Comment.nvim',

		{
			'dgagn/diagflow.nvim',
			event = 'LspAttach',
			opts = {
				enable = true,
				severity_colors = {
					error = 'DiagnosticError',
					warning = 'DiagnosticWarn',
					info = 'DiagnosticInfo',
					hint = 'DiagnosticHint',
				},
				gap_size = 1,
				scope = 'cursor',
				toggle_event = { 'InsertEnter', 'InsertLeave' },
				padding_top = 0,
				padding_right = 0,
				text_align = 'left',
				placement = 'inline',
			},
		},
	},

	config = function()
		local util = require 'util'

		local function toggle_inlay_hints()
			---@diagnostic disable-next-line: missing-parameter
			local is_enabled = not vim.lsp.inlay_hint.is_enabled()
			vim.lsp.inlay_hint.enable(is_enabled)
			print('Inlay hints: ' .. (is_enabled and 'on' or 'off'))
		end

		local function declare_lsp_keymaps(_, bufnr)
			util.declare_keymaps {
				opts = {
					buffer = bufnr,
					silent = true,
				},
				n = {
					['<leader>R'] = { vim.lsp.buf.rename, 'LSP: [R]ename' },
					['<leader>A'] = { vim.lsp.buf.code_action, 'LSP: Code [A]ction' },
					['<leader>F'] = { ':Format<CR>', 'LSP: [F]ormat current buffer' },
					['<leader>H'] = { toggle_inlay_hints, 'LSP: Toggle inlay [H]ints' },

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

			local custom_on_attach = server_config.on_attach or util.noop

			local function on_attach(client, bufnr)
				declare_lsp_keymaps(client, bufnr)
				pcall(custom_on_attach, client, bufnr)
			end

			local default_server_config = {
				capabilities = default_capabilities,
				handlers = default_handlers,
			}

			lspconfig[server_name].setup(util.override_deep(default_server_config, server_config, { on_attach = on_attach }))
		end

		mason_lspconfig.setup_handlers { setup_server }
	end,
}
