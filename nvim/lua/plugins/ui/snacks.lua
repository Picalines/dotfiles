local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

local augroup = autocmd.group 'snacks'

keymap {
	[{ 'n', desc = 'Buffer: %s' }] = {
		['<leader>bd'] = { "<Cmd>lua require('snacks').bufdelete()<CR>", 'delete' },
		['<leader>bD'] = { "<Cmd>lua require('snacks').bufdelete.all()<CR>", 'delete all' },
	},

	[{ 'n', desc = 'Find: %s' }] = {
		['gD'] = { '<Cmd>lua Snacks.picker.lsp_definitions()<CR>', 'lsp definitions' },
		['gR'] = { '<Cmd>lua Snacks.picker.lsp_references()<CR>', 'lsp references' },
		['gI'] = { '<Cmd>lua Snacks.picker.lsp_implementations()<CR>', 'lsp implementations' },
		['gT'] = { '<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>', 'lsp type definitions' },

		['<leader>bb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'buffer' },

		['<leader>ff'] = { '<Cmd>lua Snacks.picker.files()<CR>', 'files' },
		['<leader>fo'] = { '<Cmd>lua Snacks.picker.recent()<CR>', 'recent' },
		['<leader>fb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'buffer' },
		['<leader>fg'] = { '<Cmd>lua Snacks.picker.grep()<CR>', 'grep' },
		['<leader>fh'] = { '<Cmd>lua Snacks.picker.help()<CR>', 'help' },
		['<leader>fr'] = { '<Cmd>lua Snacks.picker.resume()<CR>', 'resume' },
		['<leader>ft'] = { ':set filetype=', 'filetype' },

		['<leader>uC'] = { '<Cmd>lua Snacks.picker.colorschemes()<CR>', 'colorscheme' },
	},

	[{ 'n', desc = 'Terminal: %s' }] = {
		['<leader>t'] = { '<Cmd>TerminalFocus<CR>', 'toggle' },
	},
}

augroup:on('TabLeave', '*', 'TerminalHide')

augroup:on('FileType', 'neo-tree', function(event)
	keymap {
		[{ 'n', buffer = event.buf, desc = 'Find: %s' }] = {
			['f'] = { '<leader>ff', 'files', remap = true },
		},
	}
end)

return {
	'folke/snacks.nvim',

	---@module 'snacks'
	---@type snacks.Config
	opts = {
		indent = {
			enabled = true,
			hl = 'Whitespace',
		},

		picker = {
			ui_select = true,
			layout = {
				preset = 'select',
				cycle = false,
				layout = { row = 2 },
			},
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

	init = function()
		local snacks = require 'snacks'

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
	end,
}
