return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			icons_enabled = true,
			theme = 'onedark',
			component_separators = '|',
			section_separators = '',

			ignore_focus = { 'NvimTree' },

			globalstatus = true,
		},

		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'filename' },
			lualine_c = { 'branch', 'diff', 'diagnostics' },
			lualine_x = { 'location', 'encoding' },
			lualine_y = { 'filetype' },
			lualine_z = {},
		},
	},
}
