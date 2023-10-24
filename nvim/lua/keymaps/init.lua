local modules = {
	'default',
	'quit',
	'diagnostic',
}

for _, module in pairs(modules) do
	require('keymaps.' .. module)
end
