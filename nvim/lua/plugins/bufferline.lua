return {
	'akinsho/bufferline.nvim',

	enabled = true, -- *will* replaced by nvim-cokeline

	dependencies = {
		{ 'tiagovla/scope.nvim', opts = {} },
	},

	opts = {
		options = {
			mode = 'buffers',

			show_buffer_close_icons = false,
			show_close_icon = false,

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

		highlights = {
			offset_separator = {
				bg = {
					attribute = 'bg',
					highlight = 'NeoTreeTabActive',
				},
			},
		},
	},
}
