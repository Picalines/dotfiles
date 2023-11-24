local modules = {
	'yank-highlight',
}

for _, module in pairs(modules) do
	require('behaviour.' .. module)
end
