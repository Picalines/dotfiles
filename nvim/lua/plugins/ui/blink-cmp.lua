return {
	'saghen/blink.cmp',

	version = '1.*',

	dependencies = {
		'rafamadriz/friendly-snippets',
		'L3MON4D3/LuaSnip',
	},

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = 'none',

			['<C-n>'] = {
				function(cmp)
					if not cmp.is_menu_visible() then
						cmp.show()
						return true
					end
				end,
				'select_next',
				'fallback',
			},

			['<C-S-n>'] = { 'select_prev', 'fallback' },

			['<C-y>'] = { 'accept' },
		},

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		fuzzy = {
			implementation = 'prefer_rust_with_warning',
		},

		completion = {
			menu = {
				auto_show = false,
				draw = {
					columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
				},
			},
			ghost_text = {
				enabled = true,
				show_with_menu = false,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
		},

		signature = {
			enabled = false,
		},

		snippets = {
			preset = 'luasnip',
		},

		appearance = {
			nerd_font_variant = 'mono',
		},
	},

	opts_extend = { 'sources.default' },

	config = function(_, opts)
		local cmp = require 'blink-cmp'

		cmp.setup(opts)

		local autocmd = require 'util.autocmd'
		local augroup = autocmd.group 'cmp'

		augroup:on_user('Dismiss', function()
			cmp.hide()
		end)
	end,
}
