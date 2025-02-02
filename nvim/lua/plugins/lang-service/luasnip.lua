return {
	'L3MON4D3/LuaSnip',

	event = { 'InsertEnter' },

	dependencies = {
		'rafamadriz/friendly-snippets',
	},

	build = 'make install_jsregexp',

	config = function(_, opts)
		local keymap = require 'util.keymap'
		local luasnip = require 'luasnip'

		if opts then
			luasnip.config.setup(opts)
		end

		keymap.declare {
			[{ 'i', 's' }] = {
				['<C-k>'] = function()
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					end
				end,

				['<C-j>'] = function()
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					end
				end,
			},
		}

		require('luasnip.loaders.from_vscode').lazy_load { exclude = { 'javascriptreact', 'typescriptreact' } }

		require('luasnip.loaders.from_lua').lazy_load()
		require('luasnip.loaders.from_snipmate').lazy_load()

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
