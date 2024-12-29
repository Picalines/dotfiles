return {
	'rebelot/heirline.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',

		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'VeryLazy',

	config = function()
		local app = require 'util.app'
		local array = require 'util.array'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local signal = require 'util.signal'
		local str = require 'util.string'
		local tbl = require 'util.table'

		local devicons = require 'nvim-web-devicons'
		local h_util = require 'heirline.utils'
		local h_conditions = require 'heirline.conditions'

		local heirline = require 'heirline'

		local augroup = autocmd.group 'heirline'

		local tab_winids = signal.new {} --[=[@as integer[]]=]
		augroup:on({ 'TabNew', 'WinNew', 'WinEnter', 'BufWinEnter', 'TermOpen' }, '*', function()
			tab_winids(vim.api.nvim_tabpage_list_wins(0))
		end)

		local has_normal_bufs = signal.derive(function()
			return array.some(tab_winids(), function(winid)
				local buf = vim.api.nvim_win_get_buf(winid)
				local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
				local config = vim.api.nvim_win_get_config(winid)
				return buftype == '' and config.relative == ''
			end)
		end)

		vim.o.laststatus = 3 -- global statusline

		signal.watch(function()
			vim.o.showtabline = has_normal_bufs() and 2 or 1 -- always OR only when #tabpages > 1
		end)

		---@param text string
		---@param opts? table
		local function Text(text, opts)
			return tbl.override_deep({ provider = text }, opts or {})
		end

		local Space = Text(' ', { hl = { fg = 'NONE' } })

		local Align = Text('%=', { hl = { fg = 'NONE' } })

		---@param decorate fun(c: table): table
		local function Decorated(decorate)
			---@param component table
			return function(component)
				local condition = component.condition or func.const(true)
				local update = component.update

				component = tbl.copy_deep(component)
				component.condition = nil
				component.update = nil

				return {
					condition = condition,
					update = update,
					decorate(component),
				}
			end
		end

		local Bold = Decorated(function(component)
			return { hl = { bold = true }, component }
		end)

		---@param child table
		---@param side 'left' | 'right'
		local function Append(child, side)
			return Decorated(function(component)
				return side == 'left' and { child, component } or { component, child }
			end)
		end

		---@param separator table
		---@param side 'left' | 'right'
		local function AppendAll(separator, side)
			local appender = Append(separator, side)
			---@param components table[]
			return function(components)
				return array.map(components, appender)
			end
		end

		local BufferIcon = {
			init = function(self)
				self.icon, self.hl = devicons.get_icon(vim.fn.fnamemodify(self.filename, ':t'))
				self.icon = self.icon or ''
			end,

			provider = func.field 'icon',

			hl = func.field 'hl',
		}

		local BufferName = {
			init = function(self)
				self.display_name = self.filename == '' and string.format('[%d]', self.bufnr) or vim.fn.fnamemodify(self.filename, ':t')
			end,

			hl = function(self)
				return self.is_active and 'Normal' or '@comment'
			end,

			{
				condition = function(self)
					return self.buffer_prefixes and self.buffer_prefixes[self.bufnr]
				end,

				provider = function(self)
					return self.buffer_prefixes[self.bufnr] .. '/'
				end,
			},
			{
				hl = function(self)
					return { bold = self.is_active }
				end,

				{
					provider = function(self)
						return self.is_active and self.display_name or vim.fn.fnamemodify(self.display_name, ':r:r:r')
					end,
				},
			},
		}

		---@param line_type 'status' | 'tab'
		local function ModifiedFlag(line_type)
			local condition

			if line_type == 'status' then
				condition = function()
					return vim.bo.buftype ~= 'prompt' and vim.bo.modified
				end
			elseif line_type == 'tab' then
				condition = function(self)
					return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
				end
			end

			return Text('+', {
				condition = condition,
				hl = '@diff.plus',
			})
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

			return Text('', {
				condition = condition,
				hl = '@comment',
			})
		end

		augroup:on('BufWritePost', '*', function(event)
			vim.b[event.buf].was_written = true
			vim.cmd.redrawtabline()
		end)

		local Buffer = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,

			on_click = {
				minwid = func.field 'bufnr',
				name = 'heirline_tabline_buffer_callback',
				callback = function(_, minwid)
					vim.api.nvim_win_set_buf(0, minwid)
				end,
			},

			AppendAll(Space, 'right') {
				BufferIcon,
				{
					BufferName,

					hl = function(self)
						local was_written = vim.b[self.bufnr].was_written
						return { italic = not was_written, underline = not was_written }
					end,
				},
				ModifiedFlag 'tab',
				ReadonlyFlag 'tab',
			},
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
			buflist_cache = get_listed_buffers()

			local bufnr_to_name = tbl.map(buflist_cache, function(_, bufnr)
				return bufnr, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
			end)

			local name_to_bufnr = tbl.inverse(bufnr_to_name)

			local buffer_prefixes = {}
			for bufname, bufnrs in pairs(name_to_bufnr) do
				if #bufname > 0 and #bufnrs > 1 then
					local prefixes = compute_unique_prefixes(bufnrs)
					for i, prefix in pairs(prefixes) do
						buffer_prefixes[bufnrs[i]] = prefix
					end
				end
			end

			---@diagnostic disable-next-line: inject-field
			heirline.tabline.buffer_prefixes = buffer_prefixes
		end

		augroup:on({ 'VimEnter', 'UIEnter', 'TabEnter', 'BufAdd', 'BufDelete' }, '*', vim.schedule_wrap(update_buflist))

		augroup:on_user('LazyLoad', function(event)
			if event.data == 'heirline.nvim' then
				update_buflist()
			end
		end)

		local BufferLine = h_util.make_buflist(Buffer, Text(' ', { hl = '@comment' }), Text('', { hl = '@comment' }), function()
			return buflist_cache
		end, false)

		local TabPage = {
			hl = function(self)
				return { bold = self.is_active }
			end,

			{
				provider = function(self)
					return str.fmt(' %', self.tabnr, 'T', vim.t[self.tabpage].tab_label or str.fmt('[', self.tabnr, ']'), '%T')
				end,

				hl = function(self)
					return self.is_active and 'Normal' or '@comment'
				end,
			},
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{
				Text('', { hl = '@comment' }),
				h_util.make_tablist(TabPage),
			},
		}

		local SidebarOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win

				return has_normal_bufs() and vim.bo[bufnr].filetype == 'neo-tree'
			end,

			init = function(self)
				self.is_focused = vim.api.nvim_get_current_win() == self.winid

				local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
				self.title = string.format(' %s', cwd)
			end,

			hl = function(self)
				return { bold = self.is_focused }
			end,

			{
				provider = function(self)
					local width = math.max(0, vim.api.nvim_win_get_width(self.winid))
					return str.pad_center(self.title, width, {
						pad_char = ' ',
						align_odd = 'left',
					})
				end,

				hl = function(self)
					return self.is_focused and 'Directory' or '@comment'
				end,
			},

			Text('│%<', { hl = 'WinSeparator' }),

			Space,
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
				mode_hls = {
					n = 'Normal',
					i = '@diff.plus',
					v = '@comment',
					V = '@comment',
					['\22'] = '@comment',
					c = 'DiagnosticInfo',
					s = '@comment',
					S = '@comment',
					['\19'] = '@comment',
					R = '@diff.change',
					r = '@diff.change',
					['!'] = '@diff.minus',
					t = 'DiagnosticWarn',
				},
			},

			Bold {
				Text('', { hl = '@diff.plus' }),

				AppendAll(Space, 'left') {
					{
						condition = function()
							return #vim.fn.state 'o' > 0
						end,

						Text '',

						hl = 'DiagnosticWarn',
					},
					{
						provider = function(self)
							return self.mode_names[self.mode] or self.mode
						end,

						hl = function(self)
							return self.mode_hls[self.mode:sub(1, 1)]
						end,
					},
				},
			},

			update = {
				'ModeChanged',
				pattern = '*:*',
				callback = vim.schedule_wrap(func.cmd 'redrawstatus'),
			},
		}

		local MacroRec = Bold {
			condition = function()
				return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
			end,

			hl = '@keyword',

			provider = function()
				return ' ' .. vim.fn.reg_recording()
			end,

			update = {
				'RecordingEnter',
				'RecordingLeave',
			},
		}

		local search_shown = signal.new(false)

		augroup:on('CmdlineEnter', { '/', '?' }, func.curry(search_shown, true))
		augroup:on_user('Dismiss', func.curry(search_shown, false))

		signal.on(search_shown, vim.schedule_wrap(vim.cmd.redrawstatus))

		local SearchCount = {
			condition = func.curry_only(search_shown),

			init = function(self)
				self.current = 0
				self.total = 0
				self.exceeded = false

				local maxcount = 99
				local ok, count = pcall(vim.fn.searchcount, { maxcount = maxcount, timeout = 500 })
				if ok and next(count) then
					self.current = count.current
					self.total = math.min(count.total, count.maxcount)
					self.exceeded = count.total == maxcount + 1
				end
			end,

			provider = function(self)
				if self.current > 0 or self.total > 0 then
					return string.format(' %d/%d', self.current, self.total) .. (self.exceeded and '+' or '')
				end
			end,

			hl = 'DiagnosticInfo',
		}

		local Git = {
			condition = h_conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
			end,

			hl = '@diff.delta',

			Bold {
				provider = function(self)
					local branch = tostring(self.status_dict.head)
					branch = branch:gsub('^users/[^/]+/', '')
					return ' ' .. branch
				end,
			},
			{
				provider = ' ',
				condition = function(self)
					return self.has_changes
				end,
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ('+' .. count)
				end,
				hl = '@diff.plus',
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ('-' .. count)
				end,
				hl = '@diff.minus',
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ('~' .. count)
				end,
				hl = '@diff.delta',
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
					return string.format('%s %d', self.icon, self.diagnostic_count)
				end,

				hl = opts.hl,
			}
		end

		local severity = vim.diagnostic.severity
		local ErrorCount = DiagnisticCounter { severity = severity.ERROR, fallback_icon = 'E', hl = 'DiagnosticError' }
		local WarningCount = DiagnisticCounter { severity = severity.WARN, fallback_icon = 'W', hl = 'DiagnosticWarn' }
		local InfoCount = DiagnisticCounter { severity = severity.INFO, fallback_icon = 'I', hl = 'DiagnosticInfo' }
		local HintCount = DiagnisticCounter { severity = severity.HINT, fallback_icon = 'H', hl = 'DiagnosticHint' }

		local is_leaping = signal.new(false)

		augroup:on_user('LeapEnter', func.curry(is_leaping, true))
		augroup:on_user('LeapLeave', func.curry(is_leaping, false))

		signal.on(is_leaping, function()
			vim.api.nvim_exec_autocmds('User', { pattern = 'HeirlineLeapUpdate' })
		end)

		local LeapMarker = Bold {
			update = { 'User', pattern = 'HeirlineLeapUpdate' },

			condition = func.curry_only(is_leaping),

			Text('󰤇 leap', { hl = '@diff.plus' }),
		}

		local TerminalList = {
			update = { 'TermOpen', 'TermClose', 'BufEnter' },

			condition = function()
				return (vim.g.status_terminal_count or 0) > 0
			end,

			provider = function()
				local current_terminal = vim.g.status_last_terminal_index or 0
				local terminal_count = vim.g.status_terminal_count or 0

				if vim.bo.buftype == 'terminal' then
					return string.format('%d/%d ', current_terminal, terminal_count)
				else
					return string.format('%d ', terminal_count)
				end
			end,

			hl = '@attribute',
		}

		local Ruler = {
			-- %l = current line number
			-- %L = number of lines in the buffer
			-- %c = column number
			-- %P = percentage through file of displayed window
			provider = '%04l/%04L:%04c',
			hl = '@comment',
		}

		local ScrollBar = {
			static = {
				chars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '▒' },
			},

			provider = function(self)
				local line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				if line == lines then
					return self.chars[#self.chars]
				end
				return self.chars[math.floor((line - 1) / lines * (#self.chars - 1)) + 1]
			end,

			hl = '@comment',
		}

		local LSPActive = {
			condition = h_conditions.lsp_attached,
			update = { 'LspAttach', 'LspDetach', 'BufEnter' },

			static = {
				client_icons = {
					biome = '',
					csharp_ls = '󰌛',
					cssls = '',
					eslint = '󰱺',
					graphql = '󰡷',
					jsonls = '',
					kotlin_language_server = '󱈙',
					lua_ls = '',
					omnisharp = '󰈸',
					pyright = '󰌠',
					svelte = '',
					tailwindcss = '󱏿',
					ts_ls = '',
					vimls = '',
				},
			},

			init = function(self)
				local client_names = array.map(vim.lsp.get_clients { bufnr = 0 }, function(client)
					local s = self.client_icons[client.name] or client.name
					s = s:gsub('_language_server$', ''):gsub('_ls$', '')
					return s
				end)

				self.active_clients = table.concat(client_names, ' ')
			end,

			hl = '@tag',

			provider = func.field 'active_clients',
		}

		local SpellFlag = {
			condition = function()
				return vim.wo.spell
			end,

			Text('󰸟', { hl = '@boolean' }),
		}

		local FormatBeforeWriteFlag = {
			condition = function()
				return vim.g.status_format_before_write
			end,

			Text('', { hl = '@boolean' }),
		}

		local InlayHintsFlag = {
			condition = function()
				return vim.lsp.inlay_hint.is_enabled()
			end,

			Text('', { hl = '@boolean' }),
		}

		local LeftStatusline = AppendAll(Space, 'right') {
			ViMode,
			ReadonlyFlag 'status',
			Git,
			ErrorCount,
			WarningCount,
			InfoCount,
			HintCount,
			ModifiedFlag 'status',
			MacroRec,
			SearchCount,
			LeapMarker,
		}

		local RightStatusline = AppendAll(Space, 'left') {
			TerminalList,
			InlayHintsFlag,
			SpellFlag,
			FormatBeforeWriteFlag,
			LSPActive,
			Ruler,
			ScrollBar,
		}

		heirline.setup {
			---@diagnostic disable-next-line: missing-fields
			statusline = {
				hl = 'StatusLine',
				LeftStatusline,
				Align,
				RightStatusline,
			},
			---@diagnostic disable-next-line: missing-fields
			tabline = {
				hl = 'TabLine',
				SidebarOffset,
				BufferLine,
				Align,
				Append(Space, 'left') { TabPageList },
			},
		}

		augroup:on('ColorScheme', '*', func.curry(h_util.on_colorscheme, {}))

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
		vim.cmd [[:au VimLeavePre * set tabline=]]
	end,
}
