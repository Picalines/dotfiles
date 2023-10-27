return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
		'windwp/nvim-ts-autotag',
	},
	build = ':TSUpdate',
	config = function()
		require('nvim-treesitter.configs').setup {
			-- Add languages to be installed here that you want installed for treesitter
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

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			-- context_commentstring = {
			-- 	enable = true,
			-- 	enable_autocmd = false,
			-- },
		}
	end,
}
