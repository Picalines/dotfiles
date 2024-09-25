return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		{ 'folke/neodev.nvim', config = true },
	},

	config = function()
		local array = require 'util.array'
		local func = require 'util.func'
		local keymap = require 'util.keymap'
		local signal = require 'util.signal'
		local tbl = require 'util.table'

		local lsp_inlay_enabled = signal.new(false)
		signal.persist(lsp_inlay_enabled, 'lsp_inlay_hints')
		signal.watch(function()
			vim.lsp.inlay_hint.enable(lsp_inlay_enabled())
		end)

		local function toggle_inlay_hints()
			local is_enabled = lsp_inlay_enabled(not lsp_inlay_enabled())
			print('Inlay hints: ' .. (is_enabled and 'on' or 'off'))
		end

		keymap.declare {
			[{ 'n', silent = true }] = {
				['K'] = { vim.lsp.buf.hover, 'LSP: Hover' },

				['<leader>r'] = { vim.lsp.buf.rename, 'LSP: Rename' },
				['<leader>a'] = { vim.lsp.buf.code_action, 'LSP: Code action' },

				['gD'] = { '<Cmd>Glance definitions<CR>', 'LSP: Go to definition' },
				['gR'] = { '<Cmd>Glance references<CR>', 'LSP: Go to references' },
				['gI'] = { '<Cmd>Glance implementations<CR>', 'LSP: Go to implementation' },
				['gT'] = { '<Cmd>Glance type_definitions<CR>', 'LSP: Go to type definition' },
				['gC'] = { vim.lsp.buf.declaration, 'LSP: Go to to Declaration' },

				['<leader>li'] = { '<Cmd>LspInfo<CR>', 'LSP: See info' },
				['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'LSP: Restart' },
				['<leader>ll'] = { '<Cmd>LspLog<CR>', 'LSP: See logs' },
				['<leader>lh'] = { toggle_inlay_hints, 'LSP: Toggle inlay hints' },
				['<leader>ls'] = { vim.lsp.buf.signature_help, 'LSP: show signature help' },
			},

			[{ 'i' }] = {
				['<C-S>'] = { vim.lsp.buf.signature_help, 'LSP: show signature help' },
			},
		}

		local lspconfig = require 'lspconfig'
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {}

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()
		default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

		local ignored_servers = {}

		local default_handlers = {}

		local function setup_server(server_name)
			if array.contains(ignored_servers, server_name) then
				return
			end

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

				handlers = default_handlers,
			}

			lspconfig[server_name].setup(tbl.override_deep(default_server_config, server_config, { on_attach = on_attach }))
		end

		mason_lspconfig.setup_handlers { setup_server }
	end,
}
