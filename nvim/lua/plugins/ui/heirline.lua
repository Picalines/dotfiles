return {
	'rebelot/heirline.nvim',

	dependencies = {
		'kyazdani42/nvim-web-devicons',

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'UiEnter',

	config = function()
		local app = require 'util.app'
		local array = require 'util.array'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local hl = require 'util.highlight'
		local tbl = require 'util.table'

		local h_util = require 'heirline.utils'
		local h_conditions = require 'heirline.conditions'

		local heirline = require 'heirline'

		vim.o.laststatus = 3 -- global statusline

		local function setup_colors()
			return {
				normal = hl.attr('Normal', 'fg'),
				visual = hl.attr('@comment', 'fg'),
				search = hl.attr('Search', 'fg'),
				win_separator = hl.attr('WinSeparator', 'fg'),
				muted = hl.attr('@comment', 'fg'),
				attribute = hl.attr('@attribute', 'fg'),
				float_border = hl.attr('FloatBorder', 'fg'),
				diag_error = hl.attr('DiagnosticError', 'fg'),
				diag_warn = hl.attr('DiagnosticWarn', 'fg'),
				diag_info = hl.attr('DiagnosticInfo', 'fg'),
				diag_hint = hl.attr('DiagnosticHint', 'fg'),
				diff_del = hl.attr('@diff.minus', 'fg'),
				diff_add = hl.attr('@diff.plus', 'fg'),
				diff_change = hl.attr('@diff.delta', 'fg'),
			}
		end

		local Space = { provider = ' ', hl = { bg = 'NONE', fg = 'NONE' } }

		local Align = { provider = '%=', hl = { bg = 'NONE', fg = 'NONE' } }

		---@param component table
		---@param child table
		---@param side 'left' | 'right'
		local function Append(component, child, side)
			local condition = component.condition or func.const(true)
			local update = component.update

			component = tbl.copy_deep(component)
			component.condition = nil
			component.update = nil

			return {
				condition = condition,
				update = update,
				side == 'left' and { child, component } or { component, child },
			}
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
			init = function(self)
				self.display_name = self.filename == '' and '[No Name]' or vim.fn.fnamemodify(self.filename, ':t')
			end,

			{
				condition = function(self)
					return self.buffer_prefixes and self.buffer_prefixes[self.bufnr]
				end,

				provider = function(self)
					return self.buffer_prefixes[self.bufnr] .. '/'
				end,

				hl = { fg = 'visual', italic = true },
			},
			{
				provider = function(self)
					return self.is_active and self.display_name or vim.fn.fnamemodify(self.display_name, ':r')
				end,

				hl = function(self)
					return { bold = self.is_active, fg = self.is_active and 'normal' or 'muted' }
				end,
			},
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
				provider = '+',
				hl = { fg = 'diff_add' },
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
				provider = '',
				hl = { fg = 'visual' },
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
			Append(BufferIcon, Space, 'right'),
			Append(BufferName, Space, 'right'),
			Append(ModifiedFlag 'tab', Space, 'right'),
			Append(ReadonlyFlag 'tab', Space, 'right'),
		}

		local function get_listed_buffers()
			return array.filter(vim.api.nvim_list_bufs(), function(bufnr)
				return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
			end)
		end

		local function compute_unique_prefixes(bufnrs)
			-- "inspiration": https://github.com/willothy/nvim-cokeline/blob/adfd1eb87e0804b6b86126e03611db6f62bb2909/lua/cokeline/buffers.lua#L57

			local is_windows = app.os() == 'windows'
			local path_separator = not is_windows and '/' or '\\'

			local prefixes = array.generate(#bufnrs, function()
				return {}
			end)

			local paths = array.map(bufnrs, function(bufnr)
				return vim.fn.reverse(vim.split(vim.api.nvim_buf_get_name(bufnr), path_separator))
			end)

			for i = 1, #paths do
				for j = i + 1, #paths do
					local k = 1
					while paths[i][k] == paths[j][k] and paths[i][k] do
						k = k + 1
						prefixes[i][k - 1] = prefixes[i][k - 1] or paths[i][k]
						prefixes[j][k - 1] = prefixes[j][k - 1] or paths[j][k]
					end
					if k ~= 1 then
						prefixes[i][k - 1] = prefixes[i][k - 1] or paths[i][k]
						prefixes[j][k - 1] = prefixes[j][k - 1] or paths[j][k]
					end
				end
			end

			return array.map(prefixes, function(path)
				return table.concat(vim.fn.reverse(path), '/')
			end)
		end

		local buflist_cache = {}

		local function update_buflist()
			vim.schedule(function()
				buflist_cache = get_listed_buffers()

				if #buflist_cache > 1 then
					vim.o.showtabline = 2 -- always
				elseif vim.o.showtabline ~= 1 then
					vim.o.showtabline = 1 -- only when #tabpages > 1
				end

				local bufnr_to_name = tbl.map(buflist_cache, function(_, bufnr)
					return bufnr, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
				end)

				local name_to_bufnr = tbl.inverse(bufnr_to_name)

				local buffer_prefixes = {}
				for _, bufnrs in pairs(name_to_bufnr) do
					if #bufnrs > 1 then
						local prefixes = compute_unique_prefixes(bufnrs)
						for i, prefix in pairs(prefixes) do
							buffer_prefixes[bufnrs[i]] = prefix
						end
					end
				end

				---@diagnostic disable-next-line: inject-field
				heirline.tabline.buffer_prefixes = buffer_prefixes
			end)
		end

		vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter', 'BufAdd', 'BufDelete' }, {
			callback = update_buflist,
		})

		autocmd.on_user_event('LazyLoad', function(event)
			if event.data == 'heirline.nvim' then
				update_buflist()
			end
		end)

		local BufferLine = h_util.make_buflist(
			Buffer,
			{ provider = '', hl = { fg = 'win_separator' } },
			{ provider = '', hl = { fg = 'win_separator' } },
			function()
				return buflist_cache
			end,
			false
		)

		local TabPage = {
			provider = function(self)
				return '%' .. self.tabnr .. 'T' .. self.tabpage .. ' %T'
			end,
			hl = function(self)
				return { bold = self.is_active, fg = self.is_active and 'normal' or 'muted' }
			end,
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			h_util.make_tablist(TabPage),
		}

		local SidebarOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win

				if vim.bo[bufnr].filetype == 'neo-tree' then
					self.title = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
					return true
				end
			end,

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
				provider = '|',
				hl = { fg = 'win_separator' },
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
					t = 'search',
				},
			},

			provider = function(self)
				return '%2(' .. (self.mode_names[self.mode] or self.mode) .. '%)'
			end,

			hl = function(self)
				local mode = self.mode:sub(1, 1) -- get only the first mode character
				return { fg = self.mode_colors[mode], bold = true }
			end,

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

			provider = function()
				return ' ' .. vim.fn.reg_recording()
			end,

			hl = { fg = 'search', bold = true },

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

				provider = function(self)
					return self.icon .. ' ' .. tostring(self.diagnostic_count)
				end,

				hl = { fg = opts.hl },
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

				local current_buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
				self.is_in_terminal = current_buftype == 'terminal'

				local terminal = require 'terminal'
				local active_terminals = require 'terminal.active_terminals'

				self.current_terminal = terminal.current_term_index() or 0
				self.terminal_count = active_terminals:len()
			end,

			condition = function()
				local ok, active_terminals = pcall(require, 'terminal.active_terminals')
				return ok and active_terminals:len() > 0
			end,

			provider = function(self)
				local indicator
				if not self.is_in_terminal then
					indicator = tostring(self.terminal_count)
				else
					indicator = tostring(self.current_terminal) .. '/' .. tostring(self.terminal_count)
				end

				return indicator .. ' ' .. self.icon
			end,

			hl = { fg = 'attribute' },
		}

		local Ruler = {
			-- %l = current line number
			-- %L = number of lines in the buffer
			-- %c = column number
			-- %P = percentage through file of displayed window
			provider = '%04l/%04L:%04c',
			hl = { fg = 'muted' },
		}

		local ScrollBar = {
			static = {
				sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
			},

			provider = function(self)
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
				return self.sbar[i]
			end,

			hl = { fg = 'muted', bg = 'float_border' },
		}

		local LSPActive = {
			condition = h_conditions.lsp_attached,
			update = { 'LspAttach', 'LspDetach' },

			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
					table.insert(names, server.name)
				end
				return table.concat(names, ' ') .. ' '
			end,

			hl = { fg = 'search', bold = true },
		}

		local LeftStatusline = array.map({
			ViMode,
			MacroRec,
			Git,
			ModifiedFlag 'status',
			ReadonlyFlag 'status',
			ErrorCount,
			WarningCount,
			InfoCount,
			HintCount,
		}, function(component)
			return Append(component, Space, 'left')
		end)

		local RightStatusline = array.map({
			TerminalList,
			LSPActive,
			Ruler,
			ScrollBar,
		}, function(component)
			return Append(component, Space, 'right')
		end)

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
				Append(SidebarOffset, Space, 'right'),
				BufferLine,
				Align,
				Append(TabPageList, Space, 'left'),
			},
			opts = {
				colors = setup_colors(),
			},
		}

		vim.api.nvim_create_augroup('Heirline', { clear = true })

		autocmd.on_colorscheme('*', function()
			h_util.on_colorscheme(setup_colors())
		end)

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
		vim.cmd [[:au VimLeavePre * set tabline=]]
	end,
}
