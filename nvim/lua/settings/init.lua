local modules = {
	'behaviour',
	'editing',
	'environment',
	'ui',
}

for _, module in pairs(modules) do
	require('settings.' .. module)
end
