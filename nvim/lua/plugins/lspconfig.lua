return {
	-- LSP
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		'j-hui/fidget.nvim',

		{ 'folke/neodev.nvim',       config = true },
		'numToStr/Comment.nvim',

		{
			'MunifTanjim/prettier.nvim',
			opts = {
				bin = 'prettierd',
			},
		},
	},

	config = function()
		local function on_attach_default(_, bufnr)
			local function map_key(key, func, desc)
				return vim.keymap.set('n', key, func, {
					buffer = bufnr,
					desc = desc and 'LSP: ' .. desc
				})
			end

			map_key('<leader>cr', vim.lsp.buf.rename, '[R]ename')
			map_key('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			local ts_builtin = require('telescope.builtin')

			map_key('gd', ts_builtin.lsp_definitions, '[G]oto [D]efinition')
			map_key('gr', ts_builtin.lsp_references, '[G]oto [R]eferences')
			map_key('gI', ts_builtin.lsp_implementations, '[G]oto [I]mplementation')
			map_key('<leader>ds', ts_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
			map_key('<leader>ws', ts_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			map_key('K', vim.lsp.buf.hover, 'Hover Documentation')
			map_key('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			map_key('<leader>cf', vim.cmd.Format, 'Format current buffer')
		end

		local lspconfig = require('lspconfig')
		local mason_lspconfig = require('mason-lspconfig')

		local servers = {
			'lua_ls',
			'tsserver',
			'html',
			'jsonls',
			'pyright',
			'jdtls',
		}

		mason_lspconfig.setup({
			ensure_installed = servers,
		})

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()
		default_capabilities = require('cmp_nvim_lsp').default_capabilities(default_capabilities)

		local default_handlers = {}

		mason_lspconfig.setup_handlers({
			function(server_name)
				local server_config_ok, server_config = pcall(require, 'lsp.servers.' .. server_name)

				if not server_config_ok then
					server_config = {}
				end

				local function on_server_attach(client, bufnr)
					on_attach_default(client, bufnr)
					pcall(server_config.on_attach, client, bufnr)
				end

				lspconfig[server_name].setup({
					capabilities = server_config.capabilities or default_capabilities,
					settings = server_config.settings,
					init_options = server_config.init_options,
					filetypes = server_config.filetypes,
					handlers = vim.tbl_extend('force', default_handlers, server_config.handlers or {}),
					on_attach = on_server_attach,
				})
			end
		})
	end,
}
