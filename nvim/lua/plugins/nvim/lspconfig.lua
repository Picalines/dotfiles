return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		{
			'j-hui/fidget.nvim',

			opts = {
				progress = {
					display = {
						done_icon = '',
					},
				},
				notification = {
					window = {
						x_padding = 2,
						y_padding = 1,
						relative = 'editor',
						normal_hl = 'Visual',
					},
				},
			},
		},

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
		local keymap = require 'util.keymap'
		local array = require 'util.array'
		local tbl = require 'util.table'
		local func = require 'util.func'
		local persist = require 'util.persist'

		vim.lsp.inlay_hint.enable(persist.get_item('lsp_inlay_hints', false))

		local function toggle_inlay_hints()
			---@diagnostic disable-next-line: missing-parameter
			local is_enabled = not vim.lsp.inlay_hint.is_enabled()
			vim.lsp.inlay_hint.enable(is_enabled)
			persist.save_item('lsp_inlay_hints', is_enabled)
			print('Inlay hints: ' .. (is_enabled and 'on' or 'off'))
		end

		keymap.declare {
			[{ 'n', silent = true }] = {
				['K'] = { vim.lsp.buf.hover, 'LSP: Hover' },

				['<leader>R'] = { vim.lsp.buf.rename, 'LSP: Rename' },
				['<leader>A'] = { vim.lsp.buf.code_action, 'LSP: Code action' },

				['gD'] = { ':Glance definitions<CR>', 'LSP: Go to definition' },
				['gR'] = { ':Glance references<CR>', 'LSP: Go to references' },
				['gI'] = { ':Glance implementations<CR>', 'LSP: Go to implementation' },
				['gT'] = { ':Glance type_definitions<CR>', 'LSP: Go to type definition' },
				['gC'] = { vim.lsp.buf.declaration, 'LSP: Go to to Declaration' },

				['<leader>Li'] = { ':LspInfo<CR>', 'LSP: See info' },
				['<leader>Lr'] = { ':echo "Restarting LSP" | LspRestart<CR>', 'LSP: Restart' },
				['<leader>Ll'] = { ':LspLog<CR>', 'LSP: See logs' },
				['<leader>Lh'] = { toggle_inlay_hints, 'LSP: Toggle inlay hints' },
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

			local server_config_ok, server_config = pcall(require, 'lsp.servers.' .. server_name)

			if not server_config_ok then
				server_config = {}
			end

			local custom_on_attach = server_config.on_attach or func.noop

			local function on_attach(client, bufnr)
				-- declare_lsp_keymaps(client, bufnr)
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
