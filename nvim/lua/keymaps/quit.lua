local function save_and_quit()
	vim.cmd ':wa!'
	vim.cmd ':qa!'
end

local function quit_without_save()
	vim.ui.input({ prompt = 'Quit without save? y/N:' }, function(input)
		if string.lower(input or '') == 'y' then
			vim.cmd ':qa!'
		end
	end)
end

vim.keymap.set('n', '<leader>q', save_and_quit, { desc = 'Save and [Q]uit' })

vim.keymap.set('n', '<leader>Q', quit_without_save, { desc = '[Q]uit without save' })
