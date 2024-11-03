local severity_to_md_quote = {
	[vim.diagnostic.severity.ERROR] = '> [!ERROR]',
	[vim.diagnostic.severity.WARN] = '> [!WARNING]',
	[vim.diagnostic.severity.INFO] = '> [!INFO]',
	[vim.diagnostic.severity.HINT] = '> [!HINT]',
}

vim.diagnostic.config {
	update_in_insert = true,

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅝',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},
	},

	float = {
		-- NOTE: format can't return the highlight, so we use prefix & suffix without it
		format = function()
			return ''
		end,

		prefix = function(report)
			return severity_to_md_quote[report.severity] .. string.format(' %s\n', report.code), 'Normal'
		end,

		suffix = function(report, i, total)
			local message = vim.trim(report.user_data.lsp.message)
			local md_quote = '> ' .. table.concat(vim.split(message, '\n'), '\n> ')
			local separator = '\n' .. (i < total and '---' or '')
			return md_quote .. separator, 'Normal'
		end,
	},
}

local builtin_open_float = vim.diagnostic.open_float

---@diagnostic disable-next-line: duplicate-set-field
vim.diagnostic.open_float = function(...)
	local bufnr, winid = builtin_open_float(...)

	if bufnr and winid then
		vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
		vim.api.nvim_set_option_value('filetype', 'markdown', { buf = bufnr })
	end

	return bufnr, winid
end
