return {
	'numToStr/Comment.nvim',

	opts = {
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
	},
}
