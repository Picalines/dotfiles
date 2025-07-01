local M = {}

---@return vim.bo bo
---@return vim.wo wo
---@return integer winid
function M.buflocal(buf)
	local winid = vim.fn.bufwinid(buf)
	local bo = vim.bo[buf]
	local wo = vim.wo[winid]
	return bo, wo, winid
end

return M
