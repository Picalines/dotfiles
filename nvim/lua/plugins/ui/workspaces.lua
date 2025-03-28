local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', desc = 'Tab: %s' }] = {
		['<tab>w'] = { '<Cmd>tabnew | WorkspacesOpen<Cr>', 'new in workspace' },
	},
}

return {
	'natecraddock/workspaces.nvim',

	lazy = false,

	opts = {
		path = vim.fn.stdpath 'data' .. '/workspaces',

		cd_type = 'tab',

		sort = true,
		mru_sort = true,

		auto_open = false,
		auto_dir = false,

		hooks = {
			open = {
				'Neotree current filesystem',
				function(w_name)
					vim.t.tab_label = w_name
				end,
			},
		},
	},

	config = function(_, opts)
		local workspaces = require 'workspaces'

		workspaces.setup(opts)

		if #workspaces.get() == 0 then
			local default_repos_dir = vim.fn.expand '~/Repos'

			if vim.fn.isdirectory(default_repos_dir) == 1 then
				workspaces.add_dir(default_repos_dir)
			end
		end

		workspaces.sync_dirs()
	end,
}
