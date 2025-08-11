return {
	'rebelot/heirline.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
		{ 'tiagovla/scope.nvim', opts = {} },
	},

	event = 'VeryLazy',

	config = function()
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
				local hl_name_r = func.value(hl_name, ...)
				return hl_name_r and { fg = hl.attr(hl_name_r, 'fg') } or nil
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

		local Buffer = {
			update = { 'BufEnter', 'DirChanged', 'FileType' },

			condition = function()
				return vim.bo.buflisted
			end,

			init = function(self)
				self.is_on_disk = vim.fn.expand '%:p' ~= ''
				if vim.bo.buftype == '' and self.is_on_disk then
					local dir_path = vim.fn.expand '%:~:.:h'
					self.dir = dir_path == '.' and '' or dir_path
					self.name = vim.fn.expand '%:~:.:t:r'
				else
					self.dir = ''
					self.name = string.format('[%d]', vim.fn.bufnr())
				end
			end,

			AppendAll(Space, 'left') {
				{ provider = '', hl = 'Directory' },
				{
					hl = 'Directory',
					provider = function(self)
						return string.format('%s ', self.dir)
					end,
					condition = function(self)
						return #self.dir > 0
					end,
				},
				{
					provider = function(self)
						return self.name
					end,
				},
				{
					init = function(self)
						local icon, icon_hl
						if self.is_on_disk then
							icon, icon_hl = devicons.get_icon(vim.fn.expand '%:.:t')
						else
							icon, icon_hl = devicons.get_icon_by_filetype(vim.bo.filetype)
						end
						self.provider = icon or ''
						self.hl = icon_hl
					end,
				},
			},
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			h_util.make_tablist {
				provider = function(self)
					if self.is_active then
						return ' 󰨐'
					end
					local title = vim.fn.fnamemodify(vim.fn.getcwd(-1, self.tabnr), ':t')
					return string.format(' %%%dT%s%%T', self.tabnr, title)
				end,
				hl = function(self)
					return self.is_active and 'Directory' or nil
				end,
			},
		}

		local Cwd = {
			update = { 'BufEnter', 'DirChanged' },
			init = function(self)
				local is_focused = vim.bo.filetype == 'neo-tree'
				local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
				local icon = is_focused and '' or ''
				self.provider = string.format('%s %s', icon, cwd)
			end,
			hl = 'Directory',
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
					c = 'DiagnosticInfo',
					R = '@diff.delta',
					r = '@diff.delta',
					['!'] = '@diff.minus',
					t = 'DiagnosticWarn',
				},
			},

			{ provider = ' ', hl = hl_fg '@diff.plus' },
			{
				provider = function(self)
					return self.mode_names[self.mode] or self.mode
				end,
				hl = hl_fg(function(self)
					return self.mode_hls[self.mode:sub(1, 1)]
				end),
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

		local Location = {
			provider = '%04l/%04L:%04c',
		}

		local ScrollProgress = {
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
			provider = '󰸟',
			hl = '@boolean',
			condition = function()
				return vim.wo.spell
			end,
		}

		local FormatBeforeWriteFlag = {
			provider = '',
			hl = '@boolean',
			condition = function()
				return vim.g.format_on_write
			end,
		}

		local LeftStatusline = AppendAll(Space, 'right') {
			ViMode,
			DiffCounts,
			DiagnosticCounts,
			StatusModifiedFlag,
			MacroRec,
			SearchCount,
		}

		local RightStatusline = AppendAll(Space, 'left') {
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
				Buffer,
				Align,
				TabPageList,
			},
		}

		augroup:on('ColorScheme', '*', func.partial(h_util.on_colorscheme, {}))

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
		vim.cmd [[:au VimLeavePre * set tabline=]]
	end,
}
