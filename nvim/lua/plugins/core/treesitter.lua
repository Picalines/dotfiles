return {
	'nvim-treesitter/nvim-treesitter',

	lazy = false,
	branch = 'main',
	build = ':TSUpdate',

	config = function()
		local autocmd = require 'util.autocmd'
		local nvim_treesitter = require 'nvim-treesitter'

		nvim_treesitter.setup()

		local disabled_highlight_filetypes = {}
		local disabled_indent_filetypes = { 'cs' }

		-- TODO: probably should be called after the async install
		local function setup_treesitter_start_autocmd()
			local start_autocmd = autocmd.group 'treesitter-start'

			local filetypes_with_installed_parser = vim
				.iter(nvim_treesitter.get_installed())
				:map(function(lang)
					return vim.treesitter.language.get_filetypes(lang)
				end)
				:filter(function(ftype)
					return not vim.list_contains(disabled_highlight_filetypes, ftype)
				end)
				:flatten()
				:totable()

			local indentexpr_filetypes = vim
				.iter(filetypes_with_installed_parser)
				:filter(function(ftype)
					return not vim.list_contains(disabled_indent_filetypes, ftype)
				end)
				:totable()

			start_autocmd:on('FileType', filetypes_with_installed_parser, function(event)
				vim.treesitter.start(event.buf)
			end)

			start_autocmd:on('FileType', indentexpr_filetypes, function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end)
		end

		setup_treesitter_start_autocmd()

		local install_augroup = autocmd.group 'nvim-treesitter'

		install_augroup:on('UIEnter', '*', function()
			local parsers_to_install = {
				'bash',
				'editorconfig',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'json',
				'json5',
				'lua',
				'luadoc',
				'markdown',
				'markdown_inline',
				'toml',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
				'zsh',
			}

			local parsers_by_filetype = vim
				.iter({
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
					[{ 'rust' }] = { 'rust' },
					[{ 'svelte' }] = { 'svelte' },
					[{ 'vue' }] = { 'vue' },
				})
				:fold({}, function(acc, filetypes, parsers)
					for _, filetype in ipairs(filetypes) do
						acc[filetype] = parsers
					end
					return acc
				end)

			local recent_filetypes = vim.fn.uniq(vim
				.iter(vim.v.oldfiles)
				:take(8)
				:map(function(oldfile)
					local filetype = vim.filetype.match { filename = oldfile }
					return filetype
				end)
				:totable())

			local parsers_by_recent_filetypes = vim
				.iter(recent_filetypes)
				:map(function(filetype)
					return parsers_by_filetype[filetype]
				end)
				:flatten()
				:totable()

			vim.list_extend(parsers_to_install, parsers_by_recent_filetypes)
			---@diagnostic disable-next-line: cast-local-type
			parsers_to_install = vim.fn.uniq(parsers_to_install)

			nvim_treesitter.install(parsers_to_install)
		end)
	end,
}
