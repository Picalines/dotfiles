return {
	'saghen/blink.indent',

	--- @module 'blink.indent'
	--- @type blink.indent.Config
	opts = {
		blocked = {
			filetypes = { include_defaults = true, 'markdown' },
		},

		mappings = {
			border = 'both',
			object_scope = 'ii',
			object_scope_with_border = 'ai',
			goto_top = '[i',
			goto_bottom = ']i',
		},
	},
}
