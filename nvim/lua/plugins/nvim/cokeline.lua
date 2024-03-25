return {
	'willothy/nvim-cokeline',

	enabled = true,

	dependencies = {
		'nvim-lua/plenary.nvim',
		'kyazdani42/nvim-web-devicons',
		-- 'stevearc/resession.nvim', -- Optional, for persistent history

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	config = function()
		local get_hex = require('cokeline.hlgroups').get_hl_attr
		local sidebar_win = require('cokeline.sidebar').get_win

		local function get_fg(hl)
			return get_hex(hl, 'fg')
		end

		local function get_bg(hl)
			return get_hex(hl, 'bg')
		end

		local function get_fg_dyn(hl)
			return function()
				return get_fg(hl)
			end
		end

		local function get_bg_dyn(hl)
			return function()
				return get_bg(hl)
			end
		end

		local function is_sidebar_opened()
			return sidebar_win 'left' ~= nil
		end

		require('cokeline').setup {
			default_hl = {
				fg = function(buffer)
					return get_fg(buffer.is_focused and 'Normal' or 'Comment')
				end,
				bg = get_bg_dyn 'Normal',
			},

			fill_hl = 'Normal',

			sidebar = {
				filetype = { 'NvimTree', 'neo-tree' },
				components = {
					{
						text = ' ',
					},
					{
						text = function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
						end,
						fg = get_fg_dyn 'Normal',
						bold = true,
					},
				},
			},

			buffers = {
				filter_visible = function(buffer)
					return buffer.type ~= 'terminal' and buffer.type ~= 'quickfix'
				end,
			},

			components = {
				{
					text = function(buffer)
						if buffer.index > 1 or is_sidebar_opened() then
							return '│ '
						end
						return ' '
					end,
					fg = get_fg_dyn 'VertSplit',
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
					fg = get_fg_dyn 'Comment',
					italic = true,
				},
				{
					text = function(buffer)
						return buffer.unique_prefix
					end,
					fg = get_fg_dyn 'Comment',
				},
				{
					text = function(buffer)
						return buffer.filename
					end,
					fg = function(buffer)
						local d = buffer.diagnostics
						if d.errors > 0 then
							return get_fg 'DiagnosticOk'
						elseif d.warnings > 0 then
							return get_fg 'DiagnosticWarn'
						end
					end,
					bold = function(buffer)
						return buffer.is_focused
					end,
					strikethrough = function(buffer)
						return not buffer:is_valid()
					end,
					italic = function(buffer)
						return buffer.is_readonly
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
