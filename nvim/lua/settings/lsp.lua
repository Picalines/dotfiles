local func = require 'util.func'
local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.lsp'

keys 'LSP: %s' {
	map('<LocalLeader>r', 'rename') { vim.lsp.buf.rename },
	map('<LocalLeader>a', 'action') { vim.lsp.buf.code_action },

	map('<LocalLeader>ll', 'logs') {
		expr = true,
		function()
			return string.format('<Cmd>e! %s<CR>', vim.lsp.log.get_filename())
		end,
	},

	map('<LocalLeader>lR', 'restart') '<Cmd>lsp restart<CR>',

	map('<LocalLeader>lf', 'format') { vim.lsp.buf.format },
	map('<LocalLeader>lc', 'convert color') { vim.lsp.document_color.color_presentation },
	map('<LocalLeader>li', 'inlay hints') {
		function()
			local filter = { bufnr = 0 }
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
		end,
	},
}

vim.diagnostic.config {
	update_in_insert = true,
	severity_sort = true,

	virtual_text = {
		current_line = true,
	},

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅝',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},
	},

	float = {
		source = 'if_many',
		border = 'rounded',
	},
}

-- TODO: https://github.com/microsoft/pyright/issues/11408
func.once('lsp-progress-mute', function()
	local clients_with_muted_progress = {
		'basedpyright',
		'pyright',
	}

	local builtin_handler = vim.lsp.handlers['$/progress']
	vim.lsp.handlers['$/progress'] = function(err, result, ctx, config)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client and vim.tbl_contains(clients_with_muted_progress, client.name) then
			return
		end
		builtin_handler(err, result, ctx, config)
	end
end)

vim.lsp.enable {
	'basedpyright',
	'bashls',
	'biome',
	'cssls',
	'docker_compose_language_service',
	'dockerls',
	'eslint',
	'graphql',
	'html',
	'jsonls',
	'lua_ls',
	'rust_analyzer',
	'stylelint_lsp',
	'tailwindcss',
	'tombi',
	'ts_query_ls',
	'tsgo',
	'vimls',
	'vtsls',
	'yamlls',
}

vim.lsp.config('lua_ls', {
	settings = {
		Lua = { telemetry = { enable = false } },
	},
})

vim.lsp.config('jsonls', {
	settings = {
		json = {
			validate = { enable = true },
			keepLines = { enable = true },
		},
	},
})

vim.lsp.config('vtsls', {
	settings = {
		typescript = {
			preferences = {
				preferTypeOnlyAutoImports = true,
			},
		},
	},
})

vim.lsp.config('tsgo', {
	settings = {
		typescript = {
			preferences = {
				preferTypeOnlyAutoImports = true,
				importModuleSpecifier = 'non-relative',
			},
		},
	},
})

vim.lsp.config('tailwindcss', {
	settings = {
		tailwindCSS = {
			classFunctions = { 'tw', 'clsx', 'cva', 'cn' },
			classAttributes = { 'class', 'className', 'ngClass', 'class:list' },
		},
	},
})

vim.lsp.config('stylelint_lsp', {
	settings = {
		stylelint = {
			validate = { 'css', 'postcss', 'scss', 'less' },
			snippet = { 'css', 'postcss', 'scss', 'less' },
		},
	},
})

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			cargo = { features = 'all' },
		},
	},
})

vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT',
				path = { 'lua/?.lua', 'lua/?/init.lua' },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
				},
			},
		})
	end,
})
