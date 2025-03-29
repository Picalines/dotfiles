local arc_plugin_path = vim.fn.expand '~/Arcadia/junk/a-matveev9/gitsigns.arc.nvim'
local arc_plugin_exists = vim.fn.isdirectory(arc_plugin_path) == 1

return {
	not arc_plugin_exists and 'lewis6991/gitsigns.nvim' or nil,
	dir = arc_plugin_exists and arc_plugin_path or nil,

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
			row = 1,
			col = 1,
			style = 'minimal',
		},

		on_attach = function(bufnr)
			local keymap = require 'util.keymap'
			local gitsigns = require 'gitsigns'

			local function blame_line()
				gitsigns.blame_line { full = true }
			end

			keymap.declare {
				[{ 'n', buffer = bufnr, desc = 'Git: %s' }] = {
					['<leader>gd'] = { gitsigns.preview_hunk, 'preview diff' },
					['<leader>gs'] = { gitsigns.stage_hunk, 'stage hunk' },
					['<leader>gu'] = { gitsigns.undo_stage_hunk, 'unstage hunk' },
					['<leader>gr'] = { gitsigns.reset_hunk, 'reset hunk' },

					['<leader>gb'] = { blame_line, 'blame line' },

					[']h'] = {
						desc = 'next',
						function()
							if vim.wo.diff then
								return ']h'
							end
							vim.schedule(gitsigns.next_hunk)
							return '<Ignore>'
						end,
					},

					['[h'] = {
						desc = 'previous',
						function()
							if vim.wo.diff then
								return '[h'
							end
							vim.schedule(gitsigns.prev_hunk)
							return '<Ignore>'
						end,
					},
				},

				[{ 'o', 'x', buffer = bufnr, silent = true }] = {
					['ih'] = { ':<C-U>Gitsigns select_hunk<CR>', 'Hunk: select' },
				},
			}
		end,
	},
}
