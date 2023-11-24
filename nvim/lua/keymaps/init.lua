local modules = {
	'environment',
	'motion',
	'selection',
}

for _, module in pairs(modules) do
	require('keymaps.' .. module)
end
