require('keymaps.util').declare_keymaps {
	opts = { silent = true },
	v = {
		-- keep clipboard after paste in visual mode
		['p'] = '"_dP',
	},
}
