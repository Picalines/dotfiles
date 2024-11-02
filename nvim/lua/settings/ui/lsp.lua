local func = require 'util.func'

vim.diagnostic.config {
	update_in_insert = true,

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅝',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},

		numhl = {
			[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
			[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
			[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
			[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
		},
	},

	float = {
		-- NOTE: format can't return the highlight, so we use prefix & suffix without it
		format = func.const '',

		prefix = function(report)
			local signs = vim.diagnostic.config().signs or {}
			local icon = signs.text[report.severity]
			return icon .. ' ', signs.numhl[report.severity]
		end,

		suffix = function(report)
			local hl = 'Normal'
			local message = vim.trim(report.user_data.lsp.message)

			if string.find(message, '\n') then
				return string.format('%s\n^ (%s)', message, report.code), hl
			end

			return string.format('%s (%s)', message, report.code), hl
		end,
	},
}

local builtin_open_float = vim.diagnostic.open_float

---@diagnostic disable-next-line: duplicate-set-field
vim.diagnostic.open_float = function(...)
	local bufnr, winid = builtin_open_float(...)

	vim.api.nvim_set_option_value('filetype', 'markdown', { buf = bufnr })

	return bufnr, winid
end
