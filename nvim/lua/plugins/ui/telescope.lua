local app = require 'util.app'

return {
	'nvim-telescope/telescope.nvim',

	event = 'VeryLazy',

	dependencies = {
		'nvim-lua/plenary.nvim',

		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return app.os() ~= 'windows'
			end,
		},

		'nvim-telescope/telescope-ui-select.nvim',
		'gbrlsnchs/telescope-lsp-handlers.nvim',
	},

	config = function()
		local array = require 'util.array'
		local tbl = require 'util.table'
		local keymap = require 'util.keymap'
		local telescope = require 'telescope'
		local actions = require 'telescope.actions'
		local themes = require 'telescope.themes'
		local builtin = require 'telescope.builtin'

		local ignore_files = { '.gitignore', '.arcignore' }
		local always_exclude = {
			'*.bundle.js',
			'*.cert',
			'*.tsbuildinfo',
			'.git',
			'node_modules',
			'{dist,build}',
			'{dist,build}-*',
			'{package,pnpm}-lock.json',
		}

		local rg_args = array.concat(
			{ '--hidden', '--max-filesize=1G' },
			array.flat_map(ignore_files, function(file)
				return vim.fn.filereadable(file) and { '--ignore-file', file } or {}
			end),
			array.flat_map(always_exclude, function(path)
				return { '-g', '!' .. path }
			end)
		)

		local rg_file_args = array.concat({ 'rg', '--files' }, rg_args)

		telescope.setup {
			defaults = {
				file_ignore_patterns = {
					'node_modules',
				},

				mappings = {
					i = {
						['<C-p>'] = false,

						['<C-n>'] = actions.move_selection_next,
						['<C-S-n>'] = actions.move_selection_previous,
						['<C-j>'] = actions.move_selection_next,
						['<C-k>'] = actions.move_selection_previous,
					},
				},

				side_by_side = true,
				layout_strategy = 'vertical',
				layout_config = {
					vertical = {
						preview_height = 0.7,
						prompt_position = 'top',
						mirror = true,
					},
				},

				sorting_strategy = 'ascending',
			},

			extensions = {
				['ui-select'] = {
					themes.get_dropdown {},
				},
			},

			pickers = {
				find_files = {
					previewer = false,
					find_command = rg_file_args,
				},

				live_grep = {
					additional_args = rg_args,
				},

				oldfiles = {
					previewer = false,
				},

				buffers = {
					previewer = false,
				},
			},
		}

		local function safe_load_extension(name)
			pcall(telescope.load_extension, name)
		end

		safe_load_extension 'fzf'
		safe_load_extension 'ui-select'
		safe_load_extension 'lsp_handlers'

		local function exit_visual_mode()
			vim.api.nvim_feedkeys(':', 'nx', false)
		end

		local function get_visual_text()
			local temp_reg = 't'
			local old_reg, old_reg_type = vim.fn.getreg(temp_reg), vim.fn.getregtype(temp_reg)
			exit_visual_mode()
			vim.cmd(':noau silent norm gv"' .. temp_reg .. 'y')
			local visual_text = vim.fn.getreg(temp_reg)
			vim.fn.setreg(temp_reg, old_reg, old_reg_type)
			return visual_text
		end

		local function pick_visual(picker)
			return function(opts)
				local text = vim.split(get_visual_text(), '\n')[1]
				return picker(tbl.override_deep({ default_text = text }, opts or {}))
			end
		end

		local picker_maps = {
			['<leader>ff'] = { builtin.find_files, 'Find files' },
			['<leader>fo'] = { builtin.oldfiles, 'Find old files' },
			['<leader>fb'] = { builtin.buffers, 'Find buffer' },
			['<leader>fg'] = { builtin.live_grep, 'Find global' },
			['<leader>fc'] = { builtin.commands, 'Find commands' },
			['<leader>fh'] = { builtin.help_tags, 'Find help' },
			['<leader>fd'] = { builtin.diagnostics, 'Find diagnostics' },
			['<leader>fr'] = { builtin.resume, 'Find resume' },
			['<leader>f/'] = { builtin.current_buffer_fuzzy_find, 'Find in current buffer' },
			['<leader>fs'] = { builtin.lsp_document_symbols, 'Find document symbols' },
			['<leader>fS'] = { builtin.lsp_dynamic_workspace_symbols, 'Find workspace symbols' },
		}

		keymap.declare {
			[{ 'n' }] = picker_maps,

			[{ 'n' }] = {
				['<leader>ft'] = { builtin.filetypes, 'Select filetypes' },
			},

			[{ 'x' }] = tbl.map(picker_maps, function(lhs, rhs)
				local v_rhs = array.copy(rhs)
				v_rhs[1] = pick_visual(v_rhs[1])
				return lhs, v_rhs
			end),
		}
	end,
}
