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

return {
	'L3MON4D3/LuaSnip',

	event = { 'InsertEnter' },

	dependencies = {
		'rafamadriz/friendly-snippets',
	},

	build = 'make install_jsregexp',

	config = function()
		require('luasnip.loaders.from_vscode').lazy_load { exclude = { 'javascriptreact', 'typescriptreact' } }

		local luasnip = require 'luasnip'
		luasnip.filetype_extend('typescript', { 'javascript', 'tsdoc' })
		luasnip.filetype_extend('typescriptreact', { 'typescript', 'javascript', 'tsdoc' })
		luasnip.filetype_extend('javascript', { 'jsdoc' })
		luasnip.filetype_extend('javascriptreact', { 'javascript', 'jsdoc' })
		luasnip.filetype_extend('lua', { 'luadoc' })
		luasnip.filetype_extend('python', { 'pydoc' })
		luasnip.filetype_extend('rust', { 'rustdoc' })
		luasnip.filetype_extend('cs', { 'csharpdoc' })
		luasnip.filetype_extend('java', { 'javadoc' })
		luasnip.filetype_extend('c', { 'cdoc' })
		luasnip.filetype_extend('cpp', { 'cppdoc' })
		luasnip.filetype_extend('php', { 'phpdoc' })
		luasnip.filetype_extend('kotlin', { 'kdoc' })
		luasnip.filetype_extend('ruby', { 'rdoc' })
		luasnip.filetype_extend('sh', { 'shelldoc' })
	end,
}
