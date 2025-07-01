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

---@return vim.wo wo
---@return vim.bo bo
---@return integer bufid
function M.winlocal(winid)
	local buf = vim.api.nvim_win_get_buf(winid)
	local wo = vim.wo[winid]
	local bo = vim.bo[buf]
	return wo, bo, buf
end

return M
