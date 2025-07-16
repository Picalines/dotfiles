local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Terminal: %s' }] = {
		['<leader>t'] = { '<Cmd>TermFocus<CR>', 'toggle' },

		[']t'] = { '<Cmd>TermCycleNext<CR>', 'next' },
		['[t'] = { '<Cmd>TermCyclePrev<CR>', 'prev' },
	},
}

local keys_augroup = autocmd.group 'terminal.keys'

keys_augroup:on('TabLeave', '*', 'TermClose')

keys_augroup:on('TermOpen', 'term://*', function(event)
	keymap {
		[{ 'n', buffer = event.buf, desc = 'Terminal: %s' }] = {
			['<leader>t'] = { '<Cmd>q | wincmd p<CR>', 'close' },
			['q'] = { '<Cmd>q | wincmd p<CR>', 'close' },

			['o'] = { '<Cmd>TermNewTab<CR>', 'new tab' },

			['gf'] = {
				desc = 'go to file',
				expr = true,
				function()
					local cfile = vim.fn.findfile(vim.fn.expand '<cfile>', '**')
					if cfile == '' then
						return "<Cmd>echo 'no file'<CR>"
					end
					return string.format('<Cmd>q | wincmd p | e %s<CR>', cfile)
				end,
			},
		},
	}
end)

return {
	'rebelot/terminal.nvim',

	lazy = true,
	cmd = { 'TermFocus', 'TermClose', 'TermCycleNext', 'TermCyclePrev' },

	config = function()
		local opt = require 'util.options'

		local terminal = require 'terminal'
		local active_terminals = require 'terminal.active_terminals'
		local terminal_map = require 'terminal.mappings'

		terminal.setup { autoclose = true }

		local term_augroup = autocmd.group 'terminal.plugin'

		term_augroup:on({ 'TermOpen', 'TermClose', 'BufWinEnter' }, 'term://*', function()
			vim.g.term_index = terminal.current_term_index()
			vim.g.term_count = active_terminals:len()
		end)

		term_augroup:on('TermOpen', 'term://*', function(event)
			local _, wo = opt.buflocal(event.buf)
			wo.number = false
			wo.relativenumber = false
			wo.signcolumn = 'no'
			wo.winbar = ' %{g:term_index}/%{g:term_count} %{b:term_title}'
		end)

		local function term_layout()
			return { open_cmd = 'bot new | resize ' .. math.floor(vim.go.lines / 3) }
		end

		local function term_focus()
			local term_count = active_terminals:len()
			if term_count > 0 then
				terminal.open(vim.g.term_index, term_layout())
			else
				terminal.run(vim.go.shell, { layout = term_layout() })
				vim.schedule(vim.cmd.startinsert)
			end
		end

		local function term_new_tab()
			local current_term = terminal.get_current_term()
			if current_term then
				current_term:close()
				terminal.run(vim.go.shell, { layout = term_layout() })
			end
		end

		vim.api.nvim_create_user_command('TermFocus', term_focus, {})
		vim.api.nvim_create_user_command('TermNewTab', term_new_tab, {})
		vim.api.nvim_create_user_command('TermCycleNext', terminal_map.cycle_next, {})
		vim.api.nvim_create_user_command('TermCyclePrev', terminal_map.cycle_prev, {})
	end,
}
