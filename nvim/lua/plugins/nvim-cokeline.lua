return {
	'willothy/nvim-cokeline',

	enabled = false, -- WIP

	dependencies = {
		'nvim-lua/plenary.nvim',
		'kyazdani42/nvim-web-devicons',
		-- 'stevearc/resession.nvim', -- Optional, for persistent history

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	config = function()
		local empty = {}

		local function get_hl(hl_name)
			local id = vim.api.nvim_get_hl_id_by_name(hl_name)
			return vim.api.nvim_get_hl(id, empty)
		end

		local function get_fg(hl_name)
			local f = get_hl(hl_name).foreground
			return f
		end

		local function get_bg(hl_name)
			return get_hl(hl_name).background
		end

		local function fg_getter(hl_name)
			return function()
				return get_fg(hl_name)
			end
		end

		local function bg_getter(hl_name)
			return function()
				return get_bg(hl_name)
			end
		end

		require('cokeline').setup {
			default_hl = {
				fg = function(buffer)
					return buffer.is_focused and get_fg 'Normal' or get_fg 'Comment'
				end,
				bg = bg_getter 'ColorColumn',
			},

			sidebar = {
				filetype = { 'NvimTree', 'neo-tree' },
				components = {
					{
						text = ' ',
					},
					{
						text = function(buf)
							return buf.filetype
						end,
						fg = fg_getter 'NeoTreeNormal',
						bold = true,
					},
				},
			},

			components = {
				{
					text = '│',
					fg = fg_getter 'ColorColumn',
				},
				{
					text = function(buffer)
						return buffer.devicon.icon
					end,
					fg = function(buffer)
						return buffer.devicon.color
					end,
				},
				{
					text = function(buffer)
						return buffer.unique_prefix
					end,
					fg = fg_getter 'Comment',
					italic = true,
				},
				{
					text = function(buffer)
						return buffer.filename
					end,
					bold = function(buffer)
						return buffer.is_focused
					end,
				},
				{
					text = function(buffer)
						return buffer.is_modified and ' +' or ''
					end,
				},
				{
					text = ' ',
				},
			},
		}
	end,
}
