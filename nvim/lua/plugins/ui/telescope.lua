local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Find: %s' }] = {
		['gD'] = { '<Cmd>Telescope lsp_definitions<CR>', 'lsp definitions' },
		['gR'] = { '<Cmd>Telescope lsp_references<CR>', 'lsp references' },
		['gI'] = { '<Cmd>Telescope lsp_implementations<CR>', 'lsp implementations' },
		['gT'] = { '<Cmd>Telescope lsp_type_definitions<CR>', 'lsp type definitions' },

		['<leader>bb'] = { '<Cmd>Telescope buffers<CR>', 'buffer' },
		['<leader>ss'] = { '<Cmd>Telescope telescope-tabs list_tabs<CR>', 'spaces' },

		['<leader>ff'] = { '<Cmd>Telescope find_files<CR>', 'files' },
		['<leader>fo'] = { '<Cmd>Telescope oldfiles<CR>', 'old files' },
		['<leader>fb'] = { '<Cmd>Telescope buffers<CR>', 'buffer' },
		['<leader>fg'] = { '<Cmd>Telescope live_grep<CR>', 'grep' },
		['<leader>fc'] = { '<Cmd>Telescope commands<CR>', 'commands' },
		['<leader>fh'] = { '<Cmd>Telescope help_tags<CR>', 'help' },
		['<leader>fd'] = { '<Cmd>Telescope diagnostics<CR>', 'diagnostics' },
		['<leader>fr'] = { '<Cmd>Telescope resume<CR>', 'resume' },
		['<leader>f/'] = { '<Cmd>Telescope current_buffer_fuzzy_find<CR>', 'in current buffer' },
		['<leader>fs'] = { '<Cmd>Telescope lsp_document_symbols<CR>', 'document symbols' },
		['<leader>fS'] = { '<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 'workspace symbols' },
		['<leader>ft'] = { '<Cmd>Telescope filetypes<CR>', 'Select filetypes' },

		['<leader>uC'] = { '<Cmd>Telescope colorscheme<CR>', 'colorscheme' },
	},
}

return {
	'nvim-telescope/telescope.nvim',

	event = 'VeryLazy',
	cmd = 'Telescope',

	dependencies = {
		'nvim-lua/plenary.nvim',

		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return require('util.app').os() ~= 'windows'
			end,
		},

		'nvim-telescope/telescope-ui-select.nvim',
		'gbrlsnchs/telescope-lsp-handlers.nvim',
		{
			'LukasPietzschmann/telescope-tabs',
			opts = {
				entry_formatter = function(tabnr, _, filenames)
					local tab_cwd = vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ':t')
					local file_list = table.concat(filenames, ', ')
					return string.format('%s: %s', tab_cwd, file_list)
				end,
			},
		},
	},

	config = function()
		local array = require 'util.array'
		local telescope = require 'telescope'
		local actions = require 'telescope.actions'
		local themes = require 'telescope.themes'

		local base_rg_args = {
			'--hidden',
			'--max-filesize=1G',
			'--color=never',
		}

		local ignore_files = {
			'.gitignore',
			'.arcignore',
		}

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

		local grep_args = array.concat(
			base_rg_args,
			array.flat_map(ignore_files, function(file)
				return { '--ignore-file', file }
			end),
			array.flat_map(always_exclude, function(path)
				return { '-g', '!' .. path }
			end)
		)

		local find_file_args = array.concat({ 'rg', '--files' }, grep_args)

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
					find_command = find_file_args,
				},

				live_grep = {
					additional_args = grep_args,
				},

				oldfiles = { previewer = false },
				buffers = { previewer = false },

				colorscheme = {
					enable_preview = true,
				},
			},
		}

		local function safe_load_extension(name)
			pcall(telescope.load_extension, name)
		end

		safe_load_extension 'fzf'
		safe_load_extension 'ui-select'
		safe_load_extension 'lsp_handlers'
		safe_load_extension 'telescope-tabs'
	end,
}
