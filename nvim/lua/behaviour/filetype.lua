local pattern_filetypes = {
	['*.typst'] = 'typst',
}

for pattern, filetype in pairs(pattern_filetypes) do
	vim.api.nvim_create_autocmd({ 'BufNew', 'BufNewFile', 'BufRead' }, {
		group = 'filetypedetect',
		pattern = pattern,
		command = ':setfiletype ' .. filetype,
	})
end
