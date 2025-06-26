return {
	'folke/noice.nvim',

	lazy = false,

	dependencies = {
		'MunifTanjim/nui.nvim',
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'

		require('noice').setup(opts)

		keymap {
			[{ 'n', desc = 'UI: %s' }] = {
				['<leader>um'] = { '<Cmd>Noice all<CR>', 'Open messages' },
			},
		}

		local augroup = autocmd.group 'noice'

		augroup:on_user('Dismiss', 'NoiceDismiss')
	end,

	---@module 'noice'
	---@type NoiceConfig
	opts = {
		presets = {
			long_message_to_split = false,
			bottom_search = false,
			command_palette = true,
			inc_rename = false,
		},

		routes = {
			{
				filter = {
					any = {
						{ event = 'notify', find = 'No information available' },
						{ event = 'notify', find = '%[lspconfig%] Unable to find ESLint library.' },
					},
				},
				opts = { skip = true },
			},
		},

		lsp = {
			override = {
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true,
			},

			hover = {
				silent = true,
			},

			progress = { enabled = false }, -- fidget.nvim
			signature = { enabled = false }, -- blink.nvim
		},

		notify = {
			enabled = true,
			view = 'notifications',
		},

		popupmenu = {
			enabled = false,
		},

		messages = {
			enabled = true,
			view = 'notifications',
			view_error = 'notifications',
			view_warn = 'notifications',
			view_search = false,
			view_history = 'messages',
		},

		commands = {
			all = {
				view = 'messages',
				opts = {
					enter = true,
					format = { '{date} ', '{kind} ', '{message}' },
				},
				filter = {
					event = 'msg_show',
				},
			},
		},

		views = {
			hover = {
				relative = 'cursor',
				position = { row = 2 },
				border = {
					style = 'rounded',
					padding = { 0, 1 },
				},
			},

			notifications = {
				backend = 'mini',
				relative = 'editor',
				align = 'right',
				zindex = 50,

				position = { row = -2, col = -1 },
				border = {
					style = 'rounded',
					padding = { 0, 0 },
				},
				focusable = false,
				enter = false,

				size = {
					width = 'auto',
					height = 'auto',
				},

				timeout = 5000,

				format = { '{message}' },
			},

			messages = {
				backend = 'split',
				relative = 'editor',
				position = 'right',
				size = '33%',

				enter = true,
				win_options = {
					winhighlight = { Normal = 'NoiceSplit' },
					wrap = true,
					signcolumn = 'no',
					number = false,
					relativenumber = false,
				},

				buf_options = {
					filetype = 'messages',
				},

				close = {
					keys = { 'q' },
				},
			},
		},
	},
}
