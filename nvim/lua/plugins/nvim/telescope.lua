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
		local util = require 'util'
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
		local always_exclude = { 'node_modules', 'package-lock.json', 'pnpm-lock.json' }

		local rg_picker_args = util.join(
			util.flat_map(ignore_files, function(file)
				return vim.fn.filereadable(file) and { '--ignore-file', file } or {}
			end),
			util.flat_map(always_exclude, function(path)
				return { '-g', '!' .. path }
			end)
		)

		local find_files = util.curry(builtin.find_files, {
			find_command = { 'rg', '--files', unpack(rg_picker_args) },
		})

		local live_grep = util.curry(builtin.live_grep, {
			additional_args = rg_picker_args,
		})

		require('util').declare_keymaps {
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
