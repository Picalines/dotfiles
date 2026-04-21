local autocmd = require 'util.autocmd'
local nvim_treesitter = require 'nvim-treesitter'

---@param buf integer
---@param language string
local function try_start_treesitter(buf, language)
	if not vim.treesitter.language.add(language) then
		return
	end

	vim.treesitter.start(buf, language)

	vim.api.nvim_exec_autocmds('User', {
		pattern = 'TreeSitterStart',
		data = { buf = buf, language = language },
	})
end

local augroup = autocmd.group 'settings.treesitter'

local available_parsers = nvim_treesitter.get_available()

augroup:on('FileType', '*', function(event)
	local buf, filetype = event.buf, event.match

	local language = vim.treesitter.language.get_lang(filetype)
	if not language then
		return
	end

	local installed_parsers = nvim_treesitter.get_installed 'parsers'

	local parser_is_available = vim.tbl_contains(available_parsers, language)
	local parser_is_installed = vim.tbl_contains(installed_parsers, language)

	if not parser_is_installed and parser_is_available then
		nvim_treesitter.install(language):await(function()
			try_start_treesitter(buf, language)
		end)
	else
		try_start_treesitter(buf, language)
	end
end)

augroup:on('UIEnter', '*', function()
	nvim_treesitter.install {
		'bash',
		'diff',
		'editorconfig',
		'git_config',
		'git_rebase',
		'gitattributes',
		'gitcommit',
		'gitignore',
		'json',
		'json5',
		'kdl',
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
end)

augroup:on_user('TreeSitterStart', function(event)
	if vim.treesitter.query.get(event.data.language, 'indents') ~= nil then
		-- TODO: wait until https://github.com/neovim/neovim/issues/38818
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end)
