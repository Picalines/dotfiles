return {
	'terrortylor/nvim-comment',

	event = { 'BufReadPre', 'BufNewFile' },

	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring',
	},

	config = function()
		require('nvim_comment').setup {
			hook = require('ts_context_commentstring.internal').update_commentstring,
		}
	end,
}
