return {
	'nvim-treesitter/nvim-treesitter',

	lazy = false,
	branch = 'main',
	build = ':TSUpdate',

	dependencies = {
		{
			'nvim-treesitter/nvim-treesitter-textobjects',
			branch = 'main',
		},
		{
			'windwp/nvim-ts-autotag',
			opts = {
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
			},
		},
		{
			'JoosepAlviste/nvim-ts-context-commentstring',
			opts = { enable_autocmd = false },
			init = function()
				local get_option = vim.filetype.get_option
				---@diagnostic disable-next-line: duplicate-set-field
				vim.filetype.get_option = function(filetype, option)
					return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
				end
			end,
		},
	},

	init = function()
		local autocmd = require 'util.autocmd'
		local nvim_treesitter = require 'nvim-treesitter'

		local augroup = autocmd.group 'nvim-treesitter'

		local available_parsers = nvim_treesitter.get_available()

		augroup:on('FileType', '*', function(event)
			local language = vim.treesitter.language.get_lang(event.match)
			if language and vim.list_contains(available_parsers, language) then
				nvim_treesitter.install(language):await(function()
					vim.treesitter.start(event.buf, language)
				end)
			end
		end)
	end,
}
