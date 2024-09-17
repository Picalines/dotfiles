local M = {}

---@class pad_centered_opts
---@field pad_char? string
---@field align_odd? 'left' | 'right'

---@param s string
---@param len integer
---@param opts? pad_centered_opts
function M.center_chars(s, len, opts)
	local s_len = vim.fn.strcharlen(s)

	if s_len >= len then
		return vim.fn.strcharpart(s, 0, len)
	end

	opts = opts or {}
	local pad_char = opts.pad_char or ' '

	if vim.fn.strcharlen(pad_char) ~= 1 then
		error 'pad_char received non single character'
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
