return {
	-- File explorer
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local nvim_tree = require 'nvim-tree'
		local api = require 'nvim-tree.api'

		vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', {
			silent = true,
			desc = 'Focus on File [E]xplorer',
		})

		vim.keymap.set('n', '<leader>E', ':NvimTreeFindFileToggle<CR>', {
			silent = true,
			desc = 'Toggle File [E]xplorer',
		})

		local function on_attach(bufnr)
			local function map_key(key, fn, desc)
				return vim.keymap.set('n', key, fn, {
					desc = 'nvim-tree: ' .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					-- nowait = true,
				})
			end

			local function bulk_move()
				local marked_nodes = api.marks.list()
				api.marks.clear()
				if #marked_nodes == 0 then
					return
				end

				-- TODO: move folder to its subfolder check

				local dest_folder = api.tree.get_node_under_cursor()
				if dest_folder.type == 'file' then
					api.marks.toggle(dest_folder)
					api.node.navigate.parent()
					dest_folder = api.tree.get_node_under_cursor()
					api.marks.navigate.next()
					api.marks.clear()
				end

				for _, node in pairs(marked_nodes) do
					api.fs.cut(node)
					api.fs.paste(dest_folder)
				end
			end

			map_key('<leader>e', '<C-W><C-P><CR>', 'Jump back')

			map_key('<C-P>', api.tree.change_root_to_parent, 'Up')
			map_key('?', api.tree.toggle_help, 'Help')

			map_key('h', api.tree.close, 'Close')
			map_key('l', api.node.open.edit, 'Edit Or Open')
			map_key('H', api.tree.collapse_all, 'Collapse All')
			map_key('L', api.tree.expand_all, 'Expand All')
			map_key('K', api.node.navigate.sibling.first, 'First Sibling')
			map_key('J', api.node.navigate.sibling.last, 'Last Sibling')
			map_key('P', api.node.navigate.parent, 'Parent Directory')
			map_key('<BS>', api.node.navigate.parent_close, 'Close Directory')

			map_key(']d', api.node.navigate.diagnostics.next, 'Next Diagnostic')
			map_key('[d', api.node.navigate.diagnostics.prev, 'Prev Diagnostic')
			map_key('[c', api.node.navigate.git.prev, 'Prev Git')
			map_key(']c', api.node.navigate.git.next, 'Next Git')
			map_key(']m', api.marks.navigate.next, 'Next Mark')
			map_key('[m', api.marks.navigate.prev, 'Prev Mark')

			map_key('-', api.tree.change_root_to_parent, 'Up')
			map_key('_', api.tree.change_root_to_node, 'CD')

			map_key('o', api.node.open.edit, 'Open')
			map_key('<CR>', api.node.open.edit, 'Open')
			map_key('<2-LeftMouse>', api.node.open.edit, 'Open')
			map_key('<C-s>', api.node.run.system, 'Open: System')
			map_key('<S-t>', api.node.open.tab, 'Open: New Tab')
			map_key('<S-v>', api.node.open.vertical, 'Open: Vertical Split')
			map_key('<S-h>', api.node.open.horizontal, 'Open: Horizontal Split')
			map_key('<Tab>', api.node.open.preview, 'Open Preview')

			map_key('a', api.fs.create, 'Create')
			map_key('r', api.fs.rename, 'Rename')
			map_key('d', api.fs.trash, 'Trash')
			map_key('D', api.fs.remove, 'Delete')
			map_key('c', api.fs.copy.node, 'Copy')
			map_key('x', api.fs.cut, 'Cut')
			map_key('p', api.fs.paste, 'Paste')

			map_key('m', api.marks.toggle, 'Toggle Bookmark')
			map_key('M', api.marks.clear, 'Clear Bookmarks')
			map_key('bd', api.marks.bulk.trash, 'Trash Bookmarked')
			map_key('bD', api.marks.bulk.delete, 'Delete Bookmarked')
			map_key('bm', bulk_move, 'Move Bookmarked')

			map_key('fc', api.tree.toggle_git_clean_filter, 'Toggle Filter: Git Clean')
			map_key('fi', api.tree.toggle_gitignore_filter, 'Toggle Filter: Git Ignore')
			map_key('fb', api.tree.toggle_no_buffer_filter, 'Toggle Filter: No Buffer')
			map_key('fh', api.tree.toggle_custom_filter, 'Toggle Filter: Hidden')

			map_key('yn', api.fs.copy.filename, 'Copy Name')
			map_key('yp', api.fs.copy.relative_path, 'Copy Relative Path')
			map_key('yP', api.fs.copy.absolute_path, 'Copy Absolute Path')

			map_key('R', api.tree.reload, 'Refresh')
			map_key('.', api.node.run.cmd, 'Run Command')
			map_key('K', api.node.show_info_popup, 'Info')
		end

		nvim_tree.setup {
			on_attach = on_attach,

			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,

			update_focused_file = {
				enable = true,
			},

			hijack_directories = {
				auto_open = false,
			},

			diagnostics = {
				enable = true,
				show_on_dirs = true,

				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			},

			filters = {
				custom = {
					'^\\.git',
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
