return {
	'echasnovski/mini.cursorword',

	event = 'VeryLazy',

	opts = {
		delay = 250,
	},

	init = function()
		local autocmd = require 'util.autocmd'

		local augroup = autocmd.group 'mini-cursorword'

		augroup:on({ 'BufEnter', 'TermOpen' }, '*', function(event)
			vim.b[event.buf].minicursorword_disable = vim.bo[event.buf].buftype ~= ''
		end)
	end,
}
