return {
	'terrortylor/nvim-comment',

	event = { 'BufReadPre', 'BufNewFile' },

	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring',
	},

	config = function()
		require('ts_context_commentstring').setup {
			enable_autocmd = false,
		}

		require('nvim_comment').setup {
			line_mapping = '<leader>//',
			operator_mapping = '<leader>/',
			comment_chunk_text_object = 'ic',

			hook = require('ts_context_commentstring.internal').update_commentstring,
		}
	end,
}
