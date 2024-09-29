return {
	'JoosepAlviste/nvim-ts-context-commentstring',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		enable_autocmd = false,
	},

	config = function(_, opts)
		require('ts_context_commentstring').setup(opts)

		local calculate_commentstring = require('ts_context_commentstring.internal').calculate_commentstring
		local builtin_get_option = vim.filetype.get_option

		---@diagnostic disable-next-line: duplicate-set-field
		vim.filetype.get_option = function(filetype, option)
			return option == 'commentstring' and calculate_commentstring() or builtin_get_option(filetype, option)
		end
	end,
}
