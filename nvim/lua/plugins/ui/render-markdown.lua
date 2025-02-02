return {
	'MeanderingProgrammer/render-markdown.nvim',

	ft = 'markdown',

	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
	},

	opts = {
		sign = {
			enabled = false,
		},

		indent = {
			enabled = false,
		},

		bullet = {
			icons = { '', '' },
		},
	},
}
