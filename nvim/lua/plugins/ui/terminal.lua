return {
	'rebelot/terminal.nvim',

	enabled = true, -- TODO: replace toggleterm

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

		local function is_float_win()
			local winid = vim.api.nvim_get_current_win()
			local config = vim.api.nvim_win_get_config(winid)
			return not not config.zindex
		end

		local function toggle_terminal()
			if active_terminals:len() > 0 then
				terminal.toggle()
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
			local layout
			if current_term then
				layout = tbl.copy_deep(current_term.layout)
				vim.schedule(function()
					current_term:close()
				end)
			end

			terminal.run(shell_cmd, { layout = layout })
			vim.schedule(func.cmd 'startinsert')
		end

		local function close_float_term()
			if is_float_win() then
				terminal.toggle()
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

		autocmd.on_terminal_open(function(event)
			keymap.declare {
				[{ buffer = event.buf }] = {
					[{ 'n', nowait = true }] = {
						['<Esc>'] = { close_float_term, 'Close floating terminal' },

						['<C-t>'] = { new_terminal_tab, 'New terminal' },
						['<Tab>'] = { terminal_map.cycle_next, 'Cycle next terminal' },
						['<S-Tab>'] = { terminal_map.cycle_prev, 'Cycle next terminal' },

						['<A-h>'] = { terminal_map.move { open_cmd = 'topleft 40vnew' }, 'Move: left split' },
						['<A-j>'] = { terminal_map.move { open_cmd = 'bot new | resize 20' }, 'Move: bottom split' },
						['<A-k>'] = { terminal_map.move { open_cmd = 'top new | resize 20' }, 'Move: top split' },
						['<A-l>'] = { terminal_map.move { open_cmd = 'botright 40vnew' }, 'Move: right split' },
						['<A-f>'] = { terminal_map.move(float_layout), 'Move: float' },
					},
				},
			}
		end)
	end,
}
