return {
	'lewis6991/gitsigns.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	cmd = { 'Gitsigns' },

	init = function()
		local keys = require 'mappet'

		keys.group 'plugins.ui.gitsigns' 'Git: %s' {
			keys.map('<LocalLeader>gb', 'blame line') '<Cmd>Gitsigns blame_line full=true<CR>',
			keys.map('<LocalLeader>gB', 'blame buffer') '<Cmd>Gitsigns blame<CR>',
			keys.map('<LocalLeader>gs', 'stage hunk') '<Cmd>Gitsigns stage_hunk<CR>',
			keys.map('<LocalLeader>gr', 'reset hunk') '<Cmd>Gitsigns reset_hunk<CR>',
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
