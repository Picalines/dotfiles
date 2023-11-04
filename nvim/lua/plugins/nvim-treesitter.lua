return {
	'nvim-treesitter/nvim-treesitter',

	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
		'windwp/nvim-ts-autotag',
	},

	build = ':TSUpdate',

	config = function()
		require('nvim-treesitter.configs').setup {
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
				'svelte',
				'vue',
				'json',
				'toml',
				'yaml',
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
			autotag = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<C-s>',
					node_incremental = '<C-s>',
					scope_incremental = '<C-s>',
					node_decremental = '<M-s>',
				},
			},

			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		}
	end,
}
