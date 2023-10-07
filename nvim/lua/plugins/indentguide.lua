return {
	-- Indentation guides
	'lukas-reineke/indent-blankline.nvim',
	main = 'ibl',
	opts = {},
	priority = 1001,
	config = function()
		local hooks = require('ibl.hooks')
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#454545' })
		end)

		require('ibl').setup({
			indent = {
				char = '┊',
				highlight = { 'Whitespace' },
			},
			scope = {
				enabled = false,
			},
			whitespace = {
				remove_blankline_trail = true,
			},
		})
	end,
}

