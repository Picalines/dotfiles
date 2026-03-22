return {
	'L3MON4D3/LuaSnip',

	event = { 'InsertEnter' },

	build = 'make install_jsregexp',

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map
		local keys = keymap.group 'plugins.edit.luasnip'

		keys('Snippet: %s', { 'i', 's' }) {
			map('<C-k>', 'expand or jump') {
				function()
					local luasnip = require 'luasnip'
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					end
				end,
			},

			map('<C-j>', 'jump back') {
				function()
					local luasnip = require 'luasnip'
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					end
				end,
			},
		}
	end,

	config = function()
		require('luasnip.loaders.from_snipmate').lazy_load()
	end,
}
