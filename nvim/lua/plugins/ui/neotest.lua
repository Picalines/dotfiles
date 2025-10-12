return {
	'nvim-neotest/neotest',

	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
	},

	lazy = true,
	cmd = 'Neotest',

	opts = function()
		return {
			adapters = {
				require('plugins.ui.neotest-jest').neotest_adapter(),
				require('plugins.ui.neotest-vitest').neotest_adapter(),
			},

			status = {
				signs = true,
				virtual_text = false,
			},

			output = {
				open_on_run = false,
			},

			icons = {
				unknown = '',
				running = '',
				skipped = '',
				failed = '',
				passed = '󰄴',
			},

			highlights = {
				failed = 'DiagnosticSignError',
				passed = 'DiagnosticSignOk',
				running = 'DiagnosticSignInfo',
				skipped = 'DiagnosticSignWarn',
			},
		}
	end,

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'Unit: %s' }] = {
				['<LocalLeader>ur'] = {
					desc = 'run nearest',
					function()
						require('neotest').run.run()
					end,
				},

				['<LocalLeader>uR'] = {
					desc = 'run suite',
					function()
						require('neotest').run.run(vim.fn.expand '%')
					end,
				},

				['<LocalLeader>uc'] = {
					desc = 'cancel suite',
					function()
						require('neotest').run.stop(vim.fn.expand '%')
					end,
				},

				['<LocalLeader>uo'] = {
					desc = 'output',
					function()
						require('neotest').output_panel.open()
					end,
				},
			},
		}

		local augroup = autocmd.group 'neotest'

		augroup:on('BufWinEnter', 'Neotest Output Panel', function(event)
			local neotest = require 'neotest'
			local winid = vim.fn.bufwinid(event.buf)

			vim.wo[winid].winbar = ' output'
			vim.wo[winid].signcolumn = 'no'

			keymap {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.output_panel.close, 'Close panel' },
					['<LocalLeader>uo'] = { neotest.output_panel.close, 'Close panel' },
				},
			}

			vim.schedule(function()
				vim.api.nvim_set_current_win(winid)
			end)
		end)
	end,
}
