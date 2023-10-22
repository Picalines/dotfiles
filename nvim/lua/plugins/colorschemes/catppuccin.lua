return {
	'catppuccin/nvim',
	lazy = false,
	priority = 1000,
	config = function()
		require('catppuccin').setup {
			flavour = 'macchiato',
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			no_italic = false,
			no_underline = false,
			styles = {
				comments = { 'italic' },
				conditionals = { 'italic' },
				keywords = { 'italic' },
			},
			color_overrides = {},
			custom_highlights = {},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
			},
		}
	end,
}
