return {
	'nvim-lualine/lualine.nvim',

	config = function()
		local util = require 'util'

		local noice_status = require('noice').api.status

		local function no_bg(mode)
			if type(mode) ~= 'table' then
				mode = { mode }
			end

			return util.override_deep(mode, { color = { bg = 'NONE' } })
		end

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
				lualine_a = {},

				lualine_b = {},

				lualine_c = {
					no_bg 'branch',

					no_bg 'diff',

					no_bg 'diagnostics',

					no_bg {
						noice_status.mode.get,
						cond = noice_status.mode.has,
						color = { fg = '#ff9e64' },
					},
				},

				lualine_x = { no_bg 'location', no_bg 'encoding' },

				lualine_y = {},

				lualine_z = {},
			},
		}

		vim.cmd [[
			highlight lualine_c_inactive guibg=NONE
			highlight lualine_c_normal guibg=NONE
		]]
	end,
}
