return {
	'nvim-lualine/lualine.nvim',

	enabled = false, -- replaced by heirline.nvim

	config = function()
		local util = require 'util'
		local lualine = require 'lualine'

		local lualine_sections = { 'a', 'b', 'c', 'x', 'y', 'z' }
		local lualine_modes = {
			'normal',
			'insert',
			'visual',
			'replace',
			'command',
			'inactive',
		}

		local lualine_mode_theme = util.flat_map(lualine_sections, function(section)
			return { [section] = { bg = 'none' } }
		end)

		local lualine_theme = util.flat_map(lualine_modes, function(mode)
			return { [mode] = lualine_mode_theme }
		end)

		local function macro_component()
			local recording_register = vim.fn.reg_recording()
			if recording_register == '' then
				return ''
			else
				return 'macro @' .. recording_register
			end
		end

		lualine.setup {
			options = {
				icons_enabled = true,
				theme = lualine_theme,
				component_separators = '·',
				section_separators = '',

				ignore_focus = { 'neo-tree' },

				globalstatus = true,

				refresh = {
					statusline = 25,
				},
			},

			sections = {
				lualine_a = {},

				lualine_b = {},

				lualine_c = {
					{
						'mode',
						color = { gui = 'bold' },
						fmt = function(mode)
							return string.lower(mode)
						end,
					},
					{
						'macro',
						fmt = macro_component,
					},
					{
						'branch',
						icon = '󰊢',
					},
					'diff',
					'diagnostics',
				},

				lualine_x = { 'location', 'encoding' },

				lualine_y = {},

				lualine_z = {},
			},
		}

		local function refresh()
			lualine.refresh { place = { 'statusline' } }
		end

		vim.api.nvim_create_autocmd('RecordingEnter', {
			callback = refresh,
		})

		vim.api.nvim_create_autocmd('RecordingLeave', {
			callback = function()
				local timer = vim.loop.new_timer()
				timer:start(50, 0, vim.schedule_wrap(refresh))
			end,
		})
	end,
}
