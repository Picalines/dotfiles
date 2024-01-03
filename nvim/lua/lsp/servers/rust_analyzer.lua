local lsp_util = require 'lspconfig.util'

return {
	root_dir = lsp_util.root_pattern 'Cargo.toml',
	settings = {
		['rust-analyzer'] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
}
