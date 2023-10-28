return {
	'nvim-telescope/telescope.nvim',

	branch = '0.1.x',

	dependencies = {
		'nvim-lua/plenary.nvim',

		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
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
				path_display = { 'truncate' },
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
		}

		pcall(telescope.load_extension, 'fzf')
		telescope.load_extension 'ui-select'

		local function map_key(key, func, desc)
			return vim.keymap.set('n', key, func, { desc = desc })
		end

		map_key('<leader>ff', builtin.find_files, '[F]ind [F]iles')
		map_key('<leader>fr', builtin.oldfiles, '[F]ind [R]ecent files')
		map_key('<leader>fb', builtin.buffers, '[F]ind [B]uffer')
		map_key('<leader>fg', builtin.git_files, '[F]ind [G]it [F]iles')
		map_key('<leader>fw', builtin.live_grep, '[F]ind [W]orkspace')
		map_key('<leader>fc', builtin.commands, '[F]ind [C]ommands')
		map_key('<leader>fh', builtin.help_tags, '[F]ind [H]elp')
		map_key('<leader>fd', builtin.diagnostics, '[F]ind [D]iagnostics')
		map_key('<leader>fR', builtin.resume, '[F]ind [R]esume')

		map_key('<leader>/', builtin.current_buffer_fuzzy_find, 'Find in current buffer')
	end,
}
