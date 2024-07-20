local M = {}

---@param value number
---@param min number
---@param max number
function M.clamp(value, min, max)
	if min > max then
		return M.clamp(value, max, min)
	end
	return math.max(min, math.min(max, value))
end

return M
