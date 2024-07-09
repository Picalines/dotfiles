return {
	'willothy/nvim-cokeline',

	enabled = false, -- replaced by heirline.nvim

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

		local function get_sign_text(name)
			return (vim.fn.sign_getdefined(name)[1] or {}).text
		end

		local function get_sign_texthl(name)
			return (vim.fn.sign_getdefined(name)[1] or {}).texthl
		end

		local muted_hl = '@comment'

		require('cokeline').setup {
			default_hl = {
				fg = function(buffer_or_tab)
					return get_fg((buffer_or_tab.is_focused or buffer_or_tab.is_active) and 'Normal' or muted_hl)
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
						bold = function(buffer)
							return buffer.is_focused
						end,
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
					fg = get_fg_dyn 'WinSeparator',
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
					fg = get_fg_dyn(muted_hl),
					italic = true,
				},
				{
					text = function(buffer)
						return buffer.unique_prefix
					end,
					fg = get_fg_dyn(muted_hl),
				},
				{
					text = function(buffer)
						return buffer.filename
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
						local sign_text
						local d = buffer.diagnostics
						if d.errors > 0 then
							sign_text = get_sign_text 'DiagnosticSignError'
						elseif d.warnings > 0 then
							sign_text = get_sign_text 'DiagnosticSignWarn'
						end

						return sign_text and (' ' .. sign_text:sub(1, -2)) or ''
					end,
					fg = function(buffer)
						local d = buffer.diagnostics
						if d.errors > 0 then
							return get_sign_texthl 'DiagnosticSignError'
						elseif d.warnings > 0 then
							return get_sign_texthl 'DiagnosticSignWarn'
						end
					end,
				},
				{
					text = function(buffer)
						return buffer.is_modified and ' +' or ''
					end,
					bold = true,
				},
				{
					text = ' ',
				},
			},

			tabs = {
				placement = 'right',
				components = {
					{
						text = function(tab)
							if tab.is_first and tab.is_last then
								return ''
							end
							return ' ' .. tostring(tab.number) .. ' '
						end,
					},
					{
						text = function(tab)
							return tab.is_last and '' or '|'
						end,
						fg = get_fg_dyn 'WinSeparator',
					},
				},
			},
		}
	end,
}
