local M = {}

---@param s string
---@param pad_char string
---@param len integer
function M.pad_centered(s, pad_char, len)
	if #s >= len then
		return s:sub(1, len)
	end

	if #pad_char ~= 1 then
		error 'pad_char received non single character'
	end

	local pad_side_len = math.floor((len - #s) / 2)
	local pad_side = string.rep(pad_char, pad_side_len)

	local padded = pad_side .. s .. pad_side
	padded = padded .. string.rep(pad_char, len - #padded)

	return padded
end

return M
