return {
	'nvim-lualine/lualine.nvim',

	config = function()
		local noice_statusline = require('noice').api.statusline

		require('lualine').setup {
			options = {
				icons_enabled = true,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',

				ignore_focus = { 'neo-tree' },

				globalstatus = true,
			},

			sections = {
				lualine_a = { 'mode' },

				lualine_b = {
					{
						'filetype',
						icon_only = true,
						separator = '',
						padding = { left = 1, right = 0 },
					},
					{
						'filename',
					},
				},

				lualine_c = {
					'branch',
					'diff',
					'diagnostics',

					{
						noice_statusline.mode.get,
						cond = noice_statusline.mode.has,
						color = { fg = '#ff9e64' },
					},
				},

				lualine_x = { 'location', 'encoding' },

				lualine_z = {},
			},
		}
	end,
}
