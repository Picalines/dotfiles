return {
	'nvim-treesitter/nvim-treesitter',

	event = { 'BufReadPre', 'BufNewFile' },

	build = ':TSUpdate',

	opts = {
		auto_install = false,

		highlight = { enable = true },

		indent = { enable = true },

		incremental_selection = { enable = false },

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
			'kotlin',
			'lua',
			'markdown',
			'python',
			'regex',
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
