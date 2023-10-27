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

map_key('<leader>qs', cmd_f(':wa!', ':qa!'), '[Q]uit and [S]ave')
map_key('<leader>qdd', cmd_f ':qa!', '[Q]uit and [D]elete')
