local modules = {
	'default',
	'editor',
	'diagnostic',
}

for _, module in pairs(modules) do
	require('keymaps.' .. module)
end
