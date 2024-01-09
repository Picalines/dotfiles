local util = require 'util'

local base = require 'plugins.nvim.nvim-treesitter'

return util.override_deep(base, {
	config = function()
		base.config()

		require('nvim-treesitter.configs').setup {
			highlight = { enable = false },
		}
	end,
})
