local M = {}

---@param winnr? integer
---@param winlayout? table
---@return 'leaf' | 'col' | 'row' | nil
function M.layout_type(winnr, winlayout)
	if not winnr then
		winnr = vim.api.nvim_get_current_win()
	end

	if not winlayout then
		winlayout = vim.fn.winlayout()
	end

	if winlayout[1] == 'leaf' then
		return winlayout[2] == winnr and 'leaf' or nil
	end

	for _, child_layout in ipairs(winlayout[2]) do
		local child_layout_type = M.layout_type(winnr, child_layout)
		if child_layout_type == 'leaf' then
			return winlayout[1]
		elseif child_layout_type then
			return child_layout_type
		end
	end
end

return M
