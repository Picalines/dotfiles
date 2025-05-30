return {
	'nvim-neotest/neotest-jest',

	lazy = true,
	dependencies = { 'nvim-neotest/neotest' },

	neotest_adapter = function()
		local func = require 'util.func'
		local signal = require 'util.signal'
		local tbl = require 'util.table'

		local jest_util = require 'neotest-jest.jest-util'

		local config_file_lookup = signal.new {}
		signal.persist(config_file_lookup, 'plugin.neotest.jest.configs')

		---@type string[]
		local suites_without_config = {}

		---@param suite_path string
		---@return string | nil
		local function lookup_jest_config(suite_path)
			local root_config = jest_util.getJestConfig(suite_path)
			if root_config then
				return root_config
			end

			local current_path = suite_path
			local cwd = vim.fn.getcwd()

			while #current_path >= #cwd and current_path ~= '.' do
				local known_config = config_file_lookup()[current_path]
				if known_config then
					return known_config
				end
				current_path = vim.fn.fnamemodify(current_path, ':h')
			end

			return nil
		end

		local test_dir_names = {
			'__tests__',
			'tests',
			'__examples__',
		}

		---@param suite_path string
		local function decide_config_base_path(suite_path)
			for _, dir_name in ipairs(test_dir_names) do
				suite_path = suite_path:gsub(dir_name .. '/.*', dir_name)
			end
			return suite_path
		end

		local function save_jest_config_path(suite_path, config_path)
			local config_base_path = decide_config_base_path(suite_path)
			config_file_lookup(tbl.override(config_file_lookup(), {
				[config_base_path] = config_path,
			}))
		end

		local function prompt_config_path(suite_path, on_selected)
			local telescope = require 'telescope.builtin'
			local actions = require 'telescope.actions'
			local state = require 'telescope.actions.state'

			local suite_dir = vim.fn.fnamemodify(suite_path, ':h:t')
			local suite_name = vim.fn.fnamemodify(suite_path, ':t')

			telescope.find_files {
				prompt_title = string.format('Select Jest config for %s/%s suite', suite_dir, suite_name),

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

		local function ask_for_missing_configs()
			local _, suite_path

			while true do
				_, suite_path = next(suites_without_config)
				if not suite_path then
					return
				end

				if lookup_jest_config(suite_path) then
					table.remove(suites_without_config, 1)
				else
					break
				end
			end

			local function on_config_selected(config_path)
				save_jest_config_path(suite_path, config_path)
				ask_for_missing_configs()
			end

			-- NOTE: telescope glitches sometimes without the delay
			func.wait(100, function()
				prompt_config_path(suite_path, vim.schedule_wrap(on_config_selected))
			end)
		end

		local adapter = require 'neotest-jest' {
			jestConfigFile = function(path)
				local suite_path = vim.fn.fnamemodify(path, ':p'):gsub('/+$', '')
				local config_path = lookup_jest_config(suite_path)

				if not config_path then
					suites_without_config[#suites_without_config + 1] = suite_path
				end

				return config_path
			end,
			jestCommand = function(path)
				return jest_util.getJestCommand(vim.fn.fnamemodify(path, ':p:h'))
			end,
			cwd = function()
				return vim.fn.getcwd()
			end,
		}

		local build_spec = adapter.build_spec
		adapter.build_spec = function(args)
			suites_without_config = {}
			local spec = build_spec(args)

			if next(suites_without_config) then
				vim.schedule(ask_for_missing_configs)
				spec.command = {}
			end

			return spec
		end

		vim.api.nvim_create_user_command('NeotestJestConfigPaths', function(opts)
			opts.fargs = func.default_opts(opts.fargs, { 'show' })
			local action = opts.fargs[1]

			if action == 'show' then
				print(vim.inspect(config_file_lookup()))
			elseif action == 'clear' then
				config_file_lookup {}
			end
		end, {
			nargs = '?',
			complete = function()
				return { 'show', 'clear' }
			end,
		})

		return adapter
	end,
}
