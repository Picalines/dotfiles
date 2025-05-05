local keymap = require 'util.keymap'

local function quit()
	vim.cmd 'wa'

	for _, chan in ipairs(vim.api.nvim_list_chans()) do
		if chan.mode == 'terminal' and chan.stream == 'job' then
			vim.fn.jobstop(chan.id)
		end
	end

	vim.cmd 'qa!'
end

keymap {
	[{ 'n' }] = {
		['<leader><leader>q'] = { quit, 'Write all and quit' },
	},
}
