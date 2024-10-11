return {
	'WhoIsSethDaniel/mason-tool-installer.nvim',

	event = 'UiEnter',

	opts = {
		run_on_start = true,
		auto_update = true,
		debounce_hours = 6,

		ensure_installed = {
			'jsonls',
			'lua_ls',
			'stylua',
			'vim-language-server',
		},
	},

	config = function(_, base_opts)
		local tbl = require 'util.table'
		local array = require 'util.array'

		local packages_by_executables = {
			[{ 'npm' }] = {
				{ 'biome', version = '1.8.3' },
				'graphql-language-service-cli',
				'prettierd',
				'svelte-language-server',
				'tailwindcss-language-server',
				'typescript-language-server',
				{ 'eslint-lsp', version = '4.8.0' },
			},

			[{ 'python', 'python3' }] = {
				'black',
				'isort',
				'pyright',
			},

			[{ 'dotnet' }] = {
				'csharpier',
			},

			[{ 'docker' }] = {
				'docker-compose-language-service',
				'dockerfile-language-server',
			},

			[{ 'go' }] = {
				'gopls',
			},
		}

		local ensure_installed = base_opts.ensure_installed or {}

		for executables, packages in pairs(packages_by_executables) do
			local should_install = array.some(executables, function(exe)
				return vim.fn.executable(exe) == 1
			end)

			if should_install then
				ensure_installed = array.concat(ensure_installed, packages)
			end
		end

		local opts = tbl.copy_deep(base_opts)
		opts.ensure_installed = ensure_installed

		require('mason-tool-installer').setup(opts)
	end,
}
