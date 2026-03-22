local autocmd = require 'util.autocmd'
local keymap = require 'mappet'

local map, sub = keymap.map, keymap.sub

local augroup = autocmd.group 'global'
local keys = keymap.group 'settings.global'

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

keys { 'n' } {
	map('<Leader><Leader>q', 'write all and quit') '<Cmd>wqa<CR>',
	map('<Esc>', 'dismiss') '<Cmd>doautocmd User Dismiss<CR>',

	map('u', 'undo') '<Cmd>undo<CR>',
	map('U', 'redo') '<Cmd>redo<CR>',

	map('y<C-g>', 'yank buffer path') {
		'<Cmd>eval setreg(v:register, @%) | echo @% . " -> " . v:register<CR>',
	},

	sub { 'x' } {
		map '<Space>' '<Nop>',

		map '<C-u>' '<C-u>zz',
		map '<C-d>' '<C-d>zz',
		map 'n' 'nzzzv',
		map 'N' 'Nzzzv',

		sub { expr = true } {
			map 'k' "v:count == 0 ? 'gk' : 'k'",
			map 'j' "v:count == 0 ? 'gj' : 'j'",
		},
	},
}

keys { 'i' } {
	map('<C-d>', 'dismiss') '<Cmd>doautocmd User Dismiss<CR>',

	map '<C-b>' '<C-o>b',
	map '<C-e>' '<Esc><Cmd>norm! e<CR>a',
	map '<C-w>' '<C-o>w',

	sub { 'c' } {
		map '<C-l>' '<Right>',
		map '<C-h>' '<Left>',
		map('<C-p>', 'paste') '<C-r><C-o>*',
	},
}

keys { 'x' } {
	map 'p' '"_dP',
}

keys { 't' } {
	map('<C-p>', 'paste') '<C-\\><C-n>pi',
	map('<Esc>', 'exit terminal') '<C-\\><C-n>',
}

keys('Quickfix: %s', { silent = true }) {
	map('<Leader>q', 'open') ':botright copen | resize <C-r>=&lines / 3<CR><CR>',
}
