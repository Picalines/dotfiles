require('util').declare_keymaps {
	[{ 'v', silent = true }] = {
		-- keep clipboard after paste in visual mode
		['p'] = '"_dP',
	},
}
