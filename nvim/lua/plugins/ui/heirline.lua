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
		local conditions = require 'heirline.conditions'
		local h_util = require 'heirline.utils'
		local heirline = require 'heirline'
		local hl = require 'util.highlight'

		local augroup = autocmd.group 'heirline'

		hl.pick(augroup, 'StatusLineDiffDelta', { fg = '@diff.delta' })
		hl.pick(augroup, 'StatusLineDiffMinus', { fg = '@diff.minus' })
		hl.pick(augroup, 'StatusLineDiffPlus', { fg = '@diff.plus' })
		hl.pick(augroup, 'StatusLineError', { fg = 'DiagnosticError' })
		hl.pick(augroup, 'StatusLineFlag', { fg = '@boolean' })
		hl.pick(augroup, 'StatusLineHint', { fg = 'DiagnosticHint' })
		hl.pick(augroup, 'StatusLineInfo', { fg = 'DiagnosticInfo' })
		hl.pick(augroup, 'StatusLineLsp', { fg = '@tag' })
		hl.pick(augroup, 'StatusLineMacro', { fg = '@keyword' })
		hl.pick(augroup, 'StatusLineModified', { fg = '@diff.plus' })
		hl.pick(augroup, 'StatusLineNormal', { fg = 'Normal' })
		hl.pick(augroup, 'StatusLineWarn', { fg = 'DiagnosticWarn' })
		hl.pick(augroup, 'WinBarDirectory', { fg = 'Directory' })
		hl.pick(augroup, 'WinBarFile', { fg = 'Normal' })
		hl.pick(augroup, 'WinBarModified', { fg = '@diff.plus' })

		local Space = { provider = ' ', hl = { fg = 'NONE' } }

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

		local Cwd = {
			update = { 'BufEnter', 'DirChanged' },
			hl = 'WinBarDirectory',
			init = function(self)
				local is_focused = vim.bo.filetype == 'minifiles'
				local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
				local icon = is_focused and '' or ''
				self.provider = string.format('%s %s', icon, cwd)
			end,
		}

		local Buffer = {
			condition = function()
				return vim.bo.buftype == '' and vim.bo.buflisted
			end,

			init = function(self)
				self.is_on_disk = vim.fn.expand '%:p' ~= ''
				self.is_in_cwd = vim.fs.relpath(vim.fn.getcwd(), vim.fn.expand '%') ~= nil
				if self.is_on_disk then
					local dir_path = vim.fn.expand '%:~:.:h'
					self.dir = dir_path == '.' and '' or dir_path
					self.name = vim.fn.expand '%:~:.:t:r'
				else
					self.dir = ''
					self.name = string.format('[%d]', vim.fn.bufnr())
				end
			end,

			{
				hl = 'WinBarFile',
				init = function(self)
					if not self.is_on_disk then
						self.provider = ''
					elseif not self.is_in_cwd then
						self.provider = ''
					else
						self.provider = ''
					end
				end,
			},
			{
				hl = 'WinBarDirectory',
				provider = function(self)
					return string.format(' %s ', self.dir)
				end,
				condition = function(self)
					return #self.dir > 0
				end,
			},
			{
				hl = 'WinBarFile',
				provider = function(self)
					return ' ' .. self.name
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
					self.provider = ' ' .. (icon or '')
					self.hl = icon_hl
				end,
			},
			{
				provider = ' +',
				hl = 'WinBarModified',
				condition = function()
					return vim.bo.modified
				end,
			},
		}

		local Terminal = {
			condition = function()
				return vim.bo.buftype == 'terminal'
			end,

			provider = ' %{b:term_title}',
		}

		local TabPageList = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{ provider = '󰗚', hl = 'StatusLineModified' },
			h_util.make_tablist {
				provider = function(self)
					return string.format(' %d', self.tabnr)
				end,
				hl = function(self)
					return self.is_active and 'StatusLineModified' or nil
				end,
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
				mode_hls = {
					i = 'StatusLineModified',
					c = 'StatusLineInfo',
					R = 'StatusLineDiffDelta',
					r = 'StatusLineDiffDelta',
					['!'] = 'StatusLineDiffMinus',
					t = 'StatusLineWarn',
				},
			},

			{ provider = ' ', hl = 'StatusLineModified' },
			{
				provider = function(self)
					return self.mode_names[self.mode] or self.mode
				end,
				hl = function(self)
					return self.mode_hls[self.mode:sub(1, 1)] or 'StatusLineNormal'
				end,
			},

			update = {
				'ModeChanged',
				pattern = '*:*',
				callback = vim.schedule_wrap(func.cmd 'redrawstatus'),
			},
		}

		local MacroRec = {
			update = { 'RecordingEnter', 'RecordingLeave' },
			hl = 'StatusLineMacro',
			condition = function()
				return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
			end,
			provider = function()
				return string.format(' %s', vim.fn.reg_recording())
			end,
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

			hl = 'StatusLineInfo',
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
							hl = counter.hl,
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
					{ key = 'add', sign = '+', hl = 'StatusLineDiffPlus' },
					{ key = 'delete', sign = '-', hl = 'StatusLineDiffMinus' },
					{ key = 'change', sign = '~', hl = 'StatusLineDiffDelta' },
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
					{ severity = vim.diagnostic.severity.ERROR, hl = 'StatusLineError' },
					{ severity = vim.diagnostic.severity.WARN, hl = 'StatusLineWarn' },
					{ severity = vim.diagnostic.severity.INFO, hl = 'StatusLineInfo' },
					{ severity = vim.diagnostic.severity.HINT, hl = 'StatusLineHint' },
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

		local Location = {
			provider = '%04l/%04L:%04v',
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
			condition = conditions.lsp_attached,
			update = { 'LspAttach', 'LspDetach', 'BufEnter' },

			static = {
				client_icons = {
					bashls = '',
					biome = '',
					csharp_ls = '󰌛',
					cssls = '',
					eslint = '󰱺',
					gh_actions_ls = '',
					graphql = '󰡷',
					harper_ls = '',
					jsonls = '',
					kotlin_language_server = '󱈙',
					lua_ls = '',
					omnisharp = '󰈸',
					pyright = '󰌠',
					rust_analyzer = '',
					svelte = '',
					tailwindcss = '󱏿',
					ts_ls = '',
					vectorcode_server = '󰕣',
					vimls = '',
					vtsls = '',
				},

				skip_clients = { 'stylua' },
			},

			provider = function(self)
				return vim
					.iter(vim.lsp.get_clients { bufnr = 0 })
					:filter(function(client)
						return not vim.tbl_contains(self.skip_clients, client.name)
					end)
					:map(function(client)
						local name = (self.client_icons[client.name] or client.name):gsub('_language_server$', ''):gsub('_ls$', '')
						return name
					end)
					:join ' '
			end,

			hl = 'StatusLineLsp',
		}

		local WrapFlag = {
			provider = '󱞱',
			hl = 'StatusLineFlag',
			condition = function()
				return vim.wo.wrap
			end,
		}

		local SpellFlag = {
			provider = '󰸟',
			hl = 'StatusLineFlag',
			condition = function()
				return vim.wo.spell
			end,
		}

		local FormatBeforeWriteFlag = {
			provider = '',
			hl = 'StatusLineFlag',
			condition = function()
				return vim.bo.buftype == '' and vim.g.format_on_write
			end,
		}

		local LeftStatusline = AppendAll(Space, 'right') {
			TabPageList,
			Cwd,
			ViMode,
			DiffCounts,
			DiagnosticCounts,
			MacroRec,
			SearchCount,
		}

		local RightStatusline = AppendAll(Space, 'left') {
			WrapFlag,
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
			winbar = {
				hl = 'WinBar',
				fallthrough = false,
				Buffer,
				Terminal,
			},
			opts = {
				disable_winbar_cb = function(args)
					return conditions.buffer_matches({
						buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
						filetype = { '^git.*' },
					}, args.buf)
				end,
			},
		}

		augroup:on('ColorScheme', '*', func.partial(h_util.on_colorscheme, {}))

		-- https://github.com/rebelot/heirline.nvim/issues/203#issuecomment-2208395807
		vim.cmd [[:au VimLeavePre * set stl=]]
	end,
}
