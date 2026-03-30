return {
	'f-person/auto-dark-mode.nvim',

	-- makes background detection more consistent

	lazy = false,

	opts = {
		fallback = 'dark',

		set_light_mode = function()
			vim.cmd 'silent! Colorset daytime set light'
		end,

		set_dark_mode = function()
			vim.cmd 'silent! Colorset daytime set dark'
		end,
	},
}
