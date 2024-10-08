---@diagnostic disable: missing-fields

return {
	'nvim-treesitter/nvim-treesitter',

	event = { 'BufReadPre', 'BufNewFile' },

	build = ':TSUpdate',

	opts = {
		auto_install = false,

		highlight = { enable = true },

		indent = { enable = true },

		incremental_selection = {
			enable = false,
			keymaps = {
				init_selection = 'vn',
				node_incremental = 'n',
				scope_incremental = false,
				node_decremental = 'N',
			},
		},

		ensure_installed = {
			'bash',
			'c',
			'c_sharp',
			'cpp',
			'css',
			'dockerfile',
			'gitignore',
			'go',
			'graphql',
			'html',
			'http',
			'java',
			'javascript',
			'json',
			'lua',
			'markdown',
			'python',
			'rust',
			'svelte',
			'toml',
			'tsx',
			'typescript',
			'vim',
			'vimdoc',
			'yaml',
		},
	},

	config = function(_, opts)
		require('nvim-treesitter.configs').setup(opts)
	end,

	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',

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
	},
}
