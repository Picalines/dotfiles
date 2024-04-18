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

		local opts = {
			options = {
				icons_enabled = true,
				theme = 'auto',
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

		local modes = {
			'normal',
			'insert',
			'visual',
			'replace',
			'command',
			'inactive',
		}

		local remove_bg_cmd = table.concat(
			util.map(modes, function(mode)
				return 'highlight! lualine_c_' .. mode .. ' guibg=NONE'
			end),
			'\n'
		)

		vim.cmd(remove_bg_cmd)

		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			pattern = '*',
			command = remove_bg_cmd,
		})

		local lualine = require 'lualine'

		local orig_refresh = lualine.refresh
		lualine.refresh = function(refresh_opts)
			orig_refresh(refresh_opts)
			vim.cmd(remove_bg_cmd)
		end

		lualine.setup(opts)
	end,
}
