return {
	'numToStr/Comment.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring',
	},

	config = function()
		local comment = require 'Comment'
		local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

		comment.setup {
			padding = true,
			sticky = true,

			toggler = {
				line = '<leader>cl',
				block = '<leader>cb',
			},

			opleader = {
				line = '<leader>cl',
				block = '<leader>cb',
			},

			extra = {
				above = '<leader>cO',
				below = '<leader>co',
				eol = '<leader>cA',
			},

			mappings = {
				basic = true,
				extra = true,
			},

			-- for commenting tsx and jsx files
			pre_hook = ts_context_commentstring.create_pre_hook(),
		}
	end,
}
