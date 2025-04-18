return {
	'nvim-neotest/neotest',

	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
		'nvim-treesitter/nvim-treesitter',
	},

	event = 'LspAttach',

	config = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'
		local neotest = require 'neotest'

		keymap.declare {
			[{ 'n', desc = 'Unit: %s' }] = {
				['<leader>ur'] = { "<Cmd>lua require('neotest').run.run()<CR>", 'run nearest' },
				['<leader>uR'] = { "<Cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", 'run suite' },
				['<leader>uc'] = { "<Cmd>lua require('neotest').run.stop(vim.fn.expand('%'))<CR>", 'cancel suite' },
				['<leader>ul'] = { "<Cmd>lua require('neotest').summary.open()<CR>", 'list' },
				['<leader>uo'] = { "<Cmd>lua require('neotest').output_panel.open()<CR>", 'output' },
			},
		}

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
				enabled = true,
				follow = true,
				animated = false,
				---@diagnostic disable-next-line: missing-fields
				mappings = {
					expand = 'l',
					expand_all = 'L',
					output = 'o',
					jumpto = '<CR>',
					stop = 's',
					next_failed = ']f',
					prev_failed = '[f',
				},
			},

			icons = {
				unknown = '',
				running = '',
				skipped = '',
				failed = '',
				passed = '',
				watching = '',
			},

			highlights = {
				adapter_name = '@attribute',
				dir = 'Directory',
				namespace = 'Directory',
				file = 'Normal',
				expand_marker = 'NeotestIndent',
			},
		}

		local augroup = autocmd.group 'neotest'

		augroup:on('FileType', 'neotest-summary', function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.summary.close, 'Close panel' },
					['<leader>ul'] = { neotest.summary.close, 'Close panel' },
				},
			}
		end)

		augroup:on('FileType', 'neotest-output-panel', function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.output_panel.close, 'Close panel' },
					['<leader>uo'] = { neotest.output_panel.close, 'Close panel' },
				},
			}
		end)
	end,
}
