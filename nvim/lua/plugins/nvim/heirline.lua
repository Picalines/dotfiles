return {
	'rebelot/heirline.nvim',

	enabled = false, -- TODO: replace cokeline & lualine

	event = 'UiEnter',

	config = function()
		local util = require 'util'
		local h_util = require 'heirline.utils'
		local h_conditions = require 'heirline.conditions'

		local colors = {
			normal = h_util.get_highlight('Normal').fg,
			visual = h_util.get_highlight('@comment').fg,
			cursor = h_util.get_highlight('Cursor').fg,
			search = h_util.get_highlight('Search').fg,
			float_border = h_util.get_highlight('FloatBorder').fg,
			diag_warn = h_util.get_highlight('DiagnosticWarn').fg,
			diag_error = h_util.get_highlight('DiagnosticError').fg,
			diag_hint = h_util.get_highlight('DiagnosticHint').fg,
			diag_info = h_util.get_highlight('DiagnosticInfo').fg,
			diff_del = h_util.get_highlight('DiffDelete').fg,
			diff_add = h_util.get_highlight('DiffAdd').fg,
			diff_change = h_util.get_highlight('DiffChange').fg,
		}

		local Space = { provider = ' ', hl = { bg = 'NONE', fg = 'NONE' } }

		local Align = { provider = '%=' }

		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = 'normal',
					no = 'normal',
					niI = 'normal:^o',
					niR = 'normal:^or',
					niV = 'normal:^ovr',
					nt = 'normal:t',
					v = 'visual',
					vs = 'visual:^o',
					V = 'visual:l',
					Vs = 'visual:l^o',
					['\22'] = 'visual:b',
					['\22s'] = 'visual:b^o',
					s = 'select',
					S = 'select:l',
					['\19'] = 'select:b',
					i = 'insert',
					ic = 'insert:c',
					ix = 'insert:x',
					R = 'replace',
					Rc = 'replace:c',
					Rx = 'replace:x',
					Rv = 'replace:v',
					Rvc = 'replace:vc',
					Rvx = 'replace:vx',
					c = 'command',
					cv = 'command:ex',
					r = '...',
					rm = '-- more --',
					['r?'] = 'confirm',
					['!'] = 'shell',
					t = 'terminal',
				},
				mode_colors = {
					n = 'normal',
					i = 'diff_add',
					v = 'visual',
					V = 'visual',
					['\22'] = 'visual',
					c = 'search',
					s = 'visual',
					S = 'visual',
					['\19'] = 'visual',
					R = 'diff_change',
					r = 'diff_change',
					['!'] = 'red',
					t = 'cursor',
				},
			},
			{
				provider = function(self)
					return '%2(' .. (self.mode_names[self.mode] or self.mode) .. '%)'
				end,
				hl = function(self)
					local mode = self.mode:sub(1, 1) -- get only the first mode character
					return { fg = self.mode_colors[mode], bold = true }
				end,
			},
			update = {
				'ModeChanged',
				pattern = '*:*',
				callback = vim.schedule_wrap(function()
					vim.cmd 'redrawstatus'
				end),
			},
		}

		local MacroRec = {
			condition = function()
				return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
			end,
			{
				provider = ' ',
				hl = { fg = 'search', bold = true },
			},
			{
				provider = function()
					return vim.fn.reg_recording()
				end,
				hl = { fg = 'search', bold = true },
			},
			update = {
				'RecordingEnter',
				'RecordingLeave',
			},
		}

		local Git = {
			condition = h_conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
			end,

			hl = { fg = 'diff_change' },

			{
				provider = function(self)
					return '󰊢 ' .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ' ',
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ('+' .. count)
				end,
				hl = { fg = 'diff_add' },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ('-' .. count)
				end,
				hl = { fg = 'diff_del' },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ('~' .. count)
				end,
				hl = { fg = 'diff_change' },
			},
		}

		local Diagnostics = {
			condition = h_conditions.has_diagnostics,

			static = {
				error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
				warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
				info_icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
				hint_icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
			},

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,

			update = { 'DiagnosticChanged', 'BufEnter' },

			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
				end,
				hl = { fg = 'diag_error' },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
				end,
				hl = { fg = 'diag_warn' },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. ' ')
				end,
				hl = { fg = 'diag_info' },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = 'diag_hint' },
			},
		}

		local Ruler = {
			-- %l = current line number
			-- %L = number of lines in the buffer
			-- %c = column number
			-- %P = percentage through file of displayed window
			provider = '%04l:%04c',
			hl = { fg = 'normal' },
		}

		local ScrollBar = {
			static = {
				sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
			},
			{
				provider = function(self)
					local curr_line = vim.api.nvim_win_get_cursor(0)[1]
					local lines = vim.api.nvim_buf_line_count(0)
					local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
					return self.sbar[i]
				end,
			},
			hl = { fg = 'diag_hint', bg = 'float_border' },
		}

		local LSPActive = {
			condition = h_conditions.lsp_attached,
			update = { 'LspAttach', 'LspDetach' },

			{
				provider = function()
					local names = {}
					for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
						table.insert(names, server.name)
					end
					return table.concat(names, ' ') .. ' '
				end,
			},

			hl = { fg = 'visual', bold = true },
		}

		vim.o.laststatus = 3 -- global statusline

		local LeftStatusline = util.map({
			ViMode,
			MacroRec,
			Git,
			Diagnostics,
		}, function(component)
			return util.join({ Space }, component)
		end)

		local RightStatusline = util.map({
			LSPActive,
			Ruler,
			ScrollBar,
		}, function(component)
			return util.join(component, { Space })
		end)

		local heirline = require 'heirline'

		heirline.setup {
			---@diagnostic disable-next-line: missing-fields
			statusline = {
				LeftStatusline,
				Align,
				RightStatusline,
			},
		}

		heirline.load_colors(colors)

		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			pattern = '*',
			callback = function()
				heirline.load_colors(colors)
				heirline.reset_highlights()
			end,
		})

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
	end,
}
