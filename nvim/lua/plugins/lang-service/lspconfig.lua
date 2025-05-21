return {
	'neovim/nvim-lspconfig',

	event = 'VeryLazy',

	dependencies = {
		{
			'williamboman/mason.nvim',

			opts = {
				ui = {
					border = 'rounded',
				},
			},
		},

		{
			'williamboman/mason-lspconfig.nvim',

			opts = {
				ensure_installed = {},
				automatic_installation = false,
				automatic_enable = true,
			},
		},

		{
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			event = 'UiEnter',

			opts = {
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
				local installer = require 'mason-tool-installer'

				local packages_by_executables = {
					[{ 'node' }] = {
						{ 'biome', version = '1.9.4' },
						'graphql-language-service-cli',
						'prettierd',
						'svelte-language-server',
						'tailwindcss-language-server',
						'typescript-language-server',
						{ 'eslint-lsp', version = '4.8.0' },
					},

					[{ 'python', 'python3' }] = { 'black', 'isort', 'pyright' },

					[{ 'dotnet' }] = { 'csharpier' },

					[{ 'docker' }] = { 'docker-compose-language-service', 'dockerfile-language-server' },

					[{ 'go' }] = { 'gopls' },

					[{ 'rustc' }] = { 'rust-analyzer' },

					[{ 'kotlin' }] = { 'kotlin-language-server', 'ktfmt', 'ktlint' },

					[{ 'gradle' }] = { 'gradle-language-server' },
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
				opts.run_on_start = true

				installer.setup(opts)

				-- NOTE: doesn't called automatically because of lazy loading
				-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
				installer.run_on_start()
			end,
		},
	},
}
