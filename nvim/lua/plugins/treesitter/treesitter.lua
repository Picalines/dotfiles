---@diagnostic disable: missing-fields

return {
	'nvim-treesitter/nvim-treesitter',

	event = { 'BufReadPre', 'BufNewFile' },

	build = ':TSUpdate',

	opts = {
		ensure_installed = {
			'c',
			'cpp',
			'go',
			'lua',
			'python',
			'rust',
			'javascript',
			'typescript',
			'tsx',
			'html',
			'css',
			'json',
			'toml',
			'yaml',
			'http',
			'java',
			'c_sharp',
			'dockerfile',
			'gitignore',
			'bash',
			'markdown',
			'vimdoc',
			'vim',
		},

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
