-- NOTE: netrw is needed. Without it, neovim doesn't show the download prompt at startup
vim.opt.spelllang = { 'en_us', 'ru_yo' }
vim.opt.spellfile = (vim.fn.stdpath 'config') .. '/spell/custom.utf-8.add'

vim.opt.spelloptions = { 'camel' }
