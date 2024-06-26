return {
	'nvim-lualine/lualine.nvim',

	config = function()
		local util = require 'util'

		local noice_status = require('noice').api.status

		local function get_neotree_winid()
			local fs_state = require('neo-tree.sources.manager').get_state 'filesystem'
			if not fs_state then
				return nil
			end

			local is_opened = require('neo-tree.ui.renderer').is_window_valid(fs_state.winid)
			return is_opened and fs_state.winid or nil
		end

		local function get_neotree_width()
			local fs_winid = get_neotree_winid()
			return fs_winid ~= nil and vim.api.nvim_win_get_width(fs_winid) or 0
		end

		local neotree_shift = {
			function()
				return string.rep(' ', math.max(0, get_neotree_width() - 1)) .. '│'
			end,
			cond = function()
				return get_neotree_winid() ~= nil
			end,
			color = function()
				return { fg = require('cokeline.hlgroups').get_hl_attr('WinSeparator', 'fg'), bg = 'NONE' }
			end,
		}

		local opts = {
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = '',
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
					'branch',
					'diff',
					'diagnostics',
					{
						---@diagnostic disable-next-line: undefined-field
						noice_status.mode.get,
						---@diagnostic disable-next-line: undefined-field
						cond = noice_status.mode.has,
						color = { fg = '#ff9e64' },
					},
				},

				lualine_x = { 'location', 'encoding' },

				lualine_y = {},

				lualine_z = {},
			},
		}

		local SIDEBAR_SHIFT_ENABLED = false
		if SIDEBAR_SHIFT_ENABLED then
			table.insert(opts.sections.lualine_c, 0, neotree_shift)
		end

		for _, section in pairs(opts.sections) do
			for i, component in pairs(section) do
				if type(component) ~= 'table' then
					---@diagnostic disable-next-line: cast-local-type
					component = { component }
				end

				---@diagnostic disable-next-line: assign-type-mismatch
				section[i] = util.override_deep({ color = { bg = 'NONE' } }, component)
			end
		end

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
