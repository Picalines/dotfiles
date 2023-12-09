local modules = {
	'behaviour',
	'editing',
	'environment',
	'keymaps',
	'ui',
}

for _, module in pairs(modules) do
	require('settings.' .. module)
end
