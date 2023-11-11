return {
	'folke/noice.nvim',

	dependencies = {
		'MunifTanjim/nui.nvim',

		{
			'rcarriga/nvim-notify',
			opts = {
				render = 'wrapped-compact',
				stages = 'slide',
				timeout = 5000,
				top_down = true,
			},
		},
	},

	opts = {
		presets = {
			long_message_to_split = true,
		},

		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true,
			},
		},

		views = {
			cmdline_popup = {
				relatice = 'editor',
				position = {
					row = 5,
					col = '50%',
				},
				size = {
					width = 60,
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
					width = 60,
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
		},
	},
}
