local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.tab'

-- go to left tab when closing
vim.go.tabclose = 'left'

-- NOTE: <Tab> is same as <C-i> in a TUI
-- Please, don't make this commit again

keys('Page: %s', { silent = true }) {
	map('<Leader>tn', 'new') '<Cmd>tabnew<CR>',
	map('<Leader>td', 'close') '<Cmd>tabclose<CR>',

	map(']t', 'next') '<Cmd>tabnext<CR>',
	map('[t', 'prev') '<Cmd>tabprev<CR>',

	map('<Leader>to', 'only') '<Cmd>tabonly<CR>',
}
