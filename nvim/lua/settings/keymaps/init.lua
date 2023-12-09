if vim.g.vscode then
	require 'settings.keymaps.vscode'
	return
end

local modules = {
	'environment',
	'motion',
	'selection',
}

for _, module in pairs(modules) do
	require('settings.keymaps.' .. module)
end
