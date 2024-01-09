local modules = {
	'buffer',
	'motion',
	'selection',
	'tab',
	'window',
}

if vim.g.vscode then
	require 'settings.keymaps.vscode'
	return
else
	table.insert(modules, 'nvim')

	if vim.g.neovide then
		table.insert(modules, 'neovide')
	end
end

for _, module in pairs(modules) do
	require('settings.keymaps.' .. module)
end
