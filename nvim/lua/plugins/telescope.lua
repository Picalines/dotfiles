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

		telescope.setup {
			defaults = {
				path_display = { 'truncate ' },
				file_ignore_patterns = {
					'node_modules',
				},
				mappings = {
					i = {
						['<C-k>'] = actions.move_selection_previous,
						['<C-j>'] = actions.move_selection_next,
						['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		}

		pcall(telescope.load_extension, 'fzf')
		telescope.load_extension 'ui-select'

		local function map_key(key, func, desc)
			return vim.keymap.set('n', key, func, { desc = desc })
		end

		local builtin = require 'telescope.builtin'

		-- See `:help telescope.builtin`
		map_key('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
		map_key('<leader><space>', builtin.buffers, '[ ] Find existing buffers')

		map_key('<leader>ff', builtin.find_files, '[S]earch [F]iles')
		map_key('<leader>fg', builtin.git_files, 'Search [G]it [F]iles')
		map_key('<leader>fw', builtin.live_grep, 'Search [W]orkspace')
		map_key('<leader>fc', builtin.commands, 'Search [C]ommands')
		map_key('<leader>fh', builtin.help_tags, '[S]earch [H]elp')
		map_key('<leader>fd', builtin.diagnostics, '[S]earch [D]iagnostics')
		map_key('<leader>fr', builtin.resume, '[S]earch [R]esume')

		map_key('<leader>/', function()
			local themes = require 'telescope.themes'
			builtin.current_buffer_fuzzy_find(themes.get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, '[/] Fuzzily search in current buffer')
	end,
}
