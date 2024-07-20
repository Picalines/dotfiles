local keymap = require 'util.keymap'

keymap.declare {
	[{ 'v', silent = true }] = {
		-- keep clipboard after paste in visual mode
		['p'] = '"_dP',
	},
}
