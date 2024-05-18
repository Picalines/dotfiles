local function define_sign(sign, text)
	return vim.fn.sign_define(sign, { text = text, texthl = sign })
end

define_sign('DiagnosticSignError', '')
define_sign('DiagnosticSignWarn', '')
define_sign('DiagnosticSignInfo', '')
define_sign('DiagnosticSignHint', '󰌵')

vim.diagnostic.config {
	update_in_insert = true,
}
