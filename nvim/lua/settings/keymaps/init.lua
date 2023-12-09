if vim.g.vscode then
	require 'settings.keymaps.vscode'
	return
end

local modules = {
	'environment',
	'motion',
	'selection',
}

if vim.g.neovide then
	table.insert(modules, 'neovide')
end

for _, module in pairs(modules) do
	require('settings.keymaps.' .. module)
end
