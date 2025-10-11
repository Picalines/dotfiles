return {
	'nvim-treesitter/nvim-treesitter',

	lazy = false,
	branch = 'main',
	build = ':TSUpdate',

	init = function()
		vim.go.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,

	config = function()
		local autocmd = require 'util.autocmd'
		local nvim_treesitter = require 'nvim-treesitter'

		nvim_treesitter.setup()

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

		local function install_by_filetype(filetypes)
			nvim_treesitter.install(vim
				.iter(filetypes)
				:map(function(filetype)
					return parsers_by_filetype[filetype]
				end)
				:flatten())
		end

		local augroup = autocmd.group 'nvim-treesitter'

		augroup:on('UIEnter', '*', function()
			nvim_treesitter.install {
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
				'markdown_linline',
				'toml',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
			}

			local recent_filetypes = vim.fn.uniq(vim
				.iter(vim.v.oldfiles)
				:take(8)
				:map(function(oldfile)
					local filetype = vim.filetype.match { filename = oldfile }
					return filetype
				end)
				:totable())

			install_by_filetype(recent_filetypes)
		end)

		augroup:on('FileType', '*', function(event)
			install_by_filetype { event.match }

			local language = vim.treesitter.language.get_lang(event.match)
			if language and vim.treesitter.language.add(language) then
				vim.treesitter.start(event.buf, language)
			end
		end)
	end,
}
