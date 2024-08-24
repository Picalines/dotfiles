return {
	'nvim-neotest/neotest',

	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
		'nvim-treesitter/nvim-treesitter',

		'nvim-neotest/neotest-jest',
	},

	config = function()
		local array = require 'util.array'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local keymap = require 'util.keymap'
		local persist = require 'util.persist'

		local neotest = require 'neotest'

		local function make_jest_adapter()
			local jest_util = require 'neotest-jest.jest-util'

			---@type table<string, string>
			local config_file_lookup = persist.get_item('neotest.jest.configs', {})

			vim.api.nvim_create_user_command('NeotestJestConfigPaths', function(opts)
				opts.fargs = func.default_opts(opts.fargs, { 'show' })
				local action = opts.fargs[1]

				if action == 'show' then
					print(vim.inspect(config_file_lookup))
				elseif action == 'clear' then
					config_file_lookup = {}
				end

				persist.save_item('neotest.jest.configs', config_file_lookup)
			end, {
				nargs = '?',
				complete = function()
					return { 'show', 'clear' }
				end,
			})

			local adapter = require 'neotest-jest' {
				jestConfigFile = function(path)
					local root_config = jest_util.getJestConfig(path)
					if root_config then
						return root_config
					end

					path = vim.fn.fnamemodify(path, ':p')
					local cwd = vim.fn.getcwd()

					while #path >= #cwd and path ~= '.' do
						if config_file_lookup[path] then
							return config_file_lookup[path]
						end

						path = vim.fn.fnamemodify(path, ':h')
					end
				end,
				jestCommand = function()
					return jest_util.getJestCommand(vim.fn.expand '%:p:h')
				end,
				cwd = function()
					return vim.fn.getcwd()
				end,
			}

			local function prompt_config_path(on_selected)
				local telescope = require 'telescope.builtin'
				local actions = require 'telescope.actions'
				local state = require 'telescope.actions.state'

				telescope.find_files {
					attach_mappings = function(prompt_bufnr)
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selected = state.get_selected_entry()
							if selected and selected[1] then
								on_selected(selected[1])
							end
						end)
						return true
					end,
				}
			end

			local build_spec = adapter.build_spec
			adapter.build_spec = function(...)
				local spec = build_spec(...)

				local has_config = array.some(spec and spec.command or {}, function(arg)
					return vim.startswith(arg, '--config')
				end)

				if not has_config then
					-- NOTE: telescope glitches sometimes without the delay
					func.wait(100, function()
						prompt_config_path(vim.schedule_wrap(function(path)
							local lookup_key = vim.api.nvim_buf_get_name(0)
							lookup_key = lookup_key:gsub('tests/.*', 'tests')
							config_file_lookup[lookup_key] = path
							persist.save_item('neotest.jest.configs', config_file_lookup)
						end))
					end)

					spec.command = {}
				end

				return spec
			end

			return adapter
		end

		---@diagnostic disable-next-line: missing-fields
		neotest.setup {
			adapters = {
				make_jest_adapter(),
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
					jumpto = '<Cr>',
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

		local function run_file_tests()
			neotest.run.run(vim.fn.expand '%')
		end

		keymap.declare {
			[{ 'n' }] = {
				['<leader>tr'] = { neotest.run.run, 'Test: run nearest' },
				['<leader>tf'] = { run_file_tests, 'Test: run file' },
				['<leader>ts'] = { neotest.run.stop, 'Test: stop nearest' },
				['<leader>tl'] = { neotest.summary.toggle, 'Test: list' },
				['<leader>to'] = { neotest.output_panel.toggle, 'Test: output' },
			},
		}

		autocmd.per_filetype({ 'neotest-summary' }, function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.summary.close, 'Close panel' },
					['<leader>tl'] = { neotest.summary.close, 'Close panel' },
				},
			}
		end)

		autocmd.per_filetype({ 'neotest-output-panel' }, function(event)
			keymap.declare {
				[{ 'n', buffer = event.buf }] = {
					['q'] = { neotest.output_panel.close, 'Close panel' },
					['<leader>to'] = { neotest.output_panel.close, 'Close panel' },
				},
			}
		end)
	end,
}
