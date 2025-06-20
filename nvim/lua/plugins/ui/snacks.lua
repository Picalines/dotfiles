local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Buffer: %s' }] = {
		['<leader>bd'] = { "<Cmd>lua require('snacks').bufdelete()<CR>", 'delete' },
		['<leader>bD'] = { "<Cmd>lua require('snacks').bufdelete.all()<CR>", 'delete all' },
	},

	[{ 'n', desc = 'Terminal: %s' }] = {
		['<leader>t'] = { '<Cmd>TerminalFocus<CR>', 'toggle' },
	},
}

return {
	'folke/snacks.nvim',

	---@module 'snacks'
	---@type snacks.Config
	opts = {
		indent = {
			enabled = true,
			hl = 'Whitespace',
		},

		input = {
			enabled = true,
			icon_pos = 'title',
			icon = '󰙏',
			win = {
				relative = 'cursor',
				title_pos = 'left',
				row = 1,
			},
		},

		terminal = {
			enabled = true,
			win = {
				on_buf = vim.schedule_wrap(function(win)
					keymap {
						[{ buffer = win.buf, desc = 'Terminal: %s' }] = {
							[{ 'n' }] = {
								['<leader>t'] = { '<Cmd>TerminalHide<CR>', 'close' },
								['q'] = { '<Cmd>TerminalHide<CR>', 'close' },
								['o'] = { '<Cmd>TerminalNew<CR>', 'new' },
								['<C-d>'] = { 'i<C-d>', 'stop' },
								['<C-w>c'] = { 'i<C-d>', 'close' },
							},

							[{ 't' }] = {
								['<Esc>'] = { '<C-\\><C-n>', 'exit terminal' },
							},
						},
					}
				end),

				on_win = function(win)
					vim.wo[win.win].winbar = ' %{b:term_title}'
				end,
			},
		},
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'

		local snacks = require 'snacks'

		snacks.setup(opts)

		local function new_terminal()
			-- NOTE: snacks.terminal.open doesn't add it to terminals list
			local term = snacks.terminal.get(nil, {
				interactive = false,
				create = true,
				env = { __nvim_snacks_id = math.random() },
			})

			if term then
				term:focus()
			end
		end

		local function focus()
			local terms = snacks.terminal.list()
			for _, term in ipairs(terms) do
				if term.closed then
					term:toggle()
				end
			end

			if #terms > 0 then
				terms[1]:focus()
			else
				new_terminal()
			end
		end

		local function hide_all()
			local terms = snacks.terminal.list()
			for _, term in ipairs(terms) do
				if not term.closed then
					term:toggle()
				end
			end
		end

		vim.api.nvim_create_user_command('TerminalNew', new_terminal, {})
		vim.api.nvim_create_user_command('TerminalFocus', focus, {})
		vim.api.nvim_create_user_command('TerminalHide', hide_all, {})

		local augroup = autocmd.group 'snacks'

		augroup:on('TabLeave', '*', 'TerminalHide')
	end,
}
