return {
	-- File explorer
	'nvim-tree/nvim-tree.lua',
	opts = {},
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local function on_attach(bufnr)
			local api = require('nvim-tree.api')

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
			vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
		end

		require('nvim-tree').setup({
			on_attach = on_attach
		})

		vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
	end,
}
