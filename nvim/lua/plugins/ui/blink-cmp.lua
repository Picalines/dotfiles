local keymap = require 'util.keymap'

keymap {
	[{ 'c' }] = {
		['<Tab>'] = { '<C-n>', remap = true },
	},
}

return {
	'saghen/blink.cmp',

	event = { 'InsertEnter', 'CmdlineEnter' },

	build = 'cargo build --release',

	dependencies = {
		'xzbdmw/colorful-menu.nvim',
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
			},

			['<C-S-n>'] = { 'select_prev' },
			['<C-y>'] = { 'accept' },
			['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
			['<C-d>'] = { 'scroll_documentation_down', 'hide', 'fallback' },
		},

		sources = {
			default = { 'lsp', 'path', 'buffer' },
		},

		fuzzy = {
			implementation = 'prefer_rust_with_warning',
		},

		completion = {
			menu = {
				auto_show = false,
				draw = {
					columns = { { 'kind_icon' }, { 'label', gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require('colorful-menu').blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require('colorful-menu').blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
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
			enabled = true,
			trigger = {
				enabled = true,
				show_on_accept = true,
				show_on_insert = true,
				show_on_accept_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
			},
			window = {
				show_documentation = true,
				direction_priority = { 's', 'n' },
				border = 'rounded',
			},
		},

		snippets = {
			preset = 'luasnip',
		},

		appearance = {
			nerd_font_variant = 'mono',
		},

		cmdline = {
			enabled = true,
			keymap = { preset = 'inherit' },
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
