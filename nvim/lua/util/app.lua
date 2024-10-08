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

---@alias os_id
---| 'windows'
---| 'macos'
---| 'linux'

---@return os_id
function M.os()
	if vim.fn.has 'win32' == 1 then
		return 'windows'
	end

	if vim.fn.has 'macunix' == 1 then
		return 'macos'
	end

	return 'linux'
end

return M
