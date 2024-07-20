return {
	'rebelot/heirline.nvim',

	enabled = true, -- TODO: replace cokeline & lualine

	dependencies = {
		'kyazdani42/nvim-web-devicons',

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'UiEnter',

	config = function()
		local tbl = require 'util.table'
		local hl = require 'util.highlight'
		local h_util = require 'heirline.utils'
		local h_conditions = require 'heirline.conditions'

		vim.o.laststatus = 3 -- global statusline

		local function setup_colors()
			return {
				normal = hl.hl_attr('Normal', 'fg'),
				visual = hl.hl_attr('@comment', 'fg'),
				cursor = hl.hl_attr('Cursor', 'fg'),
				search = hl.hl_attr('Search', 'fg'),
				win_separator = hl.hl_attr('WinSeparator', 'fg'),
				muted = hl.hl_attr('@comment', 'fg'),
				float_border = hl.hl_attr('FloatBorder', 'fg'),
				diag_error = hl.hl_attr('DiagnosticError', 'fg'),
				diag_warn = hl.hl_attr('DiagnosticWarn', 'fg'),
				diag_info = hl.hl_attr('DiagnosticInfo', 'fg'),
				diag_hint = hl.hl_attr('DiagnosticHint', 'fg'),
				diff_del = hl.hl_attr('@diff.minus', 'fg'),
				diff_add = hl.hl_attr('@diff.plus', 'fg'),
				diff_change = hl.hl_attr('@diff.delta', 'fg'),
			}
		end

		local Space = { provider = ' ', hl = { bg = 'NONE', fg = 'NONE' } }

		local Align = { provider = '%=', hl = { bg = 'NONE', fg = 'NONE' } }

		---@param component table
		---@param child table
		---@param side 'left' | 'right'
		local function Append(component, child, side)
			local condition = component.condition or function()
				return true
			end

			component = tbl.copy_deep(component)
			component.condition = nil

			local wrapped = { condition = condition, component }
			table.insert(wrapped, side == 'left' and 1 or (#component + 1), child)

			return wrapped
		end

		local BufferIcon = {
			init = function(self)
				local icons_ok, icons = pcall(require, 'nvim-web-devicons')
				if icons_ok then
					local filename = self.filename
					local extension = vim.fn.fnamemodify(filename, ':e')
					self.icon, self.icon_color = icons.get_icon_color(filename, extension, { default = true })
				else
					self.icon, self.icon_color = nil, 'normal'
				end
			end,
			provider = function(self)
				return self.icon or ''
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local BufferName = {
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

		---@param line_type 'status' | 'tab'
		local function ModifiedFlag(line_type)
			local condition

			if line_type == 'status' then
				condition = function()
					return not h_conditions.is_git_repo() and vim.bo.buftype ~= 'prompt' and vim.bo.modified
				end
			elseif line_type == 'tab' then
				condition = function(self)
					return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
				end
			end

			return {
				condition = condition,
				{
					provider = '+',
					hl = { fg = 'diff_add' },
				},
			}
		end

		---@param line_type 'status' | 'tab'
		local function ReadonlyFlag(line_type)
			local condition

			if line_type == 'status' then
				condition = function()
					return vim.bo.buftype ~= 'terminal' and (not vim.bo.modifiable or vim.bo.readonly)
				end
			elseif line_type == 'tab' then
				condition = function(self)
					return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr }) or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
				end
			end

			return {
				condition = condition,
				{
					provider = '',
					hl = { fg = 'visual' },
				},
			}
		end

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
			BufferIcon,
			Append(BufferName, Space, 'left'),
			Append(ModifiedFlag 'tab', Space, 'left'),
			Append(ReadonlyFlag 'tab', Space, 'left'),
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

		---@class DiagnisticCounterOpts
		---@field severity vim.diagnostic.Severity
		---@field fallback_icon string
		---@field hl string

		---@param opts DiagnisticCounterOpts
		local function DiagnisticCounter(opts)
			local function get_diagnostic_count()
				return #vim.diagnostic.get(0, { severity = opts.severity })
			end

			return {
				condition = function()
					return get_diagnostic_count() > 0
				end,

				update = { 'DiagnosticChanged', 'BufEnter' },

				init = function(self)
					self.icon = vim.diagnostic.config().signs.text[opts.severity] or opts.fallback_icon
					self.diagnostic_count = get_diagnostic_count()
				end,

				{
					hl = { fg = opts.hl },
					provider = function(self)
						return self.icon .. ' ' .. tostring(self.diagnostic_count)
					end,
				},
			}
		end

		local ErrorCount = DiagnisticCounter { severity = vim.diagnostic.severity.ERROR, fallback_icon = 'E', hl = 'diag_error' }
		local WarningCount = DiagnisticCounter { severity = vim.diagnostic.severity.WARN, fallback_icon = 'W', hl = 'diag_warn' }
		local InfoCount = DiagnisticCounter { severity = vim.diagnostic.severity.INFO, fallback_icon = 'I', hl = 'diag_info' }
		local HintCount = DiagnisticCounter { severity = vim.diagnostic.severity.HINT, fallback_icon = 'H', hl = 'diag_hint' }

		local TerminalList = {
			update = { 'TermOpen', 'TermClose', 'BufEnter' },

			init = function(self)
				self.icon = ''

				local terms = require 'toggleterm.terminal'
				local all_terminals = terms.get_all(true)

				local current_index, _ = tbl.find(all_terminals, function(term)
					return term:is_focused()
				end)

				local current_buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })

				self.is_in_terminal = current_buftype == 'terminal'
				self.current_terminal = current_index
				self.terminal_count = #all_terminals
			end,

			condition = function()
				local require_ok, terms = pcall(require, 'toggleterm.terminal')
				if not require_ok then
					return false
				end

				local all_terminals = terms.get_all(true)
				return #all_terminals > 0
			end,

			{

				provider = function(self)
					local indicator
					if not self.is_in_terminal then
						indicator = tostring(self.terminal_count)
					else
						indicator = tostring(self.current_terminal) .. '/' .. tostring(self.terminal_count)
					end

					return self.icon .. ' ' .. indicator
				end,

				hl = { fg = 'visual' },
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

		local LeftStatusline = tbl.map({
			ViMode,
			MacroRec,
			Git,
			ModifiedFlag 'status',
			ReadonlyFlag 'status',
			ErrorCount,
			WarningCount,
			InfoCount,
			HintCount,
			TerminalList,
		}, function(component)
			return Append(component, Space, 'left')
		end)

		local RightStatusline = tbl.map({
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
