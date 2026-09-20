return {
	'nmac427/guess-indent.nvim',

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'guess-indent'

		keys { 'n' } {
			map('<LocalLeader>i', 'detect indent') '<Cmd>GuessIndent<CR>',
		}

		local augroup = autocmd.group 'guess-indent'

		augroup:on_user('SnacksPickerPreview', function(event)
			vim.cmd.GuessIndent { tostring(event.data.buf), 'auto_cmd', 'silent' }
		end)
	end,

	opts = {
		auto_cmd = true,
		on_tab_options = {
			expandtab = false,
			tabstop = 4,
			softtabstop = 4,
			shiftwidth = 4,
		},
	},
}
