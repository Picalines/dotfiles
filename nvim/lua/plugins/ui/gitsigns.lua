return {
	'lewis6991/gitsigns.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	cmd = { 'Gitsigns' },

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ desc = 'Git: %s' }] = {
				[{ 'n' }] = {
					['<leader>gs'] = { '<Cmd>Gitsigns stage_hunk<CR>', 'toggle stage hunk' },
					['<leader>gS'] = { '<Cmd>Gitsigns stage_buffer<CR>', 'stage file' },
					['<leader>gr'] = { '<Cmd>Gitsigns reset_hunk<CR>', 'reset hunk' },
					['<leader>gb'] = { '<Cmd>Gitsigns blame_line full=true<CR>', 'blame line' },
					['<leader>gB'] = { '<Cmd>Gitsigns blame<CR>', 'blame buffer' },
				},

				[{ 'x' }] = {
					['<leader>gs'] = { ':Gitsigns stage_hunk<CR>', 'stage selected' },
				},
			},
		}
	end,

	---@module 'gitsigns'
	---@type Gitsigns.Config
	---@diagnostic disable-next-line: missing-fields
	opts = {
		signcolumn = false,

		attach_to_untracked = false,
		watch_gitdir = {
			follow_files = true,
		},

		current_line_blame = true,
		current_line_blame_formatter = '<author> - <summary>, <author_time:%R>',
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol',
			virt_text_priority = 5000,
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
	},
}
