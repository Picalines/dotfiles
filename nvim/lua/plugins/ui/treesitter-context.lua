return {
	'nvim-treesitter/nvim-treesitter-context',

	event = 'VeryLazy',

	opts = {
		multiwindow = true,
		mode = 'topline',
	},

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'plugins.ui.treesitter-context'

		keys('UI: %s', { 'n' }) {
			map('<Leader>oc', 'toggle TS context') '<Cmd>TSContext toggle<CR>',
		}
	end,
}
