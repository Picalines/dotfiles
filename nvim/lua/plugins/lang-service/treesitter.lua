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

		augroup:on('UIEnter', '*', function()
			local always_installed_parsers = {
				'editorconfig',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'json',
				'json5',
				'jsonc',
				'lua',
				'luadoc',
				'markdown',
				'toml',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
			}

			vim.iter(always_installed_parsers):each(nvim_treesitter.install)
		end)

		local parsers_by_filetype = vim
			.iter({
				[{ 'bash', 'zsh' }] = { 'bash' },
				[{ 'c', 'cpp', 'cs' }] = { 'c', 'cpp', 'c_sharp' },
				[{ 'css' }] = { 'css' },
				[{ 'dockerfile' }] = { 'dockerfile' },
				[{ 'go' }] = { 'go', 'templ' },
				[{ 'graphql' }] = { 'graphql' },
				[{ 'html' }] = { 'html' },
				[{ 'http' }] = { 'http' },
				[{ 'javascript', 'typescript' }] = { 'javascript', 'typescript', 'jsdoc', 'css' },
				[{ 'javascriptreact', 'typescriptreact' }] = { 'jsx', 'tsx', 'graphql', 'css' },
				[{ 'python' }] = { 'python' },
				[{ 'svelte' }] = { 'svelte' },
				[{ 'vue' }] = { 'vue' },
			})
			:fold({}, function(acc, filetypes, parsers)
				for _, filetype in ipairs(filetypes) do
					acc[filetype] = parsers
				end
				return acc
			end)

		local function install_parsers(filetypes)
			vim
				.iter(filetypes)
				:map(function(filetype)
					return parsers_by_filetype[filetype]
				end)
				:flatten()
				:each(nvim_treesitter.install)
		end

		augroup:on('UIEnter', '*', function()
			local filetypes = vim.fn.uniq(vim
				.iter(vim.v.oldfiles)
				:map(function(oldfile)
					local filetype = vim.filetype.match { filename = oldfile }
					return filetype
				end)
				:totable())

			install_parsers(filetypes)
		end)

		augroup:on('FileType', '*', function(event)
			install_parsers { event.match }

			local language = vim.treesitter.language.get_lang(event.match)
			if language and vim.treesitter.language.add(language) then
				vim.treesitter.start(event.buf, language)
			end
		end)
	end,
}
