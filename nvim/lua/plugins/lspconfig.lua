return {
	-- LSP
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		'j-hui/fidget.nvim',

		-- Lua LSP
		'folke/neodev.nvim',

		-- comment
		'numToStr/Comment.nvim',
	},

	config = function()
		local on_attach = function(_, bufnr)
			local function map_key(key, func, desc)
				return vim.keymap.set('n', key, func, {
					buffer = bufnr,
					desc = desc and 'LSP: ' .. desc
				})
			end

			map_key('<leader>cr', vim.lsp.buf.rename, '[R]ename')
			map_key('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			local ts_builtin = require('telescope.builtin')

			map_key('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			map_key('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			map_key('gr', ts_builtin.lsp_references, '[G]oto [R]eferences')
			map_key('gI', ts_builtin.lsp_implementations, '[G]oto [I]mplementation')
			map_key('<leader>ds', ts_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
			map_key('<leader>ws', ts_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			map_key('K', vim.lsp.buf.hover, 'Hover Documentation')
			map_key('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			local custom_formatters = {
				python = function()
					vim.cmd(':normal ma')
					vim.cmd(':silent :%!black --preview - -q 2>/dev/null')
					vim.cmd(':normal `a')
				end,
			}

			local function format_buffer()
				local formatter = custom_formatters[vim.bo.filetype]
				formatter = formatter or vim.lsp.buf.format
				formatter()
			end

			map_key('<leader>cf', format_buffer, 'Format current buffer')
		end

		require('Comment').setup({
			padding = true,
			sticky = true,
			toggler = {
				line = '<leader>cl',
				block = '<leader>cb',
			},
			opleader = {
				line = '<leader>cl',
				block = '<leader>cb',
			},
			extra = {
				above = '<leader>cO',
				below = '<leader>co',
				eol = '<leader>cA',
			},
			mappings = {
				basic = true,
				extra = true,
			},
			ignore = nil,
			pre_hook = nil,
			post_hook = nil,
		})

		local servers = {
			pyright = {},
			tsserver = {},
			html = { filetypes = { 'html' } },

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		require('neodev').setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		local mason_lspconfig = require('mason-lspconfig')

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require('lspconfig')[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end
		})
	end,
}
