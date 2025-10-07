return {
	'saghen/blink.cmp',

	version = '*',

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
					if vim.api.nvim_get_mode().mode == 's' then
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>"_c', true, false, true), 's', true)
					end
					if not cmp.is_menu_visible() then
						return cmp.show()
					end
				end,
				'select_next',
			},

			['<C-k>'] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.accept()
					end
				end,
				'fallback_to_mappings',
			},

			['<C-S-n>'] = { 'select_prev' },
			['<C-y>'] = { 'accept' },
			['<C-u>'] = { 'scroll_documentation_up', 'scroll_signature_up', 'fallback_to_mappings' },
			['<C-d>'] = { 'scroll_documentation_down', 'scroll_documentation_down', 'hide', 'fallback_to_mappings' },
		},

		sources = {
			default = { 'lsp', 'buffer', 'snippets' },
			per_filetype = {
				markdown = { inherit_defaults = true, 'path' },
			},
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
			keymap = {
				preset = 'inherit',

				['<Tab>'] = { 'show_and_insert', 'select_next' },
			},
		},
	},

	opts_extend = { 'sources.default' },

	init = function()
		local autocmd = require 'util.autocmd'
		local augroup = autocmd.group 'blink-cmp'

		augroup:on_user('Dismiss', function()
			require('blink-cmp').hide()
		end)
	end,
}
