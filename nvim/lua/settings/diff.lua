local keymap = require 'util.keymap'

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

	keymap {
		[{ 'n', desc = 'Merge diff: %s' }] = {
			['<Leader>do'] = { '<Cmd>diffget 1<CR>', 'ours' },
			['<Leader>db'] = { '<Cmd>diffget 2<CR>', 'base' },
			['<Leader>dt'] = { '<Cmd>diffget 3<CR>', 'theirs' },
			['<Leader>dc'] = { '<Cmd>cquit<CR>', 'cancel' },
		},
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
