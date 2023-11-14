local modules = {
	'environment',
	'motion',
	'selection',
	'diagnostic',
}

for _, module in pairs(modules) do
	require('keymaps.' .. module)
end
