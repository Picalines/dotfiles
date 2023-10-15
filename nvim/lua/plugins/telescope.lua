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
	},

	config = function()
		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
			},
		}

		-- Enable telescope fzf native, if installed
		pcall(require('telescope').load_extension, 'fzf')

		local function map_key(key, func, desc)
			return vim.keymap.set('n', key, func, { desc = desc })
		end

		local builtin = require('telescope.builtin')

		-- See `:help telescope.builtin`
		map_key('<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
		map_key('<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })

		map_key('<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
		map_key('<leader>sg', builtin.git_files, { desc = 'Search [G]it [F]iles' })
		map_key('<leader>sw', builtin.live_grep, { desc = 'Search [W]orkspace' })
		map_key('<leader>sc', builtin.commands, { desc = 'Search [C]ommands' })
		map_key('<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		map_key('<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		map_key('<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

		map_key('<leader>/', function()
			local themes = require('telescope.themes')
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = '[/] Fuzzily search in current buffer' })
	end
}
