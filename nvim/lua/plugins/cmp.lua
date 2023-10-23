local kind_icons = {
	Text = '',
	Method = '󰆧',
	Function = '󰊕',
	Constructor = '',
	Field = '',
	Variable = '',
	Class = '󰠱',
	Interface = '',
	Module = '',
	Property = '',
	Unit = '',
	Value = '󰎠',
	Enum = '',
	Keyword = '󰌋',
	Snippet = '',
	Color = '󰏘',
	File = '󰈙',
	Reference = '',
	Folder = '󰉋',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = '',
	Operator = '󰆕',
	TypeParameter = '',
}

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
	},

	config = function()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'

		require('luasnip.loaders.from_vscode').lazy_load()

		luasnip.config.setup {}

		cmp.setup {
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			mapping = cmp.mapping.preset.insert {
				['<C-a>'] = cmp.mapping.complete {},
				['<C-j>'] = cmp.mapping.select_next_item(),
				['<C-k>'] = cmp.mapping.select_prev_item(),
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),

				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
			},

			formatting = {
				format = function(_, item)
					item.kind = kind_icons[item.kind] .. ' ' .. item.kind:lower()
					return item
				end,
			},

			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
		}
	end,
}
