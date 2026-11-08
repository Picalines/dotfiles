return {
	'folke/which-key.nvim',

	event = 'VeryLazy',
	cmd = 'WhichKey',

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'plugins.ui.which-key'

		keys { 'n' } {
			map('<Leader>?', 'keymap help') '<Cmd>WhichKey<CR>',
		}
	end,

	opts = {
		preset = 'helix',
		delay = 500,
	},
}
