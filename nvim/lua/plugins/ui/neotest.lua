return {
	'nvim-neotest/neotest',

	event = 'LspAttach',

	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
		'nvim-treesitter/nvim-treesitter',

		'nvim-neotest/neotest-jest',
	},

	config = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'
		local neotest = require 'neotest'

		---@diagnostic disable-next-line: missing-fields
		neotest.setup {
			adapters = require 'settings.neotest.adapters',

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

		local function with_file_path(fn)
			return function(...)
				return fn(vim.fn.expand '%', ...)
			end
		end

		local function with_output_panel_clear(fn)
			return function(...)
				neotest.output_panel.clear()
				fn(...)
			end
		end

		keymap.declare {
			[{ 'n', desc = 'Test: %s' }] = {
				['<leader>ur'] = { with_output_panel_clear(neotest.run.run), 'run nearest' },
				['<leader>uR'] = { with_output_panel_clear(with_file_path(neotest.run.run)), 'run suite' },
				['<leader>uc'] = { neotest.run.stop, 'cancel nearest' },
				['<leader>uC'] = { with_file_path(neotest.run.stop), 'cancel suite' },
				['<leader>ul'] = { neotest.summary.toggle, 'list' },
				['<leader>uo'] = { neotest.output_panel.toggle, 'output' },
			},
		}

		local augroup = autocmd.group 'neotest'

		augroup:on_filetype('neotest-summary', function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.summary.close, 'Close panel' },
					['<leader>ul'] = { neotest.summary.close, 'Close panel' },
				},
			}
		end)

		augroup:on_filetype('neotest-output-panel', function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.output_panel.close, 'Close panel' },
					['<leader>uo'] = { neotest.output_panel.close, 'Close panel' },
				},
			}
		end)
	end,
}
