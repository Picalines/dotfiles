return {
	'morhetz/gruvbox',

	lazy = false,

	priority = 1000,

	config = function()
		vim.cmd [[
			let g:gruvbox_contrast_dark = 'hard'
			let g:gruvbox_sign_column = 'bg0'
		]]
	end,
}
