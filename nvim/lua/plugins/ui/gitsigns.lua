return {
	'lewis6991/gitsigns.nvim',

	init = function()
		local keys = require 'mappet'

		keys.group 'plugins.ui.gitsigns' 'Git: %s' {
			keys.map('<LocalLeader>hb', 'blame line') '<Cmd>Gitsigns blame_line full=true<CR>',
			keys.map('<LocalLeader>hB', 'blame buffer') '<Cmd>Gitsigns blame<CR>',
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
