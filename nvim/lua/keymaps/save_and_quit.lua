local function force_quit()
    vim.cmd(':qa!')
end

local function save_and_exit()
    vim.cmd(':wa!')
    force_quit()
end

local function is_any_buffer_modified()
    for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufnr, 'modified') then
            return true
        end
    end

    return false
end

local function exit_prompt()
    if not is_any_buffer_modified() then
        save_and_exit()
        return
    end

    vim.ui.input({ prompt = 'Save and quit? y/N:' }, function(input)
        if string.lower(input or '') == 'y' then
            save_and_exit()
        end
    end)
end

vim.keymap.set('n', '<leader>q', exit_prompt, { desc = 'Save and [Q]uit' })

vim.keymap.set('n', '<leader>Q', force_quit, { desc = 'Force [Q]uit' })

