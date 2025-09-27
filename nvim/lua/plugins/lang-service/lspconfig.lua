return {
	{
		'neovim/nvim-lspconfig',

		event = 'VeryLazy',
	},

	{
		'williamboman/mason-lspconfig.nvim',

		event = 'VeryLazy',

		dependencies = {
			'neovim/nvim-lspconfig',
			'mason-org/mason.nvim',
		},

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
}
