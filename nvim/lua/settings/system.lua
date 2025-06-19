vim.go.shell = (vim.fn.executable 'pwsh' == 1) and 'pwsh' or vim.go.shell
