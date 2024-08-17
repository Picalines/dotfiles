vim.diagnostic.config {
	update_in_insert = true,

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '󰌵',
		},
	},
}
