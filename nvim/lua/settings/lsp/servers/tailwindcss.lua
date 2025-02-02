local lspconfig_util = require 'lspconfig.util'

return {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					'tw`([^`]*)',
					'clsx[`]([\\s\\S][^`]*)[`]',
					{ 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'cva\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'cn\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'withClassName\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
				},
			},
		},
	},

	root_dir = lspconfig_util.root_pattern { 'pnpm-workspace.yaml', 'pnpm-lock.yaml' },
}
