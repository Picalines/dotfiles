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

			init = function()
				vim.lsp.config('lua_ls', {
					settings = {
						Lua = { telemetry = { enable = false } },
					},
				})

				vim.lsp.config('tailwindcss', {
					settings = {
						tailwindCSS = {
							classFunctions = { 'tw', 'clsx', 'cva', 'cn' },
							classAttributes = { 'class', 'className', 'ngClass', 'class:list' },
						},
					},
				})
			end,
		},

		{
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			opts = function()
				local ensure_installed = {
					'jsonls',
					'lua_ls',
					'stylua',
					'vim-language-server',
				}

				local ensure_installed_by_executable = {
					[{ 'node' }] = {
						{ 'biome', version = '1.9.4' },
						'graphql-language-service-cli',
						'prettierd',
						'svelte-language-server',
						'tailwindcss-language-server',
						'vtsls',
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

				for executables, packages in pairs(ensure_installed_by_executable) do
					local should_install = vim.iter(executables):any(function(exe)
						return vim.fn.executable(exe) == 1
					end)

					if should_install then
						vim.list_extend(ensure_installed, packages)
					end
				end

				return {
					auto_update = true,
					debounce_hours = 6,
					ensure_installed = ensure_installed,
					run_on_start = true,
				}
			end,

			config = function(_, opts)
				local installer = require 'mason-tool-installer'

				installer.setup(opts)

				-- NOTE: doesn't called automatically because of lazy loading
				-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
				installer.run_on_start()
			end,
		},
	},
}
