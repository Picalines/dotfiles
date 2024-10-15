local autocmd = require 'util.autocmd'

vim.o.autoread = true

local augroup = autocmd.group 'autoreload'

augroup:on({ 'FocusGained', 'TermLeave' }, '*', 'checktime')
