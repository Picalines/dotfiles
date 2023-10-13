return {
	-- File explorer
	'nvim-tree/nvim-tree.lua',
	opts = {},
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local nvim_tree = require('nvim-tree')

		vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>')

		local function on_attach(bufnr)
			local api = require('nvim-tree.api')

			local function map_key(key, fn, opts)
				return vim.keymap.set('n', key, fn, opts)
			end

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)

			map_key('<C-P>', api.tree.change_root_to_parent, opts('Up'))
			map_key('?', api.tree.toggle_help, opts('Help'))

			map_key('h', api.tree.close, opts('Close'))
			map_key('l', api.node.open.edit, opts('Edit Or Open'))
			map_key('H', api.tree.collapse_all, opts('Collapse All'))
		end

		nvim_tree.setup({
			on_attach = on_attach,

			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,

			diagnostics = {
				enable = true,
			},

			git = {
				enable = true,
				ignore = true,
				timeout = 500,
			},

			renderer = {
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
						}
					}
				},
			},
		})
	end,
}
