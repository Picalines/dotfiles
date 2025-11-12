local M = {}

-- Not used, but I'm afraid to remove this

---@param s string
---@param len integer
---@param char? string
function M.pad_left(s, len, char)
	char = char or ' '

	if vim.fn.strlen(char) ~= 1 then
		error 'pad_left received non single character'
	end

	local s_len = vim.fn.strcharlen(s)

	if s_len >= len then
		return s
	end

	return string.rep(char, len - s_len) .. s
end

---@param s string
---@param len integer
---@param char? string
function M.pad_right(s, len, char)
	char = char or ' '

	if vim.fn.strlen(char) ~= 1 then
		error 'pad_right received non single character'
	end

	local s_len = vim.fn.strcharlen(s)

	if s_len >= len then
		return s
	end

	return s .. string.rep(char, len - s_len)
end

---@class pad_center_opts
---@field pad_char? string
---@field align_odd? 'left' | 'right'

---@param s string
---@param len integer
---@param opts? pad_center_opts
function M.pad_center(s, len, opts)
	local s_len = vim.fn.strcharlen(s)

	if s_len >= len then
		return vim.fn.strcharpart(s, 0, len)
	end

	opts = opts or {}
	local pad_char = opts.pad_char or ' '

	if vim.fn.strcharlen(pad_char) ~= 1 then
		error 'center_chars received non single character'
	end

	local pad_side_len = math.floor((len - s_len) / 2)
	local pad_side = string.rep(pad_char, pad_side_len)

	local padded = pad_side .. s .. pad_side
	local odd_pad = string.rep(pad_char, len - vim.fn.strcharlen(padded))
	if opts.align_odd == 'right' then
		padded = odd_pad .. padded
	else
		padded = padded .. odd_pad
	end

	return padded
end

return M
