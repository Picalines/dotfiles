return {
	'rcarriga/nvim-notify',
	lazy = false,

	config = function()
		local notify = require 'notify'

		notify.setup {
			render = 'wrapped-compact',
			stages = 'slide',
			timeout = 5000,
			top_down = true,
		}

		vim.notify = notify
	end,
}
