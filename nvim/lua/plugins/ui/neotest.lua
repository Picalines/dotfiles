local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Unit: %s' }] = {
		['<leader>ur'] = { "<Cmd>lua require('neotest').run.run()<CR>", 'run nearest' },
		['<leader>uR'] = { "<Cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", 'run suite' },
		['<leader>uc'] = { "<Cmd>lua require('neotest').run.stop(vim.fn.expand('%'))<CR>", 'cancel suite' },
		['<leader>uo'] = { "<Cmd>lua require('neotest').output_panel.open()<CR>", 'output' },
	},
}

return {
	'nvim-neotest/neotest',

	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
	},

	lazy = true,
	cmd = 'Neotest',

	config = function()
		local autocmd = require 'util.autocmd'
		local neotest = require 'neotest'

		---@diagnostic disable-next-line: missing-fields
		neotest.setup {
			adapters = {
				require('plugins.ui.neotest-jest').neotest_adapter(),
				require('plugins.ui.neotest-vitest').neotest_adapter(),
			},

			status = {
				enabled = true,
				signs = true,
				virtual_text = false,
			},

			output = {
				enabled = true,
				open_on_run = false,
			},

			---@diagnostic disable-next-line: missing-fields
			summary = {
				enabled = false,
			},

			icons = {
				unknown = '',
				running = '',
				skipped = '',
				failed = '',
				passed = '󰄴',
			},
		}

		local augroup = autocmd.group 'neotest'

		augroup:on('BufWinEnter', 'Neotest Output Panel', function(event)
			local winid = vim.fn.bufwinid(event.buf)

			vim.wo[winid].winbar = ' output'
			vim.wo[winid].signcolumn = 'no'

			keymap {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.output_panel.close, 'Close panel' },
					['<leader>uo'] = { neotest.output_panel.close, 'Close panel' },
				},
			}

			vim.schedule(function()
				vim.api.nvim_set_current_win(winid)
			end)
		end)
	end,
}
