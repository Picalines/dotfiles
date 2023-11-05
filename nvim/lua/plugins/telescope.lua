return {
	'nvim-telescope/telescope.nvim',

	branch = '0.1.x',

	dependencies = {
		'nvim-lua/plenary.nvim',

		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
		},

		'nvim-telescope/telescope-ui-select.nvim',
	},

	config = function()
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
			},
		}

		telescope.load_extension 'fzf'
		telescope.load_extension 'ui-select'

		local function flat_map(tbl, func)
			return vim.tbl_flatten(vim.tbl_map(func, tbl))
		end

		local function rg_picker_args(ignore_files)
			return flat_map(ignore_files, function(file)
				return vim.fn.filereadable(file) and { '--ignore-file', file } or {}
			end)
		end

		local ignore_files = { '.gitignore', '.arcignore' }

		local function find_files(opts)
			opts = opts or {}
			opts.find_command = { 'rg', '--files', unpack(rg_picker_args(ignore_files)) }
			return builtin.find_files(opts)
		end

		local function live_grep(opts)
			opts = opts or {}
			opts.additional_args = rg_picker_args(ignore_files)
			return builtin.live_grep(opts)
		end

		require('keymaps.util').declare_keymaps {
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
