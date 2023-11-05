return {
	'lewis6991/gitsigns.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		signs = {
			add = { text = '│' },
			change = { text = '│' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '│' },
			untracked = { text = '┆' },
		},

		signcolumn = true,

		attach_to_untracked = true,
		watch_gitdir = {
			follow_files = true,
		},

		current_line_blame = true,
		current_line_blame_formatter = '<author> - <summary>, <author_time:%R>',
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol',
			delay = 500,
			ignore_whitespace = true,
		},

		preview_config = {
			border = 'rounded',
			relative = 'cursor',
		},

		on_attach = function(bufnr)
			local gitsigns = package.loaded.gitsigns

			require('keymaps.util').declare_keymaps {
				opts = {
					buffer = bufnr,
				},

				n = {
					['<leader>C'] = { gitsigns.preview_hunk, 'Preview git change' },
				},

				[{ 'n', 'v' }] = {
					[']C'] = {
						desc = 'Jump to next [C]hange',
						function()
							if vim.wo.diff then
								return ']C'
							end
							vim.schedule(gitsigns.next_hunk)
							return '<Ignore>'
						end,
					},

					['[C'] = {
						desc = 'Jump to previous [C]hange',
						function()
							if vim.wo.diff then
								return '[C'
							end
							vim.schedule(gitsigns.prev_hunk)
							return '<Ignore>'
						end,
					},
				},
			}
		end,
	},
}
