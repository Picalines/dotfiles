local modules = {
	'environment',
	'motion',
	'selection',
	'window',
}

if vim.g.vscode then
	table.insert(modules, 'vscode')
else
	table.insert(modules, 'nvim')
end

if vim.g.neovide then
	table.insert(modules, 'neovide')
end

for _, module in pairs(modules) do
	require('settings.keymaps.' .. module)
end
