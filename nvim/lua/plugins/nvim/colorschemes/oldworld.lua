return {
	'dgox16/oldworld.nvim',

	lazy = false,

	priority = 1000,

	config = function(_, opts)
		require('oldworld').setup(opts)

		vim.api.nvim_create_autocmd('ColorScheme', {
			pattern = 'oldworld',
			callback = function()
				vim.api.nvim_set_hl(0, 'NormalNC', { link = 'Normal' })

				vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
			end,
		})
	end,
}
