return {
	'rebelot/terminal.nvim',

	event = 'VeryLazy',

	config = function()
		local app = require 'util.app'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local keymap = require 'util.keymap'
		local tbl = require 'util.table'

		local terminal = require 'terminal'
		local active_terminals = require 'terminal.active_terminals'
		local terminal_map = require 'terminal.mappings'

		local shell_cmd = app.os() == 'windows' and 'powershell' or vim.o.shell

		local float_layout = {
			open_cmd = 'float',
			width = 0.9,
			height = 0.9,
			border = 'rounded',
		}

		terminal.setup {
			layout = float_layout,
			cmd = shell_cmd,
			autoclose = true,
		}

		local last_terminal_index

		autocmd.on('BufEnter', 'term://*', function()
			last_terminal_index = terminal.current_term_index()
		end)

		local function toggle_terminal()
			local term_count = active_terminals:len()
			if term_count > 0 then
				if last_terminal_index and last_terminal_index > term_count then
					last_terminal_index = nil
				end

				terminal.toggle(last_terminal_index, float_layout)
			else
				terminal.run(shell_cmd)
				vim.schedule(func.cmd 'startinsert')
			end
		end

		local function new_terminal_tab()
			if vim.bo.buftype ~= 'terminal' then
				return
			end

			local current_term = terminal.get_current_term()
			if current_term then
				local layout = tbl.copy_deep(current_term.layout)

				current_term:close()
				terminal.run(shell_cmd, { layout = layout })
			end
		end

		local function kill_current_terminal()
			local term = terminal.get_current_term()
			if term then
				vim.fn.jobstop(term.jobid)
			end
		end

		keymap.declare {
			[{ 'n' }] = {
				['<leader>t'] = { toggle_terminal, 'Toggle terminal' },
			},

			[{ 't' }] = {
				['<C-t>'] = { new_terminal_tab, 'New terminal' },
				['<C-Tab>'] = { terminal_map.cycle_next, 'Cycle next terminal' },
				['<Esc>'] = { [[<C-\><C-n>]], 'Exit terminal mode' },
				['<C-p>'] = { [[<C-\><C-n>pi]], 'Paste' },
			},
		}

		autocmd.on('TermOpen', '*', function(event)
			keymap.declare {
				[{ 'n', nowait = true, buffer = event.buf }] = {
					['<Esc>'] = { terminal_map.toggle, 'Close floating terminal' },
					['q'] = { terminal_map.toggle, 'Close floating terminal' },

					['<C-t>'] = { new_terminal_tab, 'New terminal' },
					['<C-c>'] = { kill_current_terminal, 'Kill terminal process' },
					['<Tab>'] = { terminal_map.cycle_next, 'Cycle next terminal' },
					['<S-Tab>'] = { terminal_map.cycle_prev, 'Cycle next terminal' },

					['<A-h>'] = { terminal_map.move { open_cmd = 'exe "topleft " . (&columns/4) . "vnew"' }, 'Move: left split' },
					['<A-j>'] = { terminal_map.move { open_cmd = 'bot new | exe "resize " . (&lines/4)' }, 'Move: bottom split' },
					['<A-k>'] = { terminal_map.move { open_cmd = 'top new | exe "resize " . (&lines/4)' }, 'Move: top split' },
					['<A-l>'] = { terminal_map.move { open_cmd = 'exe "botright " . (&columns/4) . "vnew"' }, 'Move: right split' },
					['<A-f>'] = { terminal_map.move(float_layout), 'Move: float' },
				},
			}
		end)

		autocmd.on({ 'TermOpen', 'BufEnter' }, 'term://*', function(event)
			local win = vim.fn.bufwinid(event.buf)
			if win == -1 then
				return
			end

			vim.api.nvim_set_option_value('number', false, { win = win, scope = 'local' })
			vim.api.nvim_set_option_value('relativenumber', false, { win = win, scope = 'local' })
			vim.api.nvim_set_option_value('signcolumn', 'no', { win = win, scope = 'local' })
		end)
	end,
}
