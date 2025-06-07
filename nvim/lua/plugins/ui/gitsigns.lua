local keymap = require 'util.keymap'

local arc_plugin_path = vim.fn.expand '~/Arcadia/junk/a-matveev9/gitsigns.arc.nvim'
local arc_plugin_exists = vim.fn.isdirectory(arc_plugin_path) == 1
local is_in_arcadia = vim.startswith(vim.fn.getcwd() or '', vim.fn.expand '~/Arcadia')
local should_use_arc = arc_plugin_exists and is_in_arcadia

keymap {
	[{ desc = 'Git: %s' }] = {
		[{ 'n' }] = {
			['<leader>gs'] = { '<Cmd>Gitsigns stage_hunk<CR>', 'toggle staged hunk' },
			['<leader>gr'] = { '<Cmd>Gitsigns reset_hunk<CR>', 'reset hunk' },
			['<leader>gb'] = { '<Cmd>Gitsigns blame_line full=true<CR>', 'blame line' },
			['<leader>gB'] = { '<Cmd>Gitsigns blame<CR>', 'blame buffer' },
		},

		[{ 'x' }] = {
			['<leader>gs'] = { ':Gitsigns stage_hunk<CR>', 'stage selected' },
		},
	},
}

return {
	not should_use_arc and 'lewis6991/gitsigns.nvim' or nil,
	dir = should_use_arc and arc_plugin_path or nil,

	event = { 'BufReadPre', 'BufNewFile' },

	cmd = { 'Gitsigns' },

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
