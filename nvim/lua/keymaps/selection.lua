local util = require 'keymaps.util'

util.declare_keymaps {
	v = {
		['J'] = ":m '>+1<CR>gv=gv",
		['K'] = ":m '<-2<CR>gv=gv",

		-- keep clipboard after paste in visual mode
		['p'] = '"_dP',
	},
}
