local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local options = require 'util.options'

keymap {
	[{ 'n', desc = 'Git: %s' }] = {
		['<leader>gg'] = { '<Cmd>vert botright Git<CR>', 'status' },
		['<leader>G'] = { ':Git ', 'command' },

		['<leader>gS'] = { '<Cmd>Git add %<CR>', 'stage file' },
		['<leader>gU'] = { '<Cmd>Git restore --staged %<CR>', 'unstage file' },
	},
}

local augroup = autocmd.group 'fugitive'

augroup:on_user('FugitiveIndex', function(event)
	keymap {
		[{ 'n', buffer = event.buf, desc = 'Git: %s' }] = {
			['<leader>gg'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
			['q'] = { '<Cmd>wincmd c | wincmd p<CR>', 'close' },
		},
	}

	local bo, wo, win = options.buflocal(event.buf)

	bo.buflisted = false
	wo.number = false
	wo.relativenumber = false
	wo.signcolumn = 'no'
	wo.winbar = '%=󰊢 git status%='

	vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.35))
end)

augroup:on_user('FugitiveEditor', function(event)
	keymap {
		[{ 'n', buffer = event.buf, nowait = true, desc = 'Git: %s' }] = {
			['<leader>w'] = { '<Cmd>w | bd<CR>', 'accept' },
			['<CR>'] = { '<Cmd>w | bd<CR>', 'accept' },
			['q'] = { 'ggdG<Cmd>w | bd<CR>', 'cancel' },
		},
	}

	local _, wo = options.buflocal(event.buf)

	wo.number = false
	wo.relativenumber = false
	wo.signcolumn = 'no'
	wo.winbar = '%=󰊢 git editor%='

	if vim.o.splitbelow then
		vim.cmd.wincmd 'r'
	end
end)

return {
	'tpope/vim-fugitive',

	cmd = { 'Git', 'G' },

	ft = { 'gitcommit', 'gitrebase', 'fugitive' },
}
