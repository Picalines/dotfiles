vim.o.shell = (vim.fn.executable 'pwsh' == 1) and 'pwsh' or vim.o.shell
