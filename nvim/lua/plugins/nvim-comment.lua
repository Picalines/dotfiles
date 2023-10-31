return {
	'terrortylor/nvim-comment',

	event = { 'BufReadPre', 'BufNewFile' },

	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring',
	},

	config = function()
<<<<<<< HEAD
		require('nvim_comment').setup {
			hook = require('ts_context_commentstring.internal').update_commentstring,
=======
		local function true_set(keys)
			local set = {}
			for _, key in ipairs(keys) do
				set[key] = true
			end
			return set
		end

		local ts_context_commentstring = require 'ts_context_commentstring.internal'

		local ts_context_filetypes = true_set {
			'javascriptreact',
			'typescriptreact',
			'svelte',
			'vue',
		}

		require('nvim_comment').setup {
			hook = function()
				local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
				if ts_context_filetypes[filetype] then
					ts_context_commentstring.update_commentstring()
				end
			end,
>>>>>>> c8b892a8b0db06b0099c03f54fae3f0bfedde2b4
		}
	end,
}
