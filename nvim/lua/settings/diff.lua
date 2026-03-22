local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.diff'

local is_diff_mode = vim.iter(vim.v.argv):any(function(arg)
	return arg == '-d' or arg == '--diff'
end)

if is_diff_mode then
	vim.opt_global.diffopt = {
		'algorithm:histogram',
		'closeoff',
		'filler',
		'followwrap',
		'internal',
		'linematch:40',
		'vertical',
	}

	vim.opt_global.equalalways = true
	vim.opt_global.eadirection = 'ver'

	keys 'Merge diff: %s' {
		map('<Leader>do', 'ours') '<Cmd>diffget 1<CR>',
		map('<Leader>db', 'base') '<Cmd>diffget 2<CR>',
		map('<Leader>dt', 'theirs') '<Cmd>diffget 3<CR>',
		map('<Leader>dc', 'cancel') '<Cmd>cquit<CR>',
	}

	vim.schedule(function()
		vim.cmd 'windo setlocal cursorline signcolumn=no foldcolumn=0'
		vim.cmd '1,3windo setlocal norelativenumber'
		vim.cmd '4wincmd w | wincmd J | wincmd ='
		vim.cmd 'normal! gg \\| silent! normal! ]c'

		vim.fn.setwinvar(1, '&winbar', '%=OURS%=')
		vim.fn.setwinvar(2, '&winbar', '%=BASE%=')
		vim.fn.setwinvar(3, '&winbar', '%=THEIRS%=')
	end)
end
