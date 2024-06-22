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
			border = 'none',
			relative = 'cursor',
		},

		on_attach = function(bufnr)
			local util = require 'util'
			local gitsigns = package.loaded.gitsigns

			util.declare_keymaps {
				[{ 'n', buffer = bufnr }] = {
					['<leader>hp'] = { gitsigns.preview_hunk, 'Preview hunk' },
					['<leader>ha'] = { gitsigns.stage_hunk, 'Stage hunk' },
					['<leader>hu'] = { gitsigns.undo_stage_hunk, 'Undo stage hunk' },
					['<leader>hr'] = { gitsigns.reset_hunk, 'Reset hunk' },

					[']h'] = {
						desc = 'Jump to next [h]unk',
						function()
							if vim.wo.diff then
								return ']h'
							end
							vim.schedule(gitsigns.next_hunk)
							return '<Ignore>'
						end,
					},

					['[h'] = {
						desc = 'Jump to previous [h]unk',
						function()
							if vim.wo.diff then
								return '[h'
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
