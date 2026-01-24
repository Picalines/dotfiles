return {
	'L3MON4D3/LuaSnip',

	event = { 'InsertEnter' },

	build = 'make install_jsregexp',

	init = function()
		local keymap = require 'util.keymap'

		local function expand_or_jump()
			local luasnip = require 'luasnip'
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end

		local function jump_back()
			local luasnip = require 'luasnip'
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end

		keymap {
			[{ 'i', 's', desc = 'Snippet: %s' }] = {
				['<C-k>'] = { expand_or_jump, 'expand / jump' },
				['<C-j>'] = { jump_back, 'jump back' },
			},
		}
	end,

	config = function()
		require('luasnip.loaders.from_snipmate').lazy_load()
	end,
}
