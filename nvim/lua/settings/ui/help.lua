local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

local augroup = autocmd.group 'help'

augroup:on('FileType', 'help', function(event)
	autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L')

	keymap {
		[{ 'n', buffer = event.buf }] = {
			['q'] = { '<C-w>c', 'close' },
		},
	}
end)
