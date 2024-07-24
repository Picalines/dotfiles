return {
	'nvim-telescope/telescope.nvim',

	event = 'VeryLazy',

	branch = '0.1.x',

	dependencies = {
		'nvim-lua/plenary.nvim',

		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.has 'win32' == 0
			end,
		},

		'nvim-telescope/telescope-ui-select.nvim',
	},

	config = function()
		local tbl = require 'util.table'
		local func = require 'util.func'
		local keymap = require 'util.keymap'
		local telescope = require 'telescope'
		local actions = require 'telescope.actions'
		local themes = require 'telescope.themes'
		local builtin = require 'telescope.builtin'

		telescope.setup {
			defaults = {
				file_ignore_patterns = {
					'node_modules',
				},

				mappings = {
					i = {
						['<C-n>'] = false,
						['<C-p>'] = false,

						['<C-k>'] = actions.move_selection_previous,
						['<C-j>'] = actions.move_selection_next,
					},
				},

				side_by_side = true,
				layout_strategy = 'vertical',
				layout_config = {
					vertical = {
						preview_height = 0.7,
					},
				},
			},

			extensions = {
				['ui-select'] = {
					themes.get_dropdown {},
				},
			},

			pickers = {
				find_files = {
					previewer = false,
				},

				oldfiles = {
					previewer = false,
				},
			},
		}

		local function safe_load_extension(name)
			pcall(telescope.load_extension, name)
		end

		safe_load_extension 'fzf'
		safe_load_extension 'ui-select'
		safe_load_extension 'noice'

		local ignore_files = { '.gitignore', '.arcignore' }
		local always_exclude = { '.git', 'node_modules', '{package,pnpm}-lock.json', '{dist,build}', '*.bundle.js', '.geodata' }

		local rg_args = tbl.join(
			{ '--hidden' },
			tbl.flat_map(ignore_files, function(file)
				return vim.fn.filereadable(file) and { '--ignore-file', file } or {}
			end),
			tbl.flat_map(always_exclude, function(path)
				return { '-g', '!' .. path }
			end)
		)

		local find_files = func.curry_opts(builtin.find_files, {
			find_command = tbl.join({ 'rg', '--files' }, rg_args),
		})

		local live_grep = func.curry_opts(builtin.live_grep, {
			additional_args = rg_args,
		})

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
			['<leader>ff'] = { find_files, '[F]ind [F]iles' },
			['<leader>fo'] = { builtin.oldfiles, '[F]ind [O]ld files' },
			['<leader>fb'] = { builtin.buffers, '[F]ind [B]uffer' },
			['<leader>fg'] = { live_grep, '[F]ind [G]lobal' },
			['<leader>fc'] = { builtin.commands, '[F]ind [C]ommands' },
			['<leader>fh'] = { builtin.help_tags, '[F]ind [H]elp' },
			['<leader>fd'] = { builtin.diagnostics, '[F]ind [D]iagnostics' },
			['<leader>fr'] = { builtin.resume, '[F]ind [R]esume' },
			['<leader>f/'] = { builtin.current_buffer_fuzzy_find, '[F]ind in current buffer' },
		}

		keymap.declare {
			n = picker_maps,

			v = tbl.map_pairs(picker_maps, function(lhs, rhs)
				local v_rhs = tbl.copy(rhs)
				v_rhs[1] = pick_visual(v_rhs[1])
				return lhs, v_rhs
			end),
		}
	end,
}
