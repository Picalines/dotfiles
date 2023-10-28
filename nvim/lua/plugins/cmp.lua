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

	config = function()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		local lspkind = require 'lspkind'

		require('luasnip.loaders.from_vscode').lazy_load()

		luasnip.config.setup {}

		cmp.setup {
			mapping = cmp.mapping.preset.insert {
				['<S-Space>'] = cmp.mapping.complete(),

				['<Tab>'] = cmp.mapping.select_next_item(),
				['<S-Tab>'] = cmp.mapping.select_prev_item(),

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
