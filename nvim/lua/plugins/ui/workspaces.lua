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
			open = function()
				vim.cmd.edit(vim.fn.getcwd())
			end,
			open_pre = function()
				if vim.bo.filetype ~= 'ministarter' then
					vim.cmd.tabnew()
				end
			end,
		},
	},
}
