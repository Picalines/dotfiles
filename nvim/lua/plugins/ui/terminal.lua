return {
	'rebelot/terminal.nvim',

	event = 'VeryLazy',

	config = function()
		local app = require 'util.app'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local keymap = require 'util.keymap'
		local signal = require 'util.signal'
		local str = require 'util.string'
		local win = require 'util.window'

		local terminal = require 'terminal'
		local active_terminals = require 'terminal.active_terminals'
		local terminal_map = require 'terminal.mappings'

		local augroup = autocmd.group 'terminal'

		local shell_cmd = app.os() == 'windows' and 'powershell' or vim.o.shell

		terminal.setup {
			cmd = shell_cmd,
			autoclose = true,
		}

		local last_terminal_index

		augroup:on('BufEnter', 'term://*', function()
			last_terminal_index = terminal.current_term_index()
		end)

		local panel_height = signal.new(60)
		signal.persist(panel_height, 'plugin.terminal.panel_height')

		local term_layout = signal.derive(function()
			return { open_cmd = str.fmt('bot new | resize ', panel_height()) }
		end)

		local function toggle_terminal()
			local term_count = active_terminals:len()
			if term_count > 0 then
				if last_terminal_index and last_terminal_index > term_count then
					last_terminal_index = nil
				end

				terminal.open(last_terminal_index, term_layout())
			else
				terminal.run(shell_cmd, { layout = term_layout() })

				vim.schedule(func.cmd 'startinsert')
			end
		end

		local function new_terminal_tab()
			if vim.bo.buftype ~= 'terminal' then
				return
			end

			local current_term = terminal.get_current_term()
			if current_term then
				current_term:close()
				terminal.run(shell_cmd, { layout = term_layout() })
			end
		end

		local function kill_current_terminal()
			local term = terminal.get_current_term()
			if term then
				vim.fn.jobstop(term.jobid)
			end
		end

		local function go_to_file()
			return str.fmt('<C-w>c<Cmd>e ', vim.fn.expand '<cWORD>', '<CR>')
		end

		keymap.declare {
			[{ 'n' }] = {
				['<leader>t'] = { toggle_terminal, 'Toggle terminal' },
			},

			[{ 't' }] = {
				['<Esc>'] = { [[<C-\><C-n>]], 'Exit terminal mode' },
				['<C-p>'] = { [[<C-\><C-n>pi]], 'Paste' },
			},
		}

		augroup:on('TermOpen', '*', function(event)
			keymap.declare {
				[{ buffer = event.buf, nowait = true }] = {
					[{ 'n' }] = {
						['<leader>t'] = { terminal_map.close, 'Close terminal' },
						['q'] = { terminal_map.close, 'Close terminal' },

						['o'] = { new_terminal_tab, 'New terminal' },
						['}'] = { terminal_map.cycle_next, 'Cycle next terminal' },
						['{'] = { terminal_map.cycle_prev, 'Cycle prev terminal' },
						['<C-c>'] = { kill_current_terminal, 'Kill terminal process' },

						['<C-o>'] = { '<C-w>p', 'Jump back' },
						['<C-i>'] = '<Nop>',

						['gf'] = { go_to_file, 'Open file under cursor', expr = true },
					},

					[{ 't' }] = {
						['<C-}>'] = { terminal_map.cycle_next, 'Cycle next terminal' },
						['<C-{>'] = { terminal_map.cycle_prev, 'Cycle prev terminal' },
					},
				},
			}
		end)

		augroup:on({ 'TermOpen', 'BufEnter' }, 'term://*', function(event)
			local winid = vim.fn.bufwinid(event.buf)
			local opts = { win = winid, scope = 'local' }
			vim.api.nvim_set_option_value('number', false, opts)
			vim.api.nvim_set_option_value('relativenumber', false, opts)
			vim.api.nvim_set_option_value('signcolumn', 'no', opts)
		end)

		augroup:on_winresized(function(event)
			local buftype = vim.api.nvim_buf_get_option(event.buf, 'buftype')
			if buftype == 'terminal' and win.layout_type(event.win) == 'col' then
				panel_height(math.min(vim.api.nvim_win_get_height(event.win), vim.go.lines - 10))
			end
		end)
	end,
}
