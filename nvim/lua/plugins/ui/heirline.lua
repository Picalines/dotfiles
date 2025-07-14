return {
	'rebelot/heirline.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'VeryLazy',

	config = function()
		local app = require 'util.app'
		local autocmd = require 'util.autocmd'
		local devicons = require 'nvim-web-devicons'
		local func = require 'util.func'
		local h_conditions = require 'heirline.conditions'
		local h_util = require 'heirline.utils'
		local heirline = require 'heirline'
		local hl = require 'util.highlight'

		local augroup = autocmd.group 'heirline'

		local Space = { provider = ' ', hl = { fg = 'NONE' } }

		local function hl_fg(hl_name)
			return function(...)
				local hl_name_str = type(hl_name) == 'function' and hl_name(...) or hl_name
				return { fg = hl.attr(hl_name_str, 'fg') }
			end
		end

		---@param decorate fun(c: table): table
		local function Decorated(decorate)
			---@param component table
			return function(component)
				local condition = component.condition or function()
					return true
				end

				local update = component.update

				component = vim.deepcopy(component)
				component.condition = nil
				component.update = nil

				return {
					condition = condition,
					update = update,
					decorate(component),
				}
			end
		end

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
				return vim.iter(components):map(appender):totable()
			end
		end

		local BufferIcon = {
			init = function(self)
				self.icon, self.hl = devicons.get_icon(vim.fn.fnamemodify(self.filename, ':t'))
				self.icon = self.icon or ''
			end,
			provider = function(self)
				return self.icon
			end,
			hl = function(self)
				return self.hl
			end,
		}

		local BufferName = {
			init = function(self)
				self.display_name = self.filename == '' and string.format('[%d]', self.bufnr) or vim.fn.fnamemodify(self.filename, ':t:r')
			end,

			hl = function(self)
				return self.is_active and 'Normal' or 'NormalMuted'
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
				provider = function(self)
					return self.display_name
				end,
			},
		}

		local BufferModifiedFlag = {
			provider = '+',
			hl = hl_fg '@diff.plus',
			condition = function(self)
				return vim.bo[self.bufnr].modified
			end,
		}

		local BufferReadonlyFlag = {
			provider = '',
			hl = 'NormalMuted',
			condition = function(self)
				local bo = vim.bo[self.bufnr]
				return not bo.modifiable or bo.readonly
			end,
		}

		local Buffer = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,

			on_click = {
				minwid = function(self)
					return self.bufnr
				end,
				name = 'heirline_tabline_buffer_callback',
				callback = function(_, minwid)
					vim.api.nvim_win_set_buf(0, minwid)
				end,
			},

			AppendAll(Space, 'right') {
				BufferIcon,
				BufferName,
				BufferModifiedFlag,
				BufferReadonlyFlag,
			},
		}

		local function get_listed_buffers()
			return vim
				.iter(vim.api.nvim_list_bufs())
				:filter(function(bufnr)
					return vim.bo[bufnr].buflisted
				end)
				:totable()
		end

		local function compute_unique_prefixes(bufnrs)
			-- "inspiration": https://github.com/willothy/nvim-cokeline/blob/adfd1eb87e0804b6b86126e03611db6f62bb2909/lua/cokeline/buffers.lua#L57

			local is_windows = app.os() == 'windows'
			local path_separator = not is_windows and '/' or '\\'

			local prefixes = vim
				.iter(function()
					return {}
				end)
				:take(#bufnrs)
				:totable()

			local paths = vim
				.iter(bufnrs)
				:map(function(bufnr)
					return vim.fn.reverse(vim.split(vim.api.nvim_buf_get_name(bufnr), path_separator))
				end)
				:totable()

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

			return vim
				.iter(prefixes)
				:map(function(path)
					return table.concat(vim.fn.reverse(path), '/')
				end)
				:totable()
		end

		local buflist_cache = {}

		local function update_buflist()
			buflist_cache = get_listed_buffers()

			local name_to_bufnrs = vim.iter(buflist_cache):fold({}, function(acc, bufnr)
				local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
				acc[name] = vim.list_extend(acc[name] or {}, { bufnr })
				return acc
			end)

			local buffer_prefixes = {}
			for bufname, bufnrs in pairs(name_to_bufnrs) do
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

		local BufferLine = h_util.make_buflist(Buffer, { provider = ' ', hl = 'NormalMuted' }, { provider = '', hl = 'NormalMuted' }, function()
			return buflist_cache
		end, false)

		local TabPage = {
			provider = function(self)
				local title = vim.fn.fnamemodify(vim.fn.getcwd(-1, self.tabnr), ':t')
				return string.format(' %%%dT%s%%T', self.tabnr, title)
			end,

			hl = function(self)
				return self.is_active and 'Normal' or 'NormalMuted'
			end,
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{
				{ provider = '', hl = 'NormalMuted' },
				h_util.make_tablist(TabPage),
			},
		}

		local Cwd = {
			init = function(self)
				local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
				self.title = string.format(' %s', cwd)
				self.is_focused = vim.bo.filetype == 'neo-tree'
			end,
			provider = function(self)
				return self.title
			end,
			hl = function(self)
				return self.is_focused and 'Directory' or 'NormalMuted'
			end,
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
					i = '@diff.plus',
					v = 'NormalMuted',
					V = 'NormalMuted',
					['\22'] = 'NormalMuted',
					c = 'DiagnosticInfo',
					s = 'NormalMuted',
					S = 'NormalMuted',
					['\19'] = 'NormalMuted',
					R = '@diff.delta',
					r = '@diff.delta',
					['!'] = '@diff.minus',
					t = 'DiagnosticWarn',
				},
			},

			{ provider = '', hl = hl_fg '@diff.plus' },

			AppendAll(Space, 'left') {
				{
					provider = '',
					hl = 'DiagnosticWarn',
					condition = function()
						return #vim.fn.state 'o' > 0
					end,
				},
				{
					provider = function(self)
						return self.mode_names[self.mode] or self.mode
					end,
					hl = hl_fg(function(self)
						return self.mode_hls[self.mode:sub(1, 1)] or 'Normal'
					end),
				},
			},

			update = {
				'ModeChanged',
				pattern = '*:*',
				callback = vim.schedule_wrap(func.cmd 'redrawstatus'),
			},
		}

		local MacroRec = {
			condition = function()
				return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
			end,

			hl = '@keyword',

			provider = function()
				return ' ' .. vim.fn.reg_recording()
			end,

			update = { 'RecordingEnter', 'RecordingLeave' },
		}

		local search_shown = false

		augroup:on('CmdlineEnter', { '/', '?' }, function()
			search_shown = true
		end)

		augroup:on_user('Dismiss', function()
			search_shown = false
			vim.cmd.redrawstatus()
		end)

		local SearchCount = {
			condition = function()
				return search_shown
			end,

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

		local GitBranch = {
			hl = hl_fg '@diff.delta',
			condition = function()
				return vim.b.gitsigns_status_dict
			end,
			provider = function()
				return ' ' .. tostring(vim.b.gitsigns_status_dict.head):gsub('^users/[^/]+/', '')
			end,
		}

		---@class line_counter
		---@field count fun(): integer
		---@field icon string
		---@field hl string

		---@param update? string[]
		---@param counters line_counter[]
		local function Counters(update, counters)
			return {
				update = update,
				condition = function()
					return vim.iter(counters):any(function(counter)
						return counter.count() > 0
					end)
				end,

				vim
					.iter(counters)
					:map(function(counter)
						return {
							hl = hl_fg(counter.hl),
							update = update,
							condition = function()
								return counter.count() > 0
							end,
							provider = function()
								return counter.icon .. counter.count()
							end,
						}
					end)
					:totable(),
			}
		end

		local DiffCounts = Counters(
			nil,
			vim
				.iter({
					{ key = 'add', sign = '+', hl = '@diff.plus' },
					{ key = 'delete', sign = '-', hl = '@diff.minus' },
					{ key = 'change', sign = '~', hl = '@diff.delta' },
				})
				:map(function(count)
					return {
						hl = count.hl,
						icon = count.sign,
						count = function()
							return vim.b.minidiff_summary and vim.b.minidiff_summary[count.key] or 0
						end,
					}
				end)
				:totable()
		)

		local DiagnosticCounts = Counters(
			{ 'DiagnosticChanged', 'BufEnter' },
			vim
				.iter({
					{ severity = vim.diagnostic.severity.ERROR, hl = 'DiagnosticError' },
					{ severity = vim.diagnostic.severity.WARN, hl = 'DiagnosticWarn' },
					{ severity = vim.diagnostic.severity.INFO, hl = 'DiagnosticInfo' },
					{ severity = vim.diagnostic.severity.HINT, hl = 'DiagnosticHint' },
				})
				:map(function(count)
					return {
						hl = count.hl,
						icon = vim.diagnostic.config().signs.text[count.severity],
						count = function()
							return #vim.diagnostic.get(0, { severity = count.severity })
						end,
					}
				end)
				:totable()
		)

		local StatusModifiedFlag = {
			provider = '+',
			hl = hl_fg '@diff.plus',
			condition = function()
				return vim.bo.buftype ~= 'prompt' and vim.bo.modified
			end,
		}

		local StatusReadonlyFlag = {
			provider = '',
			hl = 'NormalMuted',
			condition = function()
				return vim.bo.buftype ~= 'terminal' and (not vim.bo.modifiable or vim.bo.readonly)
			end,
		}

		local is_leaping = false
		augroup:on_user({ 'LeapEnter', 'LeapLeave' }, function(event)
			is_leaping = event.match == 'LeapEnter'
		end)

		local LeapMarker = {
			update = { 'User', pattern = { 'LeapEnter', 'LeapLeave' } },
			{ provider = '󰤇 leap', hl = hl_fg '@diff.plus' },
			condition = function()
				return is_leaping
			end,
		}

		local TerminalList = {
			condition = function(self)
				self.terminal_count = #require('snacks').terminal.list()
				return self.terminal_count > 0
			end,

			provider = function(self)
				return string.format('%d ', self.terminal_count)
			end,

			hl = 'DevIconTerminal',
		}

		local Location = {
			provider = '%04l/%04L:%04c',
			hl = 'NormalMuted',
		}

		local ScrollProgress = {
			hl = 'NormalMuted',
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
		}

		local LSPActive = {
			condition = h_conditions.lsp_attached,
			update = { 'LspAttach', 'LspDetach', 'BufEnter' },

			static = {
				client_icons = {
					biome = '',
					csharp_ls = '󰌛',
					cssls = '',
					eslint = '󰱺',
					graphql = '󰡷',
					harper_ls = '',
					jsonls = '',
					kotlin_language_server = '󱈙',
					lua_ls = '',
					omnisharp = '󰈸',
					pyright = '󰌠',
					svelte = '',
					tailwindcss = '󱏿',
					ts_ls = '',
					vimls = '',
					vtsls = '',
				},
			},

			provider = function(self)
				return vim
					.iter(vim.lsp.get_clients { bufnr = 0 })
					:map(function(client)
						local name = (self.client_icons[client.name] or client.name):gsub('_language_server$', ''):gsub('_ls$', '')
						return name
					end)
					:join ' '
			end,

			hl = '@tag',
		}

		local SpellFlag = {
			{ provider = '󰸟', hl = '@boolean' },
			condition = function()
				return vim.wo.spell
			end,
		}

		local FormatBeforeWriteFlag = {
			{ provider = '', hl = '@boolean' },
			condition = function()
				return vim.g.format_on_write
			end,
		}

		local LeftStatusline = AppendAll(Space, 'right') {
			ViMode,
			GitBranch,
			DiffCounts,
			DiagnosticCounts,
			StatusModifiedFlag,
			StatusReadonlyFlag,
			MacroRec,
			SearchCount,
			LeapMarker,
		}

		local RightStatusline = AppendAll(Space, 'left') {
			TerminalList,
			SpellFlag,
			FormatBeforeWriteFlag,
			LSPActive,
			Location,
			ScrollProgress,
		}

		local Align = { provider = '%=', hl = { fg = 'NONE' } }

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
				Cwd,
				Space,
				BufferLine,
				Align,
				Append(Space, 'left') { TabPageList },
			},
		}

		augroup:on('ColorScheme', '*', func.partial(h_util.on_colorscheme, {}))

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
		vim.cmd [[:au VimLeavePre * set tabline=]]
	end,
}
