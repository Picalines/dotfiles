return {
	'm4xshen/hardtime.nvim',

	event = 'VeryLazy',

	dependencies = { 'MunifTanjim/nui.nvim' },

	opts = {
		disable_mouse = false,
		disabled_keys = {},

		disable_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'fugitive' },
	},

	config = function(_, opts)
		local hardtime = require 'hardtime'
		local keymap = require 'util.keymap'
		local signal = require 'util.signal'

		local enabled = signal.new(true)
		signal.persist(enabled, 'plugin.hardtime.enabled')

		opts.enabled = enabled()
		hardtime.setup(opts)

		signal.watch(function()
			if enabled() then
				hardtime.enable()
			else
				hardtime.disable()
			end

			vim.g.status_hardtime_enabled = enabled()
		end)

		local function toggle()
			enabled(not enabled())
			print('Hardtime: ' .. (enabled() and 'on' or 'off'))
		end

		keymap.declare {
			[{ 'n' }] = {
				['<leader>it'] = { toggle, 'Toggle hardtime' },
			},
		}
	end,
}
