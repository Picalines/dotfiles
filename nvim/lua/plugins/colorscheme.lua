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

		local function set_hl_bg(hl, bg)
			vim.api.nvim_set_hl(0, hl, { bg = bg })
		end

		local function set_hl_fg(hl, fg)
			vim.api.nvim_set_hl(0, hl, { fg = fg })
		end

		local transparentHls = {
			"Normal",
			"NormalFloat",
			"NvimTreeNormal",
			"LineNr",
			"NvimTreeWinSeparator",
		}

		for _, hl in pairs(transparentHls) do
			set_hl_bg(hl, "none")
		end

		local borderHls = {
			"VertSplit",
			"NvimTreeWinSeparator",
		}

		for _, hl in pairs(borderHls) do
			set_hl_fg(hl, "#b9b9b9")
		end
	end,
}
