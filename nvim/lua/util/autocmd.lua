local M = {}

local group = vim.api.nvim_create_augroup('per_filetype', { clear = true })

---@param filetypes string | table<string>
function M.per_filetype(filetypes, callback)
	if type(filetypes) ~= 'table' then
		filetypes = { filetypes }
	end

	for _, filetype in pairs(filetypes) do
		vim.api.nvim_create_autocmd('BufWinEnter', {
			group = group,
			callback = function(opts)
				if vim.bo[opts.buf].filetype == filetype then
					callback(opts)
				end
			end,
		})
	end
end

return M
