local modules = {
	'behaviour',
	'editing',
	'environment',
	'keymaps',
	'ui',
}

if vim.g.neovide then
	table.insert(modules, 'neovide')
end

for _, module in pairs(modules) do
	require('settings.' .. module)
end
