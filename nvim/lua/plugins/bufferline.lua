return {
	'akinsho/bufferline.nvim',

	dependencies = {
		{ 'tiagovla/scope.nvim', opts = {} },
	},

	config = function()
		require('bufferline').setup {
			options = {
				mode = 'buffers',

				diagnostics = 'nvim_lsp',

				hover = {
					enabled = false,
				},

				offsets = {
					{
						filetype = 'neo-tree',
						highlight = 'NeoTreeTabActive',
						text_align = 'center',
						separator = true,
						text = function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
						end,
					},
				},
			},
		}
	end,
}
