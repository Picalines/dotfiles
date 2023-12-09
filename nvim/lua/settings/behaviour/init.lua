vim.o.clipboard = 'unnamedplus'

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.undofile = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.ignorecase = true
vim.o.smartcase = true

local modules = {
	'yank-highlight',
	'filetype',
}

for _, module in pairs(modules) do
	require('settings.behaviour.' .. module)
end
