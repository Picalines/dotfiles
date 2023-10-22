return {
	-- File explorer
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local nvim_tree = require 'nvim-tree'
		local api = require 'nvim-tree.api'

		vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>', {
			silent = true,
			desc = 'Open File [E]xplorer',
		})

		local function on_attach(bufnr)
			local function map_key(key, fn, desc)
				return vim.keymap.set('n', key, fn, {
					desc = 'nvim-tree: ' .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				})
			end

			api.config.mappings.default_on_attach(bufnr)

			map_key('<C-P>', api.tree.change_root_to_parent, 'Up')
			map_key('?', api.tree.toggle_help, 'Help')

			map_key('h', api.tree.close, 'Close')
			map_key('l', api.node.open.edit, 'Edit Or Open')
			map_key('H', api.tree.collapse_all, 'Collapse All')
		end

		nvim_tree.setup {
			on_attach = on_attach,

			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,

			update_focused_file = {
				enable = true,
			},

			diagnostics = {
				enable = true,
				show_on_dirs = true,

				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			},

			git = {
				enable = true,
				ignore = true,
				timeout = 500,
			},

			modified = {
				enable = true,
			},

			renderer = {
				group_empty = true,

				highlight_opened_files = 'icon',

				root_folder_label = function(path)
					return vim.fn.fnamemodify(path, ':t') .. '/'
				end,

				indent_markers = {
					enable = true,
				},

				icons = {
					glyphs = {
						git = {
							unstaged = 'M',
							staged = 'S',
							unmerged = 'C',
							renamed = 'R',
							untracked = 'U',
							deleted = 'D',
							ignored = '-',
						},
					},
				},
			},
		}
	end,
}
