return {
	'xiyaowong/transparent.nvim',

	cond = function()
		local app = require 'util.app'
		return app.client() == 'terminal'
	end,

	config = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'
		local transparent = require 'transparent'

		local function clear_all_bgs()
			transparent.setup {
				extra_groups = { 'NormalFloat' },
			}

			local clear_prefixes = {
				'Cokeline',
				'NeoTree',
				'lualine',
				'TabLine',
			}

			transparent.clear()

			for _, prefix in ipairs(clear_prefixes) do
				transparent.clear_prefix(prefix)
			end
		end

		clear_all_bgs()

		local augroup = autocmd.group 'transparent'

		augroup:on('ColorScheme', '*', clear_all_bgs)

		keymap.declare {
			[{ 'n', desc = 'UI: %s' }] = {
				['<leader>ug'] = { transparent.toggle, 'Toggle transparency' },
			},
		}
	end,
}
