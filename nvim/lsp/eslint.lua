-- https://github.com/neovim/nvim-lspconfig/blob/cf97d2485fc3f6d4df1b79a3ea183e24c272215e/lua/lspconfig/server_configurations/eslint.lua#L65

return {
	root_markers = {
		'.eslintrc',
		'.eslintrc.js',
		'.eslintrc.cjs',
		'.eslintrc.yaml',
		'.eslintrc.yml',
		'.eslintrc.json',
		'.eslintrc.jsonc',
		'eslint.config.js',
		'eslint.config.mjs',
		'eslint.config.cjs',
		'eslint.config.ts',
		'eslint.config.mts',
		'eslint.config.cts',
	},

	handlers = {
		['eslint/noLibrary'] = function()
			-- vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
			return {}
		end,
	},
}
