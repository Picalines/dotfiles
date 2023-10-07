return {
	'gmr458/dark_modern.nvim',
	lazy = false,
	priority = 1000,
	config = function()
		require("dark_modern").setup({
			cursorline = false,
			transparent_background = false,
			nvim_tree_darker = false,
			italic_keyword = false,
		})

		vim.cmd.colorscheme("dark_modern")

		local transparentHls = {
			"Normal",
			"NormalFloat",
			"NvimTreeNormal",
			"LineNr",
		}

		for _, hl in pairs(transparentHls) do
			vim.api.nvim_set_hl(0, hl, { bg = "none" })
		end
	end,
}

