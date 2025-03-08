return {
	'marilari88/neotest-vitest',

	lazy = true,
	dependencies = { 'nvim-neotest/neotest' },

	neotest_adapter = function()
		local function nearest_node_modules()
			local current_dir = vim.fn.expand '%:p:h'
			while current_dir ~= '/' do
				if vim.fn.isdirectory(current_dir .. '/node_modules') == 1 then
					return current_dir
				end
				current_dir = vim.fn.fnamemodify(current_dir, ':h')
			end
			return nil
		end

		return require 'neotest-vitest' {
			cwd = function()
				return nearest_node_modules() or vim.fn.getcwd()
			end,
		}
	end,
}
