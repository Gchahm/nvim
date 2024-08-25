return {
    'prettier/vim-prettier',
    run = 'yarn install',
    config = function()
        vim.api.nvim_del_keymap('n', '<leader>p')
        vim.api.nvim_set_keymap('n', '<leader>pf', ':Prettier<CR>',
            { noremap = true, silent = true, desc = "Format using Prettier" })
    end
}
