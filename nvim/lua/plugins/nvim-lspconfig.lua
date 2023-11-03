return {
	'neovim/nvim-lspconfig',

	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		'j-hui/fidget.nvim',

		{ 'folke/neodev.nvim', config = true },
		'numToStr/Comment.nvim',
	},

	config = function()
		local function on_attach_default(_, bufnr)
			local ts_builtin = require 'telescope.builtin'

			local function map_key(key, func, desc)
				return vim.keymap.set('n', key, func, {
					buffer = bufnr,
					desc = 'LSP: ' .. desc,
				})
			end

			map_key('<leader>R', vim.lsp.buf.rename, '[R]ename')
			map_key('<leader>A', vim.lsp.buf.code_action, 'Code [A]ction')
			map_key('<leader>F', vim.cmd.Format, '[F]ormat current buffer')

			map_key('<leader>fD', ts_builtin.lsp_definitions, '[F]ind [D]efinitions')
			map_key('<leader>fC', vim.lsp.buf.declaration, '[F]ind to De[c]larations')
			map_key('<leader>fR', ts_builtin.lsp_references, '[F]ind [R]eferences')
			map_key('<leader>fI', ts_builtin.lsp_implementations, '[F]ind [I]mplementation')
			map_key('<leader>fT', ts_builtin.lsp_type_definitions, '[F]ind [T]ype definitions')
			map_key('<leader>fSd', ts_builtin.lsp_document_symbols, '[F]ind [D]ocument [S]ymbols')
			map_key('<leader>fSw', ts_builtin.lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace [S]ymbols')

			map_key('K', vim.lsp.buf.hover, 'Hover Documentation')
		end

		local lspconfig = require 'lspconfig'
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {}

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()
		default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

		local default_handlers = {}

		mason_lspconfig.setup_handlers {
			function(server_name)
				local server_config_ok, server_config = pcall(require, 'lsp.servers.' .. server_name)

				if not server_config_ok then
					server_config = {}
				end

				local function on_server_attach(client, bufnr)
					on_attach_default(client, bufnr)
					pcall(server_config.on_attach, client, bufnr)
				end

				lspconfig[server_name].setup {
					capabilities = server_config.capabilities or default_capabilities,
					settings = server_config.settings,
					init_options = server_config.init_options,
					filetypes = server_config.filetypes,
					handlers = vim.tbl_extend('force', default_handlers, server_config.handlers or {}),
					on_attach = on_server_attach,
				}
			end,
		}
	end,
}
