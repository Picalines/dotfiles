vim.go.shell = (vim.fn.executable 'powershell' == 1) and 'powershell -nologo' or vim.go.shell
