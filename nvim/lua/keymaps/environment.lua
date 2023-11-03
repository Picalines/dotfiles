local function map_key(key, func, desc)
	return vim.keymap.set('n', key, func, { desc = desc })
end

local function cmd_f(...)
	local cmds = { ... }
	return function()
		for _, cmd in ipairs(cmds) do
			vim.cmd(cmd)
		end
	end
end

map_key('<leader>s', cmd_f ':w', '[S]ave file')

map_key('<leader>q', cmd_f(':wa!', ':qa!'), '[Q]uit and save')

map_key('<C-j>', '<C-W>j', 'Move to bottom split')
map_key('<C-k>', '<C-W>k', 'Move to upper split')
map_key('<C-h>', '<C-W>h', 'Move to left split')
map_key('<C-l>', '<C-W>l', 'Move to right split')

map_key('<S-Down>', '<C-W>-', 'Decrease window height')
map_key('<S-Up>', '<C-W>+', 'Increase window height')
map_key('<S-Left>', '<C-W><', 'Decrease window width')
map_key('<S-Right>', '<C-W>>', 'Increase window width')
