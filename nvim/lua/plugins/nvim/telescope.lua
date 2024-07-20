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

				current_buffer_fuzzy_find = {
					side_by_side = true,
					layout_strategy = 'vertical',
					layout_config = {
						preview_height = 0.6,
					},
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

		local find_files = func.curry(builtin.find_files, {
			find_command = tbl.join({ 'rg', '--files' }, rg_args),
		})

		local live_grep = func.curry(builtin.live_grep, {
			additional_args = rg_args,
		})

		keymap.declare {
			n = {
				['<leader>ff'] = { find_files, '[F]ind [F]iles' },
				['<leader>fo'] = { builtin.oldfiles, '[F]ind [O]ld files' },
				['<leader>fb'] = { builtin.buffers, '[F]ind [B]uffer' },
				['<leader>fg'] = { live_grep, '[F]ind [W]orkspace' },
				['<leader>fc'] = { builtin.commands, '[F]ind [C]ommands' },
				['<leader>fh'] = { builtin.help_tags, '[F]ind [H]elp' },
				['<leader>fd'] = { builtin.diagnostics, '[F]ind [D]iagnostics' },
				['<leader>fr'] = { builtin.resume, '[F]ind [R]esume' },
				['<leader>f/'] = { builtin.current_buffer_fuzzy_find, 'Find in current buffer' },
			},
		}
	end,
}
