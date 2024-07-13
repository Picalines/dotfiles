return {
	'rebelot/heirline.nvim',

	enabled = true, -- TODO: replace cokeline & lualine

	dependencies = {
		'kyazdani42/nvim-web-devicons',

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'UiEnter',

	config = function()
		vim.o.laststatus = 3 -- global statusline

		local util = require 'util'
		local h_util = require 'heirline.utils'
		local h_conditions = require 'heirline.conditions'

		---@param hl_name string
		---@param attribute 'fg' | 'bg'
		local function get_highlight(hl_name, attribute)
			local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = true, create = false })
			if hl.link then
				return get_highlight(hl.link, attribute)
			end

			return hl[attribute] or get_highlight('Normal', attribute) or 'red'
		end

		local function setup_colors()
			return {
				normal = get_highlight('Normal', 'fg'),
				visual = get_highlight('@comment', 'fg'),
				cursor = get_highlight('Cursor', 'fg'),
				search = get_highlight('Search', 'fg'),
				win_separator = get_highlight('WinSeparator', 'fg'),
				muted = get_highlight('@comment', 'fg'),
				float_border = get_highlight('FloatBorder', 'fg'),
				diag_warn = get_highlight('DiagnosticWarn', 'fg'),
				diag_error = get_highlight('DiagnosticError', 'fg'),
				diag_hint = get_highlight('DiagnosticHint', 'fg'),
				diag_info = get_highlight('DiagnosticInfo', 'fg'),
				diff_del = get_highlight('@diff.minus', 'fg'),
				diff_add = get_highlight('@diff.plus', 'fg'),
				diff_change = get_highlight('@diff.delta', 'fg'),
			}
		end

		local Space = { provider = ' ', hl = { bg = 'NONE', fg = 'NONE' } }

		local Align = { provider = '%=', hl = { bg = 'NONE', fg = 'NONE' } }

		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ':e')
				self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. ' ')
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
				return filename
			end,
			hl = function(self)
				local is_current = self.is_active
				return { bold = is_current, fg = is_current and 'normal' or 'muted' }
			end,
		}

		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
				end,
				provider = ' +',
				hl = { fg = 'diff_add' },
			},
		}

		local Buffer = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			on_click = {
				callback = function(_, minwid)
					vim.api.nvim_win_set_buf(0, minwid)
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = 'heirline_tabline_buffer_callback',
			},
			FileIcon,
			TablineFileName,
			TablineFileFlags,
			Space,
		}

		local get_bufs = function()
			return vim.tbl_filter(function(bufnr)
				return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
			end, vim.api.nvim_list_bufs())
		end

		local buflist_cache = {}

		local function update_buflist()
			vim.schedule(function()
				local buffers = get_bufs()
				for i, v in ipairs(buffers) do
					buflist_cache[i] = v
				end
				for i = #buffers + 1, #buflist_cache do
					buflist_cache[i] = nil
				end

				if #buflist_cache > 1 then
					vim.o.showtabline = 2 -- always
				elseif vim.o.showtabline ~= 1 then
					vim.o.showtabline = 1 -- only when #tabpages > 1
				end
			end)
		end

		vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter', 'BufAdd', 'BufDelete' }, {
			callback = update_buflist,
		})

		vim.api.nvim_create_autocmd({ 'User' }, {
			pattern = 'LazyLoad',
			callback = function(event)
				if event.data == 'heirline.nvim' then
					update_buflist()
				end
			end,
		})

		local BufferLine = h_util.make_buflist(Buffer, { provider = '', hl = { fg = 'gray' } }, { provider = '', hl = { fg = 'gray' } }, function()
			return buflist_cache
		end, false)

		local Tabpage = {
			provider = function(self)
				return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T'
			end,
			hl = function(self)
				return { bold = self.is_active, fg = self.is_active and 'normal' or 'muted' }
			end,
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{ provider = '%=' },
			h_util.make_tablist(Tabpage),
		}

		local TabLineOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win

				if vim.bo[bufnr].filetype == 'neo-tree' then
					self.title = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
					return true
				end
			end,

			flexible = 1,

			{
				{
					provider = function(self)
						local title = self.title
						local width = math.max(0, vim.api.nvim_win_get_width(self.winid) - 1)
						local pad = math.max(0, width - #title)
						return title:sub(1, width) .. string.rep(' ', pad)
					end,

					hl = function(self)
						local is_focused = vim.api.nvim_get_current_win() == self.winid
						return { bold = is_focused, fg = is_focused and 'normal' or 'muted' }
					end,
				},
				{
					provider = '| ',
					hl = { fg = 'win_separator' },
				},
			},

			{
				provider = function(self)
					return self.title
				end,

				hl = function(self)
					local is_focused = vim.api.nvim_get_current_win() == self.winid
					return { bold = is_focused, fg = is_focused and 'normal' or 'muted' }
				end,

				{
					provider = ' > ',
					hl = { fg = 'win_separator' },
				},
			},
		}

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
			{
				-- %l = current line number
				-- %L = number of lines in the buffer
				-- %c = column number
				-- %P = percentage through file of displayed window
				provider = '%04l/%04L:%04c',
				hl = { fg = 'muted' },
			},
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
			hl = { fg = 'muted', bg = 'float_border' },
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

			hl = { fg = 'cursor', bold = true },
		}

		---@param component table
		---@param child table
		---@param side 'left' | 'right'
		local function Append(component, child, side)
			local condition = component.condition or function()
				return true
			end

			component = util.copy_deep(component)
			component.condition = nil

			local spaced = { condition = condition, component }
			table.insert(spaced, side == 'left' and 1 or #component, child)

			return spaced
		end

		local LeftStatusline = util.map({
			ViMode,
			MacroRec,
			Git,
			Diagnostics,
		}, function(component)
			return Append(component, Space, 'left')
		end)

		local RightStatusline = util.map({
			LSPActive,
			Ruler,
			ScrollBar,
		}, function(component)
			return Append(component, Space, 'right')
		end)

		local heirline = require 'heirline'

		heirline.setup {
			---@diagnostic disable-next-line: missing-fields
			statusline = {
				LeftStatusline,
				Align,
				RightStatusline,
			},
			---@diagnostic disable-next-line: missing-fields
			tabline = {
				Space,
				TabLineOffset,
				BufferLine,
				TabPageList,
			},
			opts = {
				colors = setup_colors(),
			},
		}

		vim.api.nvim_create_augroup('Heirline', { clear = true })
		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			group = 'Heirline',
			callback = function()
				h_util.on_colorscheme(setup_colors())
			end,
		})

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
		vim.cmd [[:au VimLeavePre * set tabline=]]
	end,
}
