local func = require 'util.func'

local M = {}

function M.switch(app_funcs)
	for app, f in pairs(app_funcs) do
		if type(app) == 'table' then
			for _, iapp in ipairs(app) do
				app_funcs[iapp] = f
			end
		end
	end

	app_funcs = func.default_opts(app_funcs, {
		nvim = func.noop,
		vscode = func.noop,
		neovide = func.noop,
		terminal = func.noop,
	})

	if vim.g.vscode then
		app_funcs.vscode()
	else
		app_funcs.nvim()

		if vim.g.neovide then
			app_funcs.neovide()
		else
			app_funcs.terminal()
		end
	end
end

return M
