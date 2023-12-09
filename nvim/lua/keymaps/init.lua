if vim.g.vscode then
	require 'keymaps.vscode'
	return
end

local modules = {
	'environment',
	'motion',
	'selection',
}

for _, module in pairs(modules) do
	require('keymaps.' .. module)
end
