local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

local augroup = autocmd.group 'global'

-- time before the swap file is written
vim.go.updatetime = 250

-- sync with system clipboard
vim.go.clipboard = 'unnamedplus'

-- persist undo history
vim.go.undofile = true

-- unix line endings
vim.opt_global.fileformats = { 'unix' }
vim.go.fileformat = 'unix'

-- prefer powershell on windows
if vim.fn.executable 'powershell' == 1 then
	vim.cmd [[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
		set shellquote= shellxquote=
	]]
end

-- auto refresh files
vim.go.autoread = true
augroup:on({ 'FocusGained', 'TermLeave' }, '*', 'checktime')

-- GUI
vim.o.guifont = 'Iosevka Nerd Font Mono'
vim.opt_global.guicursor = { 'n-v-c:block', 'i-ci-ve:ver25', 'r-cr:hor20', 'o:hor25', 'a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor' }

-- stop terminals before exiting editor
augroup:on('ExitPre', '*', function()
	for _, chan in ipairs(vim.api.nvim_list_chans()) do
		if chan.mode == 'terminal' and chan.stream == 'job' then
			vim.fn.jobstop(chan.id)
		end
	end
end)

-- search settings
vim.go.hlsearch = true
vim.go.incsearch = true
vim.go.ignorecase = true
vim.go.smartcase = true
vim.go.inccommand = 'split'

-- stop highlighting search on escape
augroup:on_user(
	'Dismiss',
	vim.schedule_wrap(function()
		vim.cmd 'nohlsearch'
	end)
)

keymap {
	[{ 'n' }] = {
		['<Leader><Leader>q'] = { '<Cmd>wqa<CR>', 'write all and quit' },
		['<Esc>'] = { '<Cmd>doautocmd User Dismiss<CR>', 'dismiss' },

		['u'] = { '<Cmd>undo<CR>', 'undo' },
		['U'] = { '<Cmd>redo<CR>', 'redo' },

		['y<C-g>'] = { '<Cmd>eval setreg(v:register, @%) | echo @% . " -> " . v:register<CR>', 'yank buffer path' },

		[{ 'x' }] = {
			['<Space>'] = '<Nop>',

			['<C-u>'] = '<C-u>zz',
			['<C-d>'] = '<C-d>zz',
			['n'] = 'nzzzv',
			['N'] = 'Nzzzv',

			[{ expr = true }] = {
				['k'] = "v:count == 0 ? 'gk' : 'k'",
				['j'] = "v:count == 0 ? 'gj' : 'j'",
			},
		},
	},

	[{ 'i' }] = {
		['<C-d>'] = { '<Cmd>doautocmd User Dismiss<CR>', 'dismiss' },

		['<C-b>'] = '<C-o>b',
		['<C-e>'] = '<Esc><Cmd>norm! e<CR>a',
		['<C-w>'] = '<C-o>w',

		[{ 'c' }] = {
			['<C-l>'] = '<Right>',
			['<C-h>'] = '<Left>',
			['<C-p>'] = { '<C-r><C-o>*', 'paste' },
		},
	},

	[{ 'x' }] = {
		['p'] = '"_dP',
	},

	[{ 't' }] = {
		['<C-p>'] = { '<C-\\><C-n>pi', 'paste' },
		['<Esc>'] = { '<C-\\><C-n>', 'exit terminal' },
	},

	[{ 'n', desc = 'Quickfix: %s', silent = true }] = {
		['<Leader>q'] = { ':botright copen | resize <C-r>=&lines / 3<CR><CR>', 'open' },
	},
}
