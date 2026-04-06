return {
	{
		'mason-org/mason.nvim',

		event = 'VeryLazy',

		opts = {
			ui = {
				border = 'rounded',
			},
		},
	},

	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',

		dependencies = { 'mason-org/mason.nvim' },

		event = 'VeryLazy',

		opts = function()
			local ensure_installed = {
				'bash-language-server',
				'gh-actions-language-server',
				'jsonls',
				'lua_ls',
				'shellcheck',
				'stylua',
				'ts_query_ls',
				'vim-language-server',
			}

			local ensure_installed_by_executable = {
				[{ 'node' }] = {
					'css-lsp',
					'graphql-language-service-cli',
					'html-lsp',
					'stylelint-language-server',
					'svelte-language-server',
					'tailwindcss-language-server',
					'vtsls',
				},
				[{ 'python', 'python3' }] = { 'pyright' },
				[{ 'docker' }] = { 'docker-compose-language-service', 'dockerfile-language-server' },
				[{ 'go' }] = { 'gopls' },
				[{ 'rustc' }] = { 'rust-analyzer' },
				[{ 'kotlin' }] = { 'kotlin-language-server' },
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
}
