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

---@param a number
---@param b number
---@param t number
function M.lerp(a, b, t)
	t = M.clamp(t, 0, 1)
	return a * (1 - t) + b * t
end

return M
