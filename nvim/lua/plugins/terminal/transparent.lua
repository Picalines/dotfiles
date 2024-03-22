return {
	'xiyaowong/transparent.nvim',

	config = function()
		local transparent = require 'transparent'

		transparent.setup {
			extra_groups = { 'NormalFloat' },
		}

		local clear_prefixes = {
			'Cokeline',
			'NeoTree',
			'lualine',
		}

		transparent.clear()

		for _, prefix in ipairs(clear_prefixes) do
			transparent.clear_prefix(prefix)
		end
	end,
}
