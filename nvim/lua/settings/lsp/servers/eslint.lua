-- https://github.com/neovim/nvim-lspconfig/blob/cf97d2485fc3f6d4df1b79a3ea183e24c272215e/lua/lspconfig/server_configurations/eslint.lua#L65

local lsp_util = require 'lspconfig.util'

local root_file = {
	'.eslintrc',
	'.eslintrc.js',
	'.eslintrc.cjs',
	'.eslintrc.yaml',
	'.eslintrc.yml',
	'.eslintrc.json',
	'eslint.config.js',
	'eslint.config.mjs',
	'eslint.config.cjs',
	'eslint.config.ts',
	'eslint.config.mts',
	'eslint.config.cts',
}

return {
	root_dir = function(fname)
		root_file = lsp_util.insert_package_json(root_file, 'eslintConfig', fname)
		return lsp_util.root_pattern(unpack(root_file))(fname)
	end,
}
