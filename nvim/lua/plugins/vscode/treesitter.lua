local tbl = require 'util.table'

local base = require 'plugins.nvim.treesitter'

return tbl.override_deep(base, {
	config = function()
		base.config()

		require('nvim-treesitter.configs').setup {
			highlight = { enable = false },
		}
	end,
})
