return {
	'natecraddock/workspaces.nvim',

	lazy = false,

	opts = {
		path = vim.fn.stdpath 'data' .. '/workspaces',

		cd_type = 'tab',

		sort = true,
		mru_sort = true,

		auto_open = true,
		auto_dir = true,

		hooks = {
			open = { 'Neotree current filesystem' },
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
