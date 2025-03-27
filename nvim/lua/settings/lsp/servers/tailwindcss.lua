local lspconfig_util = require 'lspconfig.util'

return {
	settings = {
		tailwindCSS = {
			classFunctions = { 'tw', 'clsx', 'cva', 'cn', 'withClassName' },
			classAttributes = { 'class', 'className', 'ngClass', 'class:list' },
		},
	},

	root_dir = lspconfig_util.root_pattern { 'pnpm-workspace.yaml', 'pnpm-lock.yaml' },
}
