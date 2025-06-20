local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Git: %s' }] = {
		['<leader>gg'] = { '<Cmd>vert botright Git<CR>', 'status' },
		['<leader>G'] = { ':Git ', 'command' },

		['<leader>gS'] = { '<Cmd>Git add %<CR>', 'stage file' },
		['<leader>gU'] = { '<Cmd>Git restore --staged %<CR>', 'unstage file' },
	},
}

local augroup = autocmd.group 'fugitive'

augroup:on('BufWinEnter', 'fugitive://*', function(event)
	local win = vim.fn.bufwinid(event.buf)

	vim.bo[event.buf].buflisted = false
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = 'no'
	vim.wo[win].winbar = '󰊢 git'

	keymap {
		[{ 'n', buffer = event.buf, desc = 'Git: %s' }] = {
			['<leader>gg'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
			['q'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
		},
	}
end)

augroup:on('FileType', { 'gitcommit', 'gitrebase' }, function(event)
	keymap {
		[{ 'n', buffer = event.buf, nowait = true, desc = 'Git: %s' }] = {
			['<leader>w'] = { '<Cmd>w | bd<CR>', 'accept' },
			['<CR>'] = { '<Cmd>w | bd<CR>', 'accept' },
			['q'] = { 'ggdG<Cmd>w | bd<CR>', 'cancel' },
		},
	}
end)

augroup:on_user('FugitiveEditor', function(event)
	if vim.bo[event.buf].filetype == 'gitcommit' then
		vim.cmd 'startinsert'
	end
end)

return {
	'tpope/vim-fugitive',

	cmd = { 'Git', 'G' },

	ft = { 'gitcommit', 'gitrebase', 'fugitive' },
}
