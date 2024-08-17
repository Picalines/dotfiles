vim.o.autoread = true

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermLeave' }, {
	pattern = '*',
	command = 'checktime',
})
