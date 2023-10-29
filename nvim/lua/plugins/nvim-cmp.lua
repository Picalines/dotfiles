return {
	-- Autocompletion
	'hrsh7th/nvim-cmp',

	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',

		-- Adds LSP completion capabilities
		'hrsh7th/cmp-nvim-lsp',

		-- Adds a number of user-friendly snippets
		'rafamadriz/friendly-snippets',

		-- Icons
		'onsails/lspkind.nvim',

		-- Additional completion sources
		'hrsh7th/cmp-calc',
		'hrsh7th/cmp-nvim-lsp-signature-help',
	},

	event = { 'InsertEnter', 'CmdlineEnter' },

	config = function()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		local lspkind = require 'lspkind'

		require('luasnip.loaders.from_vscode').lazy_load()

		luasnip.config.setup {}

		local function has_words_before()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
		end

		local function select_next(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end

		local function select_prev(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		cmp.setup {
			mapping = cmp.mapping.preset.insert {
				['<S-Space>'] = cmp.mapping.complete(),
				['<C-Space>'] = cmp.mapping.complete(),

				['<Tab>'] = cmp.mapping(select_next, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(select_prev, { 'i', 's' }),

				['<C-k>'] = cmp.mapping.scroll_docs(-4),
				['<C-j>'] = cmp.mapping.scroll_docs(4),

				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
			},

			formatting = {
				format = lspkind.cmp_format {
					mode = 'symbol',
					maxwdith = 50,
					elipsis_char = '...',
				},
			},

			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'calc' },
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
		}
	end,
}
