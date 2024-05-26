return {
	'L3MON4D3/LuaSnip',

	dependencies = {
		'saadparwaiz1/cmp_luasnip',
		'rafamadriz/friendly-snippets',
	},

	build = 'make install_jsregexp',

	config = function(_, opts)
		local luasnip = require 'luasnip'

		if opts then
			luasnip.config.setup(opts)
		end

		require('luasnip.loaders.from_vscode').lazy_load()
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
