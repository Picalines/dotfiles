local util = require 'lspconfig.util'

return {
	init_options = {
		storagePath = util.path.join(vim.fn.stdpath 'data', 'kotlin_language_server'),
	},
}
