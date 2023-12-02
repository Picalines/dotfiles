local modules = {
	'yank-highlight',
	'filetype',
}

for _, module in pairs(modules) do
	require('behaviour.' .. module)
end
