return {
	'nmac427/guess-indent.nvim',

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'guess-indent'

		keys { 'n' } {
			map('<LocalLeader>i', 'detect indent') '<Cmd>GuessIndent<CR>',
		}
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
