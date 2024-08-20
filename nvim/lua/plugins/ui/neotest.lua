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
		local keymap = require 'util.keymap'

		local neotest = require 'neotest'

		local function make_jest_adapter()
			local jest_util = require 'neotest-jest.jest-util'

			local config_file_lookup = {}

			local adapter = require 'neotest-jest' {
				jestConfigFile = function()
					local path = vim.fn.expand '%:p:h'
					local root_config = jest_util.getJestConfig(path)
					if root_config then
						return root_config
					end

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

				vim.schedule(function()
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
				end)
			end

			local build_spec = adapter.build_spec
			adapter.build_spec = function(...)
				local spec = build_spec(...)

				local has_config = array.some(spec and spec.command or {}, function(arg)
					return vim.startswith(arg, '--config')
				end)

				if not has_config then
					prompt_config_path(vim.schedule_wrap(function(path)
						local lookup_key = vim.api.nvim_buf_get_name(0)
						lookup_key = lookup_key:gsub('tests/.*', 'tests')
						config_file_lookup[lookup_key] = path
					end))
					return nil
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
		}

		local function run_file_tests()
			neotest.run.run(vim.fn.expand '%')
		end

		keymap.declare {
			[{ 'n' }] = {
				['<leader>tr'] = { neotest.run.run, 'Test: run nearest' },
				['<leader>tf'] = { run_file_tests, 'Test: run file' },
				['<leader>ts'] = { neotest.run.stop, 'Test: stop nearest' },
				['<leader>to'] = { neotest.output.open, 'Test: output' },
			},
		}
	end,
}
