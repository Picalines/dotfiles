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

	opts = {
		presets = {
			long_message_to_split = false,
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

			progress = {
				enabled = false,
			},
		},

		notify = {
			enabled = true,
			view = 'notifications',
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
			notifications = {
				backend = 'mini',
				relative = 'editor',
				align = 'right',
				zindex = 50,

				position = { row = -2, col = -1 },
				border = {
					style = 'rounded',
					padding = { 0, 1 },
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

			cmdline_popup = {
				relative = 'editor',
				position = {
					row = 5,
					col = '50%',
				},
				size = {
					width = 80,
					height = 'auto',
				},
			},

			popupmenu = {
				relative = 'editor',
				position = {
					row = 8,
					col = '50%',
				},
				size = {
					width = 80,
					height = 10,
				},
				border = {
					style = 'rounded',
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
				},
			},

			hover = {
				relative = 'cursor',
				position = { row = 2 },
				border = {
					style = 'rounded',
					padding = { 0, 1 },
				},
			},

			signature = {
				relative = 'cursor',
				position = { row = 2 },
				border = {
					style = 'rounded',
					padding = { 0, 1 },
				},
			},
		},
	},
}
