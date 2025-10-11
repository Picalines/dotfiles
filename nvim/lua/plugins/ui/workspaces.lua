return {
	'natecraddock/workspaces.nvim',

	event = 'VeryLazy',

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'Workspace: %s' }] = {
				['<leader>o'] = { '<Cmd>WorkspacesOpen<Cr>', 'open' },
			},
		}

		local augroup = autocmd.group 'workspaces'

		augroup:on('UIEnter', '*', function()
			local workspaces = require 'workspaces'

			if #workspaces.get() == 0 then
				local default_repos_dir = vim.fn.expand '~/Repos'

				if vim.fn.isdirectory(default_repos_dir) == 1 then
					workspaces.add_dir(default_repos_dir)
				end
			end
		end)
	end,

	opts = {
		path = vim.fn.stdpath 'data' .. '/workspaces',

		cd_type = 'tab',

		sort = true,
		mru_sort = true,

		auto_open = false,
		auto_dir = false,

		hooks = {
			open_pre = {
				function(_, workspace_dir)
					if vim.bo.filetype == 'ministarter' then
						return true
					end

					workspace_dir = vim.fs.normalize(workspace_dir)

					local tabpage = vim.iter(vim.api.nvim_list_tabpages()):find(function(tabpage)
						local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
						local tab_dir = (vim.fn.getcwd(-1, tabnr))
						local eq = vim.fs.normalize(tab_dir) == workspace_dir
						return eq
					end)

					if tabpage then
						vim.api.nvim_set_current_tabpage(tabpage)
						return false
					end

					vim.cmd.tabnew()
				end,
				function(_, workspace_dir)
					vim.cmd.edit(workspace_dir)
				end,
			},
		},
	},
}
