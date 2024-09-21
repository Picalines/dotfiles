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

		autocmd.on_colorscheme('*', clear_all_bgs)

		keymap.declare {
			[{ 'n' }] = {
				['<leader><leader>t'] = { transparent.toggle, 'Toggle transparency' },
			},
		}
	end,
}
