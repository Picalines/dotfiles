return {
	'akinsho/toggleterm.nvim',

	keys = {
		{ '<leader>t', desc = 'Toggle Terminal' },
	},

	opts = {
		open_mapping = '<leader>t',
		insert_mappings = false,
		terminal_mappings = false,

		hide_numbers = true,
		shade_terminals = false,

		persist_mode = false,
		close_on_exit = true,

		direction = 'float',
		auto_scroll = true,

		float_opts = {
			border = 'rounded',
			title_pos = 'center',
		},

		shell = function()
			if vim.fn.has 'win32' == 1 then
				return 'powershell'
			end

			return vim.o.shell
		end,
	},

	config = function(_, opts)
		local util = require 'util'

		local toggleterm = require 'toggleterm'
		local toggleterm_ui = require 'toggleterm.ui'

		local terminals = require 'toggleterm.terminal'
		local Terminal = terminals.Terminal

		toggleterm.setup(opts)

		local function open_new_term()
			local current_term = terminals.get(terminals.get_focused_id())
			if current_term ~= nil then
				current_term:set_mode 'n'
			end

			vim.schedule(function()
				Terminal:new():open()
			end)
		end

		---@param dir 'next' | 'prev' | 'next_or_prev'
		local function open_next_term(dir)
			local current_term_id = terminals.get_focused_id()
			if current_term_id == nil then
				return
			end

			local all_terminals = terminals.get_all(false)
			local current_term_index, _ = util.find(all_terminals, function(t)
				return t.id == current_term_id
			end)

			local next_index
			if dir == 'next' then
				next_index = current_term_index + 1
			elseif dir == 'next_or_prev' and all_terminals[current_term_index + 1] ~= nil then
				next_index = current_term_index + 1
			else
				next_index = current_term_index - 1
			end

			local next_term = all_terminals[next_index]
			if next_term ~= nil then
				next_term:open()
				toggleterm_ui.stopinsert()
			end
		end

		local function send_sigterm_and_reopen()
			local current_term = terminals.get(terminals.get_focused_id())
			if current_term ~= nil then
				open_next_term 'next_or_prev'

				vim.fn.jobstop(current_term.job_id)
			end
		end

		local function send_keys(keys)
			local current_term = terminals.get(terminals.get_focused_id())
			if current_term ~= nil then
				current_term:send(keys)
			end
		end

		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = { 'term://*' },
			callback = function(event)
				util.declare_keymaps {
					opts = {
						silent = true,
						buffer = event.buf,
						remap = true,
						nowait = true,
					},

					n = {
						['<C-t>'] = { open_new_term, 'Open new [T]erminal session' },

						['<Esc>'] = { '<leader>t', 'Exit terminal' },
						['<C-c>'] = { send_sigterm_and_reopen, 'Send SIGTERM' },

						[']t'] = { util.curry(open_next_term, 'next'), 'Next [T]erminal' },
						['[t'] = { util.curry(open_next_term, 'prev'), 'Previous [T]erminal' },
					},

					t = {
						['<Esc>'] = { [[<C-\><C-n>]], 'Exit terminal mode' },
						['<C-[>'] = { util.curry(send_keys, ''), 'Send <Esc> to terminal' },
						['<C-p>'] = { [[<C-\><C-n>pi]], '[P]aste' },
					},
				}
			end,
		})
	end,
}
