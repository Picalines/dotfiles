local M = {}

---@alias client_id
---| 'terminal'
---| 'neovide'
---| 'vscode'

---@return client_id
function M.client()
	if vim.g.neovide then
		return 'neovide'
	end

	if vim.g.vscode then
		return 'vscode'
	end

	return 'terminal'
end

return M
